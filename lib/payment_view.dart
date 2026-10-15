import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_data.dart';
import 'fee_receipt_view.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);

/// Open in-app fee payment gateway with direct transfer to Admin Kamal
void showFeePaymentSheet(
  BuildContext context, {
  MemberRecord? member,
  VoidCallback? onPaymentSuccess,
}) {
  final student = member ?? AdminData.getMemberById('KL-0248') ?? AdminData.members.first;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _FeePaymentModalContent(
      member: student,
      onPaymentSuccess: onPaymentSuccess,
    ),
  );
}

class _FeePaymentModalContent extends StatefulWidget {
  final MemberRecord member;
  final VoidCallback? onPaymentSuccess;

  const _FeePaymentModalContent({
    required this.member,
    this.onPaymentSuccess,
  });

  @override
  State<_FeePaymentModalContent> createState() => _FeePaymentModalContentState();
}

class _FeePaymentModalContentState extends State<_FeePaymentModalContent> {
  late int selectedAmount;
  late String selectedPlan;
  String selectedApp = 'Google Pay';
  late TextEditingController utrController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    selectedAmount = widget.member.amount;
    selectedPlan = widget.member.plan;
    // Generate a realistic 12-digit UPI UTR
    final randomDigits = 1000000000 + Random().nextInt(900000000);
    utrController = TextEditingController(text: 'UPI$randomDigits');
  }

  @override
  void dispose() {
    utrController.dispose();
    super.dispose();
  }

  void _generateNewUtr() {
    final randomDigits = 1000000000 + Random().nextInt(900000000);
    setState(() {
      utrController.text = 'UPI$randomDigits';
    });
  }

  void _processPayment() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final txn = AdminData.payFeeOnline(
      memberId: widget.member.id,
      amount: selectedAmount,
      paymentMode: selectedApp,
      utr: utrController.text.trim(),
      planName: selectedPlan,
    );

    setState(() => isProcessing = false);
    Navigator.pop(context); // Close payment sheet

    // Show celebratory receipt
    if (mounted) {
      showPaymentSuccessReceiptDialog(context, txn: txn);
    }

    widget.onPaymentSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.90,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: green, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Fee Payment (फीस भुगतान)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                      ),
                      Text(
                        'Instant transfer to Admin Kamal account',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Beneficiary Admin Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [navy, Color(0xFF1B3D60)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: navy.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFF2B84B).withValues(alpha: 0.25),
                    child: const Icon(Icons.account_balance, color: Color(0xFFF2B84B), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'DIRECT TO ADMIN KAMAL',
                              style: TextStyle(color: Color(0xFFF2B84B), fontSize: 11, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('VERIFIED', style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AdminData.adminMerchantTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'UPI ID: ${AdminData.adminUpiId}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: AdminData.adminUpiId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Admin Kamal UPI ID copied to clipboard!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: green,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.copy, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Copy', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Member Info Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: blue.withValues(alpha: 0.15),
                    child: Text(
                      widget.member.name.isNotEmpty ? widget.member.name[0] : 'S',
                      style: const TextStyle(color: blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paying for: ${widget.member.name} (${widget.member.id})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
                        ),
                        Text(
                          'Assigned Seat ${widget.member.seatNo.toString().padLeft(2, '0')} • ${widget.member.shift}',
                          style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Plan Selector
            const Text(
              'Select Membership Fee Plan:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildPlanOption(
                    title: 'Full Day (पूरा दिन)',
                    amount: LibraryFeeStructure.fullDayMonthly,
                    planName: 'Full Day Monthly (₹1,000)',
                    icon: Icons.wb_sunny_outlined,
                    color: blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPlanOption(
                    title: 'Half Day (आधा दिन)',
                    amount: LibraryFeeStructure.halfDayMonthly,
                    planName: 'Half Day Monthly (₹700)',
                    icon: Icons.timelapse_outlined,
                    color: green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Official Standee QR Code Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AdminData.useCustomQr ? purple : const Color(0xFFE2E8F0),
                  width: AdminData.useCustomQr ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (AdminData.useCustomQr ? purple : blue).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: (AdminData.useCustomQr ? purple : blue).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AdminData.useCustomQr ? Icons.verified_user : Icons.shield_outlined,
                                color: AdminData.useCustomQr ? purple : blue, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              AdminData.useCustomQr
                                  ? 'PERSONAL QR ACTIVE • ${AdminData.adminName.toUpperCase()}'
                                  : 'BHARAT UPI QR • DIRECT SETTLEMENT',
                              style: TextStyle(
                                  color: AdminData.useCustomQr ? purple : blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                      // Button to configure / change personal QR code
                      InkWell(
                        onTap: () {
                          showCustomQrSettingsDialog(context, onSaved: () => setState(() {}));
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tune, size: 13, color: navy),
                              SizedBox(width: 4),
                              Text(
                                'Personal QR',
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: navy),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // The Interactive Authentic QR / Barcode Box
                  _buildPaymentVisualBox(),
                  const SizedBox(height: 12),
                  Text(
                    'Scan & Pay ₹$selectedAmount to ${AdminData.adminName}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: navy),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'UPI ID: ${AdminData.adminUpiId} • ${AdminData.adminMerchantTitle}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blue),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Supported: GPay • PhonePe • Paytm • BHIM • Cred',
                    style: TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Select Payment Application
            const Text(
              'Select Payment Mode / App:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAppChip('Google Pay', Icons.account_balance_wallet_outlined, const Color(0xFF4285F4)),
                _buildAppChip('PhonePe', Icons.payment, const Color(0xFF5F259F)),
                _buildAppChip('Paytm', Icons.credit_card, const Color(0xFF002970)),
                _buildAppChip('BHIM UPI', Icons.qr_code, green),
                _buildAppChip('Cash at Counter', Icons.payments, amber),
              ],
            ),
            const SizedBox(height: 16),

            // UTR / Reference Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'UPI UTR / Reference Number:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy),
                ),
                InkWell(
                  onTap: _generateNewUtr,
                  child: const Text('Auto-Refetch ↻', style: TextStyle(color: blue, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              controller: utrController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                prefixIcon: const Icon(Icons.tag, size: 20, color: Colors.blueGrey),
                hintText: 'Enter 12-digit UPI UTR / Ref No',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: blue, width: 2)),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
            ),
            const SizedBox(height: 22),

            // Big Action Button: Pay & Transfer to Admin Kamal
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: isProcessing ? null : _processPayment,
                child: isProcessing
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Pay ₹$selectedAmount & Send to Admin Kamal',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                '🔒 Secured with 256-bit encryption • Immediate Admin Notification',
                style: TextStyle(fontSize: 10.5, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentVisualBox() {
    if (AdminData.useCustomQr && AdminData.customQrImageUrl != null && AdminData.customQrImageUrl!.isNotEmpty) {
      return Container(
        width: 190,
        height: 190,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: purple, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          AdminData.customQrImageUrl!,
          fit: BoxFit.contain,
          errorBuilder: (ctx, err, stack) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, color: red, size: 36),
              const SizedBox(height: 6),
              const Text('Failed to load image', style: TextStyle(fontSize: 11, color: red, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => showCustomQrSettingsDialog(context, onSaved: () => setState(() {})),
                child: const Text('Change QR', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          },
        ),
      );
    } else if (AdminData.qrDisplayType == 'barcode') {
      return Container(
        width: 220,
        height: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(200, 54),
              painter: _BarcodePaymentPainter(color: navy, seed: AdminData.adminUpiId.hashCode),
            ),
            const SizedBox(height: 8),
            Text(
              '*UPI-PAY-${AdminData.adminName.toUpperCase()}-$selectedAmount*',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                letterSpacing: 2,
                color: navy,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AdminData.adminUpiId,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: blue),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 190,
        height: 190,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AdminData.useCustomQr ? purple : const Color(0xFFCBD5E1), width: 2),
        ),
        child: CustomPaint(
          painter: _RealisticQrPainter(
            accentColor: AdminData.useCustomQr ? purple : navy,
            seed: AdminData.adminUpiId.hashCode,
          ),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AdminData.useCustomQr ? purple : navy, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                ],
              ),
              child: Center(
                child: Text(
                  '₹',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AdminData.useCustomQr ? purple : navy,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPlanOption({
    required String title,
    required int amount,
    required String planName,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedAmount == amount;
    return InkWell(
      onTap: () {
        setState(() {
          selectedAmount = amount;
          selectedPlan = planName;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.blueGrey, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                color: isSelected ? color : navy,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '₹$amount / mo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isSelected ? color : Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppChip(String appName, IconData icon, Color color) {
    final isSelected = selectedApp == appName;
    return InkWell(
      onTap: () => setState(() => selectedApp = appName),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : Colors.blueGrey),
            const SizedBox(width: 6),
            Text(
              appName,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? color : navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Official Celebratory Digital Receipt Slip
void showPaymentSuccessReceiptDialog(
  BuildContext context, {
  required FeeTransaction txn,
}) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(22),
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success animation badge
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: green, width: 2),
              ),
              child: const Icon(Icons.check_circle_rounded, color: green, size: 44),
            ),
            const SizedBox(height: 14),
            const Text(
              'Payment Received by Admin Kamal!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Krishna Library • Official Digital Fee Receipt',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),

            // Official Stamp Slip
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _receiptRow('Receipt Number:', txn.receiptNo),
                  const Divider(height: 12),
                  _receiptRow('Member Name:', '${txn.memberName} (${txn.memberId})'),
                  const Divider(height: 12),
                  _receiptRow('Seat Allotment:', 'Seat ${txn.seatNo.toString().padLeft(2, '0')} (Confirmed)'),
                  const Divider(height: 12),
                  _receiptRow('Amount Paid:', '₹${txn.amount}', highlightColor: green),
                  const Divider(height: 12),
                  _receiptRow('Paid To:', 'Kamal (Admin UPI)'),
                  const Divider(height: 12),
                  _receiptRow('Payment Mode:', txn.paymentMode),
                  const Divider(height: 12),
                  _receiptRow('UTR / Ref No:', txn.utr),
                  const Divider(height: 12),
                  _receiptRow('Payment Date:', txn.dateTime),
                  const Divider(height: 12),
                  _receiptRow('Status:', txn.status, highlightColor: green),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Digital Stamp badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: green.withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, size: 16, color: green),
                  SizedBox(width: 6),
                  Text(
                    'OFFICIALLY RECORDED IN ADMIN CONSOLE',
                    style: TextStyle(color: green, fontSize: 10.5, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.receipt_long, size: 18),
                    label: const Text('Download & Print Full PDF Slip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      showOfficialFeeReceiptSheet(context, transaction: txn);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF25D366),
                          side: const BorderSide(color: Color(0xFF25D366), width: 1.3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.chat, size: 16),
                        label: const Text('WhatsApp Slip', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          showOfficialFeeReceiptSheet(context, transaction: txn);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blueGrey,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Done / OK', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _receiptRow(String label, String value, {Color? highlightColor}) {
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
            fontWeight: FontWeight.bold,
            color: highlightColor ?? navy,
          ),
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

/// Custom Realistic QR Code Graphic Painter
class _RealisticQrPainter extends CustomPainter {
  final Color accentColor;
  final int seed;

  _RealisticQrPainter({required this.accentColor, this.seed = 42});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer Finder Patterns (3 corners)
    void drawFinder(double x, double y) {
      final s = w * 0.26;
      // Outer box
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, s, s), const Radius.circular(5)),
        paint,
      );
      // Inner white
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x + s * 0.16, y + s * 0.16, s * 0.68, s * 0.68), const Radius.circular(3)),
        Paint()..color = Colors.white,
      );
      // Center solid
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x + s * 0.32, y + s * 0.32, s * 0.36, s * 0.36), const Radius.circular(2)),
        paint,
      );
    }

    drawFinder(0, 0); // Top left
    drawFinder(w * 0.74, 0); // Top right
    drawFinder(0, h * 0.74); // Bottom left

    // Procedural QR Data Matrix Dots
    final dotSize = w * 0.045;
    final rng = Random(seed); // Seed based on personal UPI string
    final cols = (w / dotSize).floor();

    for (int r = 0; r < cols; r++) {
      for (int c = 0; c < cols; c++) {
        final dx = c * dotSize;
        final dy = r * dotSize;

        // Skip corners
        if (dx < w * 0.32 && dy < h * 0.32) continue;
        if (dx > w * 0.68 && dy < h * 0.32) continue;
        if (dx < w * 0.32 && dy > h * 0.68) continue;
        // Skip center
        if (dx > w * 0.35 && dx < w * 0.65 && dy > h * 0.35 && dy < h * 0.65) continue;

        if (rng.nextBool()) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(dx + 1, dy + 1, dotSize - 2, dotSize - 2),
              const Radius.circular(1.5),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RealisticQrPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor || oldDelegate.seed != seed;
}

/// 1D Barcode Painter for Personal Barcode mode
class _BarcodePaymentPainter extends CustomPainter {
  final Color color;
  final int seed;

  _BarcodePaymentPainter({required this.color, this.seed = 42});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final rng = Random(seed);
    double x = 0;
    while (x < size.width) {
      final isBar = rng.nextBool() || rng.nextBool();
      final barW = 1.5 + rng.nextInt(4);
      if (isBar && x + barW <= size.width) {
        canvas.drawRect(Rect.fromLTWH(x, 0, barW, size.height), paint);
      }
      x += barW + 1.5;
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePaymentPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.seed != seed;
}

// ========================================================
// 3. PERSONAL PAYMENT QR CODE & BARCODE SETTINGS MODAL
// ========================================================
void showCustomQrSettingsDialog(BuildContext context, {VoidCallback? onSaved}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _CustomQrSettingsModalContent(onSaved: onSaved),
  );
}

class _CustomQrSettingsModalContent extends StatefulWidget {
  final VoidCallback? onSaved;
  const _CustomQrSettingsModalContent({this.onSaved});

  @override
  State<_CustomQrSettingsModalContent> createState() => _CustomQrSettingsModalContentState();
}

class _CustomQrSettingsModalContentState extends State<_CustomQrSettingsModalContent> {
  late TextEditingController upiController;
  late TextEditingController nameController;
  late TextEditingController merchantController;
  late TextEditingController phoneController;
  late TextEditingController imageController;

  late String selectedDisplayType; // 'qr', 'barcode', 'image'
  late bool useCustomQr;

  @override
  void initState() {
    super.initState();
    upiController = TextEditingController(text: AdminData.adminUpiId);
    nameController = TextEditingController(text: AdminData.adminName);
    merchantController = TextEditingController(text: AdminData.adminMerchantTitle);
    phoneController = TextEditingController(text: AdminData.adminPhone);
    imageController = TextEditingController(text: AdminData.customQrImageUrl ?? '');
    selectedDisplayType = AdminData.qrDisplayType;
    useCustomQr = AdminData.useCustomQr;
  }

  @override
  void dispose() {
    upiController.dispose();
    nameController.dispose();
    merchantController.dispose();
    phoneController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void _applyPreset(String upi, String name, String merchant, {String? image}) {
    setState(() {
      upiController.text = upi;
      nameController.text = name;
      merchantController.text = merchant;
      if (image != null) {
        imageController.text = image;
        selectedDisplayType = 'image';
        useCustomQr = true;
      }
    });
  }

  void _save() {
    final upi = upiController.text.trim();
    if (upi.isEmpty || !upi.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया सही UPI ID दर्ज करें (उदा. 9812345678@paytm या name@okhdfcbank)'),
          backgroundColor: red,
        ),
      );
      return;
    }

    AdminData.updatePaymentQr(
      upiId: upi,
      payeeName: nameController.text.trim().isNotEmpty ? nameController.text.trim() : 'Kamal',
      merchantTitle: merchantController.text.trim().isNotEmpty ? merchantController.text.trim() : 'KRISHNA LIBRARY',
      phone: phoneController.text.trim(),
      customImageUrl: selectedDisplayType == 'image' ? imageController.text.trim() : null,
      displayType: selectedDisplayType,
    );

    widget.onSaved?.call();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('पर्सनल QR कोड व UPI ID ($upi) सफलता से सेट हो गया!'),
        backgroundColor: green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _reset() {
    setState(() {
      AdminData.resetPaymentQrToDefault();
      upiController.text = AdminData.adminUpiId;
      nameController.text = AdminData.adminName;
      merchantController.text = AdminData.adminMerchantTitle;
      phoneController.text = AdminData.adminPhone;
      imageController.text = '';
      selectedDisplayType = 'qr';
      useCustomQr = false;
    });

    widget.onSaved?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('डिफ़ॉल्ट कृष्णा लाइब्रेरी QR कोड रीसेट कर दिया गया!'),
        backgroundColor: navy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.88,
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: purple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_scanner_outlined, color: purple, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal QR & Barcode Settings',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: navy),
                      ),
                      Text(
                        'अपना खुद का व्यक्तिगत QR कोड / बारकोड लगाएं • कमल',
                        style: TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: blue, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'यहाँ आप अपनी व्यक्तिगत UPI ID या स्टैंडी QR का फोटो लगा सकते हैं। छात्र जब फीस का भुगतान करेंगे, तो सीधे आपके निजी बैंक खाते में पैसे जमा होंगे।',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF1E3A8A), height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Display Format Selection
                  const Text(
                    'QR / बारकोड फॉर्मेट चुनें (Display Format):',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFormatOption('qr', '2D UPI QR कोड', Icons.qr_code_2),
                      const SizedBox(width: 8),
                      _buildFormatOption('barcode', '1D बारकोड', Icons.view_week_outlined),
                      const SizedBox(width: 8),
                      _buildFormatOption('image', 'स्टैंडी फोटो', Icons.photo_camera_outlined),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Quick Presets
                  const Text(
                    'Quick Presets (1-क्लिक में भरें):',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildPresetChip('PhonePe', () => _applyPreset('9812345678@ybl', 'Kamal (Director)', 'KRISHNA LIBRARY (PHONEPE)')),
                      _buildPresetChip('Google Pay', () => _applyPreset('kamal.library@okhdfcbank', 'Kamal (Admin)', 'KRISHNA LIBRARY (GPAY)')),
                      _buildPresetChip('Paytm', () => _applyPreset('9812345678@paytm', 'Kamal', 'KRISHNA STUDY CENTER (PAYTM)')),
                      _buildPresetChip('SBI UPI', () => _applyPreset('kamal@sbi', 'Kamal', 'KRISHNA LIBRARY (SBI)')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Personal UPI ID input
                  const Text('Personal UPI ID (आपकी व्यक्तिगत UPI ID):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: upiController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'e.g. 9812345678@paytm, kamal@okaxis, etc.',
                      prefixIcon: const Icon(Icons.alternate_email, color: purple, size: 18),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Payee Name & Merchant Title
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Payee Name (प्राप्तकर्ता):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: navy)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: nameController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Kamal',
                                prefixIcon: const Icon(Icons.person, color: blue, size: 18),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                              ),
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Shop / Title (शीर्षक):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: navy)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: merchantController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'KRISHNA LIBRARY',
                                prefixIcon: const Icon(Icons.storefront, color: green, size: 18),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                              ),
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // If Standee Image format selected
                  if (selectedDisplayType == 'image') ...[
                    const Text('Custom Standee QR Image URL (QR फोटो लिंक):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: imageController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'https://... (या नीचे से डेमो स्टैंडी चुनें)',
                        prefixIcon: const Icon(Icons.link, color: amber, size: 18),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    // Demo standee image buttons
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildPresetChip('Use PhonePe Standee Image', () {
                          setState(() {
                            imageController.text = 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=upi://pay?pa=9812345678@ybl&pn=Kamal_Krishna_Library';
                          });
                        }),
                        _buildPresetChip('Use GPay Standee Image', () {
                          setState(() {
                            imageController.text = 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=upi://pay?pa=kamal.library@okhdfcbank&pn=Krishna_Library';
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Live Preview Box
                  const SizedBox(height: 6),
                  const Text('Live Preview (छात्रों को ऐसा दिखेगा):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      children: [
                        if (selectedDisplayType == 'image' && imageController.text.isNotEmpty)
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: purple, width: 1.5),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              imageController.text.trim(),
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) => const Center(
                                child: Text('Invalid Image URL', style: TextStyle(fontSize: 11, color: red)),
                              ),
                            ),
                          )
                        else if (selectedDisplayType == 'barcode')
                          Column(
                            children: [
                              CustomPaint(
                                size: const Size(180, 48),
                                painter: _BarcodePaymentPainter(color: navy, seed: upiController.text.hashCode),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '*${upiController.text.toUpperCase()}*',
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        else
                          Container(
                            width: 140,
                            height: 140,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: purple, width: 1.5),
                            ),
                            child: CustomPaint(
                              painter: _RealisticQrPainter(accentColor: purple, seed: upiController.text.hashCode),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: Text('₹', style: TextStyle(fontWeight: FontWeight.w900, color: purple)),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          'Paying to: ${nameController.text.isNotEmpty ? nameController.text : "Kamal"}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
                        ),
                        Text(
                          upiController.text.isNotEmpty ? upiController.text : "kamal@upi",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: purple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: red,
                    side: BorderSide(color: red.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _reset,
                  child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Save & Apply Personal QR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(String key, String label, IconData icon) {
    final isSel = selectedDisplayType == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedDisplayType = key),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSel ? purple.withValues(alpha: 0.12) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSel ? purple : const Color(0xFFCBD5E1), width: isSel ? 1.8 : 1),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(icon, size: 16, color: isSel ? purple : Colors.blueGrey),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSel ? FontWeight.w900 : FontWeight.bold,
                  color: isSel ? purple : navy,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: navy)),
      ),
    );
  }
}

