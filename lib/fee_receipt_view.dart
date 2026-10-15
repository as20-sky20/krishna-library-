import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_data.dart';
import 'receipt_printer_helper.dart';
import 'whatsapp_url_helper.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);
const gold = Color(0xFFD4AF37);

/// Standardized Library Fee Receipt Data Model
class LibraryReceipt {
  final String receiptNo;
  final String dateTime;
  final String memberId;
  final String memberName;
  final String phone;
  final int seatNo;
  final String exam;
  final String shift;
  final String plan;
  final int amount;
  final String paymentMode;
  final String utr;
  final String validFrom;
  final String validUntil;
  final String status;
  final String adminPayee;
  final String adminUpi;

  LibraryReceipt({
    required this.receiptNo,
    required this.dateTime,
    required this.memberId,
    required this.memberName,
    required this.phone,
    required this.seatNo,
    required this.exam,
    required this.shift,
    required this.plan,
    required this.amount,
    required this.paymentMode,
    required this.utr,
    required this.validFrom,
    required this.validUntil,
    required this.status,
    required this.adminPayee,
    required this.adminUpi,
  });

  factory LibraryReceipt.fromTransaction(FeeTransaction txn) {
    final member = AdminData.getMemberById(txn.memberId) ??
        AdminData.members.firstWhere(
          (m) => m.name.toLowerCase() == txn.memberName.toLowerCase(),
          orElse: () => AdminData.members.first,
        );

    return LibraryReceipt(
      receiptNo: txn.receiptNo,
      dateTime: txn.dateTime,
      memberId: txn.memberId,
      memberName: txn.memberName,
      phone: member.phone,
      seatNo: txn.seatNo,
      exam: member.exam,
      shift: member.shift,
      plan: txn.plan,
      amount: txn.amount,
      paymentMode: txn.paymentMode,
      utr: txn.utr,
      validFrom: txn.dateTime.split(',').first.trim(),
      validUntil: member.dueDate,
      status: txn.status,
      adminPayee: AdminData.adminMerchantTitle,
      adminUpi: AdminData.adminUpiId,
    );
  }

  factory LibraryReceipt.fromMember(MemberRecord m, [FeeTransaction? txn]) {
    final matchingTxn = txn ??
        AdminData.transactions.firstWhere(
          (t) => t.memberId == m.id,
          orElse: () => FeeTransaction(
            txnId: 'KL-TXN-${m.seatNo}08492',
            memberId: m.id,
            memberName: m.name,
            seatNo: m.seatNo,
            amount: m.amount,
            plan: m.plan,
            paymentMode: m.paymentMode,
            utr: 'UPI59${m.seatNo}8172940',
            dateTime: '14 Oct 2026, 09:15 AM',
            status: 'Received by Admin Kamal ✓',
            receiptNo: 'REC-2026-${(m.seatNo + 70).toString().padLeft(3, '0')}',
          ),
        );

    return LibraryReceipt(
      receiptNo: matchingTxn.receiptNo,
      dateTime: matchingTxn.dateTime,
      memberId: m.id,
      memberName: m.name,
      phone: m.phone,
      seatNo: m.seatNo,
      exam: m.exam,
      shift: m.shift,
      plan: m.plan,
      amount: m.amount,
      paymentMode: m.paymentMode,
      utr: matchingTxn.utr,
      validFrom: '01 Oct 2026',
      validUntil: m.dueDate,
      status: 'Paid & Verified ✓',
      adminPayee: AdminData.adminMerchantTitle,
      adminUpi: AdminData.adminUpiId,
    );
  }

  String get amountInWords {
    if (amount == 1000) return 'Rupees One Thousand Only (एक हज़ार रुपये मात्र)';
    if (amount == 700) return 'Rupees Seven Hundred Only (सात सौ रुपये मात्र)';
    if (amount == 500) return 'Rupees Five Hundred Only (पाँच सौ रुपये मात्र)';
    return 'Rupees $amount Only';
  }
}

/// Open the official full-featured Krishna Library Fee Receipt modal
void showOfficialFeeReceiptSheet(
  BuildContext context, {
  FeeTransaction? transaction,
  MemberRecord? member,
  VoidCallback? onStateChange,
}) {
  final LibraryReceipt receipt;
  if (transaction != null) {
    receipt = LibraryReceipt.fromTransaction(transaction);
  } else {
    final m = member ?? AdminData.getMemberById('KL-0248') ?? AdminData.members.first;
    receipt = LibraryReceipt.fromMember(m);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _FeeReceiptModalContent(
      receipt: receipt,
      onStateChange: onStateChange,
    ),
  );
}

class _FeeReceiptModalContent extends StatefulWidget {
  final LibraryReceipt receipt;
  final VoidCallback? onStateChange;

  const _FeeReceiptModalContent({
    required this.receipt,
    this.onStateChange,
  });

  @override
  State<_FeeReceiptModalContent> createState() => _FeeReceiptModalContentState();
}

class _FeeReceiptModalContentState extends State<_FeeReceiptModalContent> {
  late LibraryReceipt currentReceipt;

  @override
  void initState() {
    super.initState();
    currentReceipt = widget.receipt;
  }

  void _triggerPrint() {
    final html = _generateReceiptHtml(currentReceipt);
    ReceiptPrinterHelper.printReceipt(html);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print preview opened! Choose "Save as PDF" to download receipt.'),
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _triggerDownload() {
    final html = _generateReceiptHtml(currentReceipt);
    final filename = 'Krishna_Library_Receipt_${currentReceipt.receiptNo}.html';
    ReceiptPrinterHelper.downloadReceipt(filename: filename, htmlContent: html);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt downloaded: $filename'),
        backgroundColor: green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _triggerWhatsAppShare() {
    final message = _generateWhatsAppReceiptText(currentReceipt);
    WhatsAppLauncher.openChat(phone: currentReceipt.phone, message: message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp with receipt for ${currentReceipt.memberName}...'),
        backgroundColor: const Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyReceiptText() {
    final text = _generateWhatsAppReceiptText(currentReceipt);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt details copied to clipboard!'),
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = currentReceipt;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        children: [
          // Modal Top Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.receipt_long, color: green, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Official Fee Receipt (फीस रसीद)',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: navy),
                      ),
                      Text(
                        'Verified & Downloadable Student Copy • Krishna Library',
                        style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Receipt Document
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Header Strip
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [navy, Color(0xFF1A3B5D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFFF2B84B), width: 1.5),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.school, color: Color(0xFFF2B84B), size: 24),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'KRISHNA LIBRARY',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        Text(
                                          'PREMIUM SELF-STUDY LOUNGE & READING HALL',
                                          style: TextStyle(
                                            color: Color(0xFFF2B84B),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 9.5,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        Text(
                                          'Govt Regd. No: HR-HIS-2024-8849 • Branch 01',
                                          style: TextStyle(color: Colors.white70, fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'PAID ✓',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('📍 Main Market Road, Opp. Govt College', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                                    Text('📞 +91 98123 45678', style: TextStyle(color: Colors.white70, fontSize: 9.5, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Receipt Serial & Date Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          color: const Color(0xFFF1F5F9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('RECEIPT NO.', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                  Text(
                                    r.receiptNo,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      color: navy,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('ISSUE DATE & TIME', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                  Text(
                                    r.dateTime,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: navy),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Student & Desk Allotment Info
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STUDENT & ALLOTMENT PARTICULARS (छात्र विवरण)',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blueGrey,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  children: [
                                    _buildReceiptRow('Student Name:', r.memberName, isBold: true),
                                    const Divider(height: 12),
                                    _buildReceiptRow('Member ID:', r.memberId, color: blue, isBold: true),
                                    const Divider(height: 12),
                                    _buildReceiptRow(
                                      'Allotted Seat Desk:',
                                      'Desk S-${r.seatNo.toString().padLeft(2, '0')} (Fixed Cubicle)',
                                      color: purple,
                                      isBold: true,
                                    ),
                                    const Divider(height: 12),
                                    _buildReceiptRow('Shift Period:', r.shift),
                                    const Divider(height: 12),
                                    _buildReceiptRow('Course / Exam:', r.exam),
                                    const Divider(height: 12),
                                    _buildReceiptRow('Registered Phone:', r.phone),
                                    const Divider(height: 12),
                                    _buildReceiptRow(
                                      'Membership Valid Till:',
                                      r.validUntil,
                                      color: green,
                                      isBold: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Itemized Charges Table
                              const Text(
                                'FEE BREAKDOWN & FACILITIES (शुल्क विवरण)',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blueGrey,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    // Table Header
                                    Container(
                                      color: const Color(0xFFF1F5F9),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text('FACILITY DESCRIPTION', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text('PERIOD', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.center),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text('AMOUNT', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.right),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildTableLine(
                                      '1. Dedicated Reading Desk (Desk S-${r.seatNo.toString().padLeft(2, '0')})',
                                      '1 Month',
                                      '₹${r.amount - 100}',
                                    ),
                                    const Divider(height: 1),
                                    _buildTableLine(
                                      '2. 24x7 Inverter & AC Power Backup',
                                      'Standard',
                                      '₹100',
                                    ),
                                    const Divider(height: 1),
                                    _buildTableLine(
                                      '3. High-Speed 5G Optical Fiber Wi-Fi',
                                      'Unlimited',
                                      'FREE',
                                      isFree: true,
                                    ),
                                    const Divider(height: 1),
                                    _buildTableLine(
                                      '4. RO Chilled Drinking Water & Locker Access',
                                      'Included',
                                      'FREE',
                                      isFree: true,
                                    ),
                                    const Divider(height: 1),
                                    _buildTableLine(
                                      '5. Digital ID Smart Pass & Entry Attendance',
                                      'Lifetime',
                                      'FREE',
                                      isFree: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Total Paid Banner
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: green.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: green.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('TOTAL AMOUNT PAID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                            Text('(कुल जमा राशि)', style: TextStyle(fontSize: 9.5, color: Colors.blueGrey)),
                                          ],
                                        ),
                                        Text(
                                          '₹${r.amount}.00',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 14),
                                    Row(
                                      children: [
                                        const Text('In Words: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                        Expanded(
                                          child: Text(
                                            r.amountInWords,
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: navy),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Payment Verification Box
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: Column(
                                  children: [
                                    _buildReceiptRow('Payment Mode:', r.paymentMode, isBold: true),
                                    const Divider(height: 10),
                                    _buildReceiptRow('Bank UTR / Ref No:', r.utr, color: purple, isBold: true),
                                    const Divider(height: 10),
                                    _buildReceiptRow('Credited Direct To:', '${AdminData.adminName} (Library Admin)'),
                                    const Divider(height: 10),
                                    _buildReceiptRow('Admin UPI ID:', AdminData.adminUpiId),
                                    const Divider(height: 10),
                                    _buildReceiptRow('Transaction Status:', 'SUCCESS / CONFIRMED ✓', color: green, isBold: true),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Barcode, Verification QR & Kamal Signature
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Verification QR Stamp
                                  Container(
                                    width: 70,
                                    height: 70,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: CustomPaint(
                                      painter: _ReceiptQrPainter(seed: r.receiptNo.hashCode),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Barcode & Verification info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomPaint(
                                          size: const Size(160, 22),
                                          painter: _ReceiptBarcodePainter(),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '*${r.receiptNo}-${r.memberId}*',
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Scan QR to verify authentic library audit slip',
                                          style: TextStyle(fontSize: 8, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Authorized Sign & Seal
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: gold.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: gold),
                                        ),
                                        child: const Text(
                                          'SEAL OF DIRECT',
                                          style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w900, color: Color(0xFFB8860B)),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Kamal',
                                        style: TextStyle(
                                          fontFamily: 'cursive',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: navy,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Container(height: 1, width: 85, color: navy.withValues(alpha: 0.3)),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Director (Kamal)',
                                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                      ),
                                      const Text(
                                        'Krishna Library',
                                        style: TextStyle(fontSize: 7.5, color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Terms & Disclaimer
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TERMS & CONDITIONS (नियम एवं शर्तें):', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: navy)),
                                    SizedBox(height: 3),
                                    Text('1. Fees once paid is strictly non-refundable and non-transferable.', style: TextStyle(fontSize: 8, color: Colors.blueGrey)),
                                    Text('2. Keep this receipt / pass handy for daily entry gate verification.', style: TextStyle(fontSize: 8, color: Colors.blueGrey)),
                                    Text('3. Absolute silence must be maintained in the study cubicles at all times.', style: TextStyle(fontSize: 8, color: Colors.blueGrey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -3)),
              ],
            ),
            child: Row(
              children: [
                // Print / Save as PDF Button
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.print, size: 18),
                    label: const Text('Print / Save PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: _triggerPrint,
                  ),
                ),
                const SizedBox(width: 8),

                // Download File Button
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blue,
                      side: const BorderSide(color: blue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: _triggerDownload,
                  ),
                ),
                const SizedBox(width: 8),

                // WhatsApp Share Button
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.chat, size: 18),
                    label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: _triggerWhatsAppShare,
                  ),
                ),
                const SizedBox(width: 6),

                // Copy Text Button
                IconButton(
                  tooltip: 'Copy details',
                  icon: const Icon(Icons.copy, color: navy),
                  onPressed: _copyReceiptText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: color ?? navy,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTableLine(String description, String period, String amount, {bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(description, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: navy)),
          ),
          Expanded(
            flex: 2,
            child: Text(period, style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: isFree ? green : navy,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Generates formatted WhatsApp notice text for fee receipt
String _generateWhatsAppReceiptText(LibraryReceipt r) {
  return '''🏛️ *KRISHNA LIBRARY & STUDY LOUNGE*
*OFFICIAL DIGITAL FEE RECEIPT*
━━━━━━━━━━━━━━━━━━━━━━━
📄 *Receipt No:* ${r.receiptNo}
📅 *Issue Date:* ${r.dateTime}
👤 *Student:* ${r.memberName} (${r.memberId})
🪑 *Assigned Desk:* Desk S-${r.seatNo.toString().padLeft(2, '0')} (Fixed Cubicle)
⏱️ *Shift:* ${r.shift}
🎯 *Exam Target:* ${r.exam}
💰 *Amount Paid:* ₹${r.amount} (PAID & VERIFIED ✓)
💳 *Payment Mode:* ${r.paymentMode}
🔢 *UTR Ref No:* ${r.utr}
🗓️ *Valid Till:* ${r.validUntil}
🏢 *Direct Payee:* ${AdminData.adminMerchantTitle}
━━━━━━━━━━━━━━━━━━━━━━━
✅ *Status: FEES RECEIVED BY ADMIN KAMAL*
🔖 *Gate Entry Pass: ACTIVE & VERIFIED*
📍 *Address:* Branch 01, Main Market Road, Opp. Govt College
📞 *Helpline:* ${AdminData.adminPhone}

_Thank you for choosing Krishna Library! Best wishes for your exam preparation._''';
}

/// Generates self-contained, clean HTML printable page for browser Print/PDF download
String _generateReceiptHtml(LibraryReceipt r) {
  return '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Receipt_${r.receiptNo}_Krishna_Library</title>
<style>
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    background: #f1f5f9;
    color: #102a43;
    margin: 0;
    padding: 24px;
    display: flex;
    justify-content: center;
  }
  .receipt-card {
    background: #ffffff;
    max-width: 650px;
    width: 100%;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.08);
    overflow: hidden;
  }
  .header {
    background: #102a43;
    color: #ffffff;
    padding: 24px;
    text-align: center;
    border-bottom: 4px solid #f2b84b;
  }
  .header h1 {
    margin: 0;
    font-size: 24px;
    letter-spacing: 1.5px;
    font-weight: 900;
  }
  .header .tagline {
    color: #f2b84b;
    font-size: 11px;
    font-weight: 700;
    margin-top: 4px;
    letter-spacing: 1px;
  }
  .header .address {
    font-size: 11px;
    color: #cbd5e1;
    margin-top: 6px;
  }
  .meta-bar {
    background: #f8fafc;
    border-bottom: 1px solid #e2e8f0;
    padding: 12px 24px;
    display: flex;
    justify-content: space-between;
    font-size: 12px;
  }
  .meta-bar strong {
    font-family: monospace;
    font-size: 14px;
    color: #102a43;
  }
  .content {
    padding: 24px;
  }
  .section-title {
    font-size: 11px;
    font-weight: 800;
    color: #627d98;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-bottom: 8px;
    margin-top: 16px;
  }
  table.info-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 16px;
    background: #f8fafc;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
  }
  table.info-table td {
    padding: 8px 12px;
    font-size: 12px;
    border-bottom: 1px solid #e2e8f0;
  }
  table.info-table td.label {
    color: #627d98;
    width: 35%;
  }
  table.info-table td.val {
    font-weight: 700;
    color: #102a43;
  }
  table.items-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 16px;
    border: 1px solid #e2e8f0;
  }
  table.items-table th {
    background: #f1f5f9;
    padding: 10px 12px;
    font-size: 11px;
    text-align: left;
    color: #486581;
    border-bottom: 1px solid #cbd5e1;
  }
  table.items-table td {
    padding: 10px 12px;
    font-size: 12px;
    border-bottom: 1px solid #f1f5f9;
  }
  .total-box {
    background: #eefcf6;
    border: 1px solid #a3e9c9;
    padding: 16px;
    border-radius: 8px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
  }
  .total-box .amount {
    font-size: 24px;
    font-weight: 900;
    color: #269c70;
  }
  .footer-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-top: 24px;
    padding-top: 16px;
    border-top: 1px dashed #cbd5e1;
  }
  .stamp {
    border: 2px solid #269c70;
    color: #269c70;
    padding: 6px 12px;
    border-radius: 6px;
    font-weight: 900;
    font-size: 12px;
    display: inline-block;
  }
  .signature {
    text-align: right;
  }
  .signature .name {
    font-family: "Brush Script MT", cursive, sans-serif;
    font-size: 26px;
    color: #102a43;
    line-height: 1;
  }
  .signature .role {
    font-size: 10px;
    color: #627d98;
    margin-top: 4px;
    border-top: 1px solid #9fb3c8;
    padding-top: 2px;
  }
  .disclaimer {
    background: #f1f5f9;
    padding: 10px 14px;
    font-size: 10px;
    color: #627d98;
    border-radius: 6px;
    margin-top: 20px;
  }
  @media print {
    body {
      background: #ffffff;
      padding: 0;
    }
    .receipt-card {
      border: none;
      box-shadow: none;
    }
  }
</style>
</head>
<body>
<div class="receipt-card">
  <div class="header">
    <h1>KRISHNA LIBRARY</h1>
    <div class="tagline">PREMIUM SELF-STUDY LOUNGE &amp; READING HALL</div>
    <div class="address">Branch 01, Main Market Road, Opp. Govt College • Helpline: +91 98123 45678<br>Govt Regd. No: HR-HIS-2024-8849</div>
  </div>
  <div class="meta-bar">
    <div>RECEIPT NO: <strong>${r.receiptNo}</strong></div>
    <div>ISSUE DATE: <strong>${r.dateTime}</strong></div>
  </div>
  <div class="content">
    <div class="section-title">Student &amp; Desk Particulars</div>
    <table class="info-table">
      <tr>
        <td class="label">Student Name</td>
        <td class="val">${r.memberName} (${r.memberId})</td>
      </tr>
      <tr>
        <td class="label">Allotted Seat</td>
        <td class="val">Desk S-${r.seatNo.toString().padLeft(2, '0')} (Fixed Study Desk)</td>
      </tr>
      <tr>
        <td class="label">Membership Shift</td>
        <td class="val">${r.shift}</td>
      </tr>
      <tr>
        <td class="label">Target Exam</td>
        <td class="val">${r.exam}</td>
      </tr>
      <tr>
        <td class="label">Valid Until</td>
        <td class="val" style="color:#269c70">${r.validUntil}</td>
      </tr>
    </table>

    <div class="section-title">Facility &amp; Fee Details</div>
    <table class="items-table">
      <thead>
        <tr>
          <th>Description</th>
          <th>Period</th>
          <th style="text-align:right">Amount</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Dedicated Desk Seat Fee</td>
          <td>1 Month</td>
          <td style="text-align:right">₹${r.amount - 100}.00</td>
        </tr>
        <tr>
          <td>24x7 Power Backup &amp; Air Conditioning</td>
          <td>Standard</td>
          <td style="text-align:right">₹100.00</td>
        </tr>
        <tr>
          <td>High-Speed 5G Optical Fiber Wi-Fi</td>
          <td>Unlimited</td>
          <td style="text-align:right;color:#269c70;font-weight:700">INCLUDED</td>
        </tr>
        <tr>
          <td>Chilled RO Drinking Water &amp; Locker Access</td>
          <td>Complimentary</td>
          <td style="text-align:right;color:#269c70;font-weight:700">INCLUDED</td>
        </tr>
      </tbody>
    </table>

    <div class="total-box">
      <div>
        <div style="font-size:11px;color:#486581;font-weight:bold">TOTAL AMOUNT PAID</div>
        <div style="font-size:11px;color:#269c70;font-weight:600">${r.amountInWords}</div>
      </div>
      <div class="amount">₹${r.amount}.00</div>
    </div>

    <div class="section-title">Payment Verification</div>
    <table class="info-table">
      <tr>
        <td class="label">Payment Mode</td>
        <td class="val">${r.paymentMode}</td>
      </tr>
      <tr>
        <td class="label">Bank UTR / Ref No</td>
        <td class="val" style="font-family:monospace;color:#6d5dd3">${r.utr}</td>
      </tr>
      <tr>
        <td class="label">Direct Payee</td>
        <td class="val">${AdminData.adminMerchantTitle} (${AdminData.adminUpiId})</td>
      </tr>
      <tr>
        <td class="label">Status</td>
        <td class="val" style="color:#269c70">PAID &amp; CONFIRMED ✓</td>
      </tr>
    </table>

    <div class="footer-row">
      <div class="stamp">OFFICIALLY AUDITED &amp; VERIFIED</div>
      <div class="signature">
        <div class="name">Kamal</div>
        <div class="role">Authorized Director (Kamal)<br>Krishna Library Administration</div>
      </div>
    </div>

    <div class="disclaimer">
      <strong>Terms &amp; Conditions:</strong><br>
      1. Fee once deposited is strictly non-refundable and non-transferable under any circumstances.<br>
      2. Please carry this receipt or student digital gate pass during library entrance inspection.<br>
      3. Maintain complete silence inside the study hall.
    </div>
  </div>
</div>
<script>
  window.onload = function() {
    window.focus();
  }
</script>
</body>
</html>''';
}

/// Simulated Procedural QR Painter for Receipt
class _ReceiptQrPainter extends CustomPainter {
  final int seed;
  _ReceiptQrPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = navy
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    void drawBox(double x, double y, double s) {
      canvas.drawRect(Rect.fromLTWH(x, y, s, s), paint);
      canvas.drawRect(Rect.fromLTWH(x + s * 0.2, y + s * 0.2, s * 0.6, s * 0.6), Paint()..color = Colors.white);
      canvas.drawRect(Rect.fromLTWH(x + s * 0.35, y + s * 0.35, s * 0.3, s * 0.3), paint);
    }

    final corner = w * 0.3;
    drawBox(0, 0, corner);
    drawBox(w - corner, 0, corner);
    drawBox(0, h - corner, corner);

    final rng = Random(seed);
    final dot = w * 0.08;
    for (double y = dot; y < h - dot; y += dot) {
      for (double x = dot; x < w - dot; x += dot) {
        if ((x < corner && y < corner) || (x > w - corner && y < corner) || (x < corner && y > h - corner)) {
          continue;
        }
        if (rng.nextBool()) {
          canvas.drawRect(Rect.fromLTWH(x + 1, y + 1, dot - 2, dot - 2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ReceiptQrPainter oldDelegate) => oldDelegate.seed != seed;
}

/// Simulated Barcode Painter for Receipt
class _ReceiptBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = navy..style = PaintingStyle.fill;
    final widths = [
      2.0, 1.0, 3.0, 1.0, 4.0, 1.0, 2.0, 3.0, 1.0, 4.0, 2.0, 1.0, 3.0, 2.0,
      1.0, 4.0, 1.0, 2.0, 3.0, 1.0, 3.0, 2.0, 1.0, 4.0, 2.0, 1.0, 3.0, 2.0
    ];
    double x = 0;
    bool isBar = true;
    for (final w in widths) {
      if (x + w > size.width) break;
      if (isBar) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      }
      x += w;
      isBar = !isBar;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
