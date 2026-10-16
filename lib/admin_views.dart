import 'package:flutter/material.dart';
import 'admin_data.dart';
import 'payment_view.dart';
import 'id_card_view.dart';
import 'whatsapp_reminder_view.dart';
import 'fee_receipt_view.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);

// ========================================================
// 1. SEAT DETAILS BOTTOM SHEET (Shows exact occupant data)
// ========================================================
void showSeatOccupantDetails(BuildContext context, int seatNo, {bool isAdmin = false, VoidCallback? onStateChange}) {
  final member = AdminData.getMemberBySeat(seatNo);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Seat number and status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: (member != null ? red : green).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: (member != null ? red : green).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        member != null ? Icons.event_seat : Icons.check_circle_outline,
                        color: member != null ? red : green,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SEAT ${seatNo.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: member != null ? red : green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (member != null ? red : green).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    member != null ? 'OCCUPIED (आरक्षित)' : 'AVAILABLE (खाली)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: member != null ? red : green,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 18),

            if (member == null) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Icon(Icons.event_seat_outlined, size: 48, color: green),
                      const SizedBox(height: 10),
                      const Text(
                        'This seat is currently available for allotment.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: navy),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAdmin
                            ? 'Admin: नीचे दिए गए बटन से इस सीट पर नया छात्र जोड़ें।'
                            : 'Tap "Select Seat" in member mode to choose this seat.',
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                          label: Text(
                            'Allot Seat S-${seatNo.toString().padLeft(2, '0')} (नया छात्र जोड़ें)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            showAddStudentDialog(context, initialSeatNo: seatNo, onSaved: onStateChange);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Member Profile Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF28547A),
                      child: Text(
                        member.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Member ID: ${member.id} • ${member.phone}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11.5),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2B84B).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Target: ${member.exam}',
                              style: const TextStyle(color: Color(0xFFF2B84B), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Shift and Attendance Details
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _detailRow('Shift Timing:', member.shift),
                    if (isAdmin) ...[
                      const Divider(height: 16),
                      _detailRow('Membership Plan:', member.plan),
                      const Divider(height: 16),
                      _detailRow(
                        'Fee Status (फीस):',
                        member.feeStatus == 'Paid' ? 'PAID (जमा है)' : 'PENDING (बकाया है)',
                        valueColor: member.feeStatus == 'Paid' ? green : red,
                      ),
                      const Divider(height: 16),
                      _detailRow('Valid Till / Due:', member.dueDate),
                      const Divider(height: 16),
                      _detailRow('Payment Mode:', member.paymentMode),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Action buttons (Admin only)
              if (isAdmin) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: BorderSide(color: member.feeStatus == 'Paid' ? green : red),
                        ),
                        icon: Icon(
                          member.feeStatus == 'Paid' ? Icons.check_circle : Icons.payment,
                          color: member.feeStatus == 'Paid' ? green : red,
                          size: 16,
                        ),
                        label: Text(
                          member.feeStatus == 'Paid' ? 'Fee Paid (₹${member.amount})' : 'Collect Fee (₹${member.amount})',
                          style: TextStyle(
                            color: member.feeStatus == 'Paid' ? green : red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setSheetState(() {
                            member.feeStatus = member.feeStatus == 'Paid' ? 'Pending' : 'Paid';
                          });
                          onStateChange?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: blue,
                          side: const BorderSide(color: blue),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.badge_outlined, size: 16),
                        label: const Text('Digital ID Pass', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () => showStudentIdCardSheet(context, member: member),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blue,
                      side: const BorderSide(color: blue),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.badge_outlined, size: 16),
                    label: const Text('View / Print Digital ID Card (पहचान पत्र)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      showStudentIdCardSheet(context, member: member);
                    },
                  ),
                ),
                if (isAdmin && member.feeStatus != 'Paid') ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Send WhatsApp Fee Notice (व्हाट्सएप तगादा)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        showWhatsAppReminderSheet(
                          context,
                          member: member,
                          onSent: () {
                            setSheetState(() {});
                            onStateChange?.call();
                          },
                        );
                      },
                    ),
                  ),
                ],
                if (member.feeStatus == 'Paid') ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: green,
                        side: const BorderSide(color: green),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.receipt_long, size: 16),
                      label: const Text('View Official Fee Receipt (फीस रसीद)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        showOfficialFeeReceiptSheet(context, member: member);
                      },
                    ),
                  ),
                ],
                if (isAdmin) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: red,
                        side: BorderSide(color: red.withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.person_remove_outlined, size: 16),
                      label: Text('Vacate Seat S-${seatNo.toString().padLeft(2, '0')} (सीट खाली करें)'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dCtx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: const Text('Vacate Seat? (सीट खाली करें?)'),
                            content: Text('Are you sure you want to remove ${member.name} from Seat S-${seatNo.toString().padLeft(2, '0')}? This seat will become available for new students.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white),
                                onPressed: () {
                                  AdminData.vacateSeat(seatNo);
                                  Navigator.pop(dCtx);
                                  Navigator.pop(ctx);
                                  onStateChange?.call();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Seat S-${seatNo.toString().padLeft(2, '0')} is now vacant.')),
                                  );
                                },
                                child: const Text('Vacate Seat'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    ),
  );
}

// ========================================================
// 2. FEE MANAGEMENT BOTTOM SHEET (फीस रिकॉर्ड एवं बकाया)
// ========================================================
void showFeeManagementSheet(BuildContext context, {VoidCallback? onStateChange}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) {
        final paid = AdminData.members.where((m) => m.feeStatus == 'Paid').toList();
        final pending = AdminData.members.where((m) => m.feeStatus == 'Pending').toList();

        return DefaultTabController(
          length: 4,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.88,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.payments_outlined, color: amber, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fee Management (फीस रिकॉर्ड)',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                            ),
                            Text(
                              'Total Revenue: ₹${AdminData.totalRevenueCollected} • Pending: ₹${AdminData.totalPendingAmount}',
                              style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.qr_code, size: 15),
                        label: const Text('Pay / Collect'),
                        onPressed: () {
                          showFeePaymentSheet(
                            context,
                            onPaymentSuccess: () {
                              setSheetState(() {});
                              onStateChange?.call();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Official Fee Structure Notice
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wb_sunny_outlined, size: 16, color: blue),
                            SizedBox(width: 6),
                            Text(
                              'Full Day (पूरा दिन): ₹1,000 / month',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ],
                        ),
                        Text('•', style: TextStyle(color: Colors.blueGrey)),
                        Row(
                          children: [
                            Icon(Icons.timelapse_outlined, size: 16, color: green),
                            SizedBox(width: 6),
                            Text(
                              'Half Day (आधा दिन): ₹700 / month',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Revenue Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: green.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${paid.length} Members Paid', style: const TextStyle(fontSize: 11, color: green, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('₹${AdminData.totalRevenueCollected}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: green)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: red.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${pending.length} Pending Dues', style: const TextStyle(fontSize: 11, color: red, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('₹${AdminData.totalPendingAmount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: red)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 4 Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: navy,
                      unselectedLabelColor: Colors.blueGrey,
                      indicatorColor: blue,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      tabs: [
                        Tab(text: 'All (${AdminData.members.length})'),
                        Tab(text: 'Paid (${paid.length})'),
                        Tab(text: 'Pending (${pending.length})'),
                        Tab(text: 'Online Txns (${AdminData.transactions.length}) 🔔'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildFeeList(context, AdminData.members, setSheetState, onStateChange),
                        _buildFeeList(context, paid, setSheetState, onStateChange),
                        _buildPendingFeeListWithBatchAction(context, pending, setSheetState, onStateChange),
                        _buildTransactionsList(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildPendingFeeListWithBatchAction(
  BuildContext context,
  List<MemberRecord> pending,
  StateSetter setSheetState,
  VoidCallback? onStateChange,
) {
  if (pending.isEmpty) {
    return const Center(
      child: Text('All members have paid! No pending fees 🎉', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
    );
  }

  return Column(
    children: [
      InkWell(
        onTap: () {
          showBatchWhatsAppReminderSheet(
            context,
            onSent: () {
              setSheetState(() {});
              onStateChange?.call();
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF075E54), Color(0xFF128C7E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: const Color(0xFF25D366).withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.campaign, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1-Click WhatsApp Reminder to All Overdue (₹2,700)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    Text(
                      'Tap to send instant UPI fee reminder notice to all overdue students',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.send_rounded, size: 11, color: Colors.white),
                    SizedBox(width: 3),
                    Text('Send All', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: _buildFeeList(context, pending, setSheetState, onStateChange),
      ),
    ],
  );
}

Widget _buildFeeList(BuildContext context, List<MemberRecord> list, StateSetter setSheetState, VoidCallback? onStateChange) {
  if (list.isEmpty) {
    return const Center(
      child: Text('No records in this category.', style: TextStyle(color: Colors.blueGrey)),
    );
  }

  return ListView.separated(
    itemCount: list.length,
    separatorBuilder: (_, i) => const SizedBox(height: 8),
    itemBuilder: (ctx, idx) {
      final m = list[idx];
      final isPaid = m.feeStatus == 'Paid';

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: (isPaid ? green : red).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'S${m.seatNo.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: isPaid ? green : red,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        m.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: navy),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: (isPaid ? green : red).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPaid ? 'PAID' : 'PENDING',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: isPaid ? green : red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${m.plan} • Valid: ${m.dueDate}',
                    style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${m.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: isPaid ? green : red,
                  ),
                ),
                const SizedBox(height: 4),
                if (!isPaid)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          showWhatsAppReminderSheet(
                            context,
                            member: m,
                            onSent: () {
                              setSheetState(() {});
                              onStateChange?.call();
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 11, color: Colors.white),
                              SizedBox(width: 3),
                              Text('Notice', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          showFeePaymentSheet(
                            context,
                            member: m,
                            onPaymentSuccess: () {
                              setSheetState(() {});
                              onStateChange?.call();
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.qr_code, size: 11, color: Colors.white),
                              SizedBox(width: 3),
                              Text(
                                'Pay',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => showOfficialFeeReceiptSheet(context, member: m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long, size: 11, color: Colors.white),
                              SizedBox(width: 3),
                              Text('Receipt', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          setSheetState(() {
                            m.feeStatus = 'Pending';
                          });
                          onStateChange?.call();
                        },
                        child: const Text(
                          'Mark Due',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildTransactionsList(BuildContext context) {
  final txns = AdminData.transactions;
  if (txns.isEmpty) {
    return const Center(child: Text('No online transactions recorded yet.', style: TextStyle(color: Colors.blueGrey)));
  }

  return ListView.separated(
    itemCount: txns.length,
    separatorBuilder: (_, i) => const SizedBox(height: 10),
    itemBuilder: (ctx, idx) {
      final t = txns[idx];
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_downward, color: green, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${t.memberName} (Seat ${t.seatNo.toString().padLeft(2, '0')})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
                      ),
                      Text(
                        '${t.paymentMode} • ${t.dateTime}',
                        style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                Text(
                  '+₹${t.amount}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 11, color: green),
                      const SizedBox(width: 4),
                      Text(
                        t.status,
                        style: const TextStyle(fontSize: 9.5, color: green, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showOfficialFeeReceiptSheet(context, transaction: t),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.receipt_long, size: 14, color: blue),
                  label: const Text('Receipt Slip >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blue)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// ========================================================
// 3. ATTENDANCE REGISTER BOTTOM SHEET (उपस्थिति रजिस्टर)
// ========================================================
void showAttendanceRegisterSheet(BuildContext context, {VoidCallback? onStateChange}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fact_check_outlined, color: green, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Attendance (उपस्थिति)',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                          ),
                          Text(
                            'Present: ${AdminData.presentCount} • On Break: ${AdminData.breakCount} • Absent: ${AdminData.absentCount}',
                            style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Metrics
                Row(
                  children: [
                    _statusBadge('Present (उपस्थित)', '${AdminData.presentCount}', green),
                    const SizedBox(width: 8),
                    _statusBadge('On Break (ब्रेक)', '${AdminData.breakCount}', amber),
                    const SizedBox(width: 8),
                    _statusBadge('Absent (अनुपस्थित)', '${AdminData.absentCount}', red),
                  ],
                ),
                const SizedBox(height: 14),

                // List
                Expanded(
                  child: ListView.separated(
                    itemCount: AdminData.members.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 8),
                    itemBuilder: (ctx, idx) {
                      final m = AdminData.members[idx];
                      final isPresent = m.attendanceStatus == 'Present';
                      final isBreak = m.attendanceStatus == 'On Break';

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: (isPresent ? green : isBreak ? amber : red).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'S${m.seatNo.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: isPresent ? green : isBreak ? amber : red,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: navy),
                                  ),
                                  Text(
                                    'Check-in: ${m.checkInTime} • ${m.shift.split('(').first.trim()}',
                                    style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              tooltip: 'Change Status',
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (isPresent ? green : isBreak ? amber : red).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: (isPresent ? green : isBreak ? amber : red).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPresent ? Icons.check_circle : isBreak ? Icons.access_time : Icons.cancel,
                                      size: 13,
                                      color: isPresent ? green : isBreak ? amber : red,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      m.attendanceStatus,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isPresent ? green : isBreak ? amber : red,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down, size: 14),
                                  ],
                                ),
                              ),
                              onSelected: (val) {
                                setSheetState(() {
                                  m.attendanceStatus = val;
                                });
                                onStateChange?.call();
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'Present', child: Text('🟢 Present (उपस्थित)')),
                                PopupMenuItem(value: 'On Break', child: Text('🟡 On Break (लंच/ब्रेक)')),
                                PopupMenuItem(value: 'Absent', child: Text('🔴 Absent (अनुपस्थित)')),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _statusBadge(String title, String count, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
          Text(title, style: TextStyle(fontSize: 9.5, color: color, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

Widget _detailRow(String label, String value, {Color? valueColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
      Text(
        value,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: valueColor ?? navy,
        ),
      ),
    ],
  );
}

// ========================================================
// 4. MEMBER PERSONAL RECEIPT BOTTOM SHEET (छात्र रसीद)
// ========================================================
void showMemberReceiptSheet(BuildContext context, {MemberRecord? member}) {
  final student = member ?? AdminData.getMemberById('KL-0248') ?? AdminData.members.first;
  showOfficialFeeReceiptSheet(context, member: student);
}

// ========================================================
// 5. MEMBER ATTENDANCE RECORD (छात्र उपस्थिति)
// ========================================================
void showMemberAttendanceSheet(BuildContext context, {MemberRecord? member}) {
  final student = member ?? AdminData.getMemberById('KL-0248') ?? AdminData.members.first;
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fact_check, color: blue, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Attendance Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy)),
                    Text('Today\'s entry & study duration', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _detailRow(
                  'Today Status:',
                  '${student.attendanceStatus.toUpperCase()} (${student.attendanceStatus == "Present" ? "उपस्थित" : student.attendanceStatus == "On Break" ? "विश्राम" : "अनुपस्थित"})',
                  valueColor: student.attendanceStatus == 'Present' ? green : student.attendanceStatus == 'On Break' ? amber : red,
                ),
                const Divider(height: 14),
                _detailRow('Check-in Time:', student.checkInTime),
                const Divider(height: 14),
                _detailRow('Assigned Shift:', student.shift),
                const Divider(height: 14),
                _detailRow('This Month Presence:', '26 / 28 Days (92.8%)', valueColor: blue),
                const Divider(height: 14),
                _detailRow('Study Streak:', '🔥 14 Days Active', valueColor: amber),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ========================================================
// 8. ADD NEW STUDENT ADMISSION DIALOG (नया छात्र जोड़ें)
// ========================================================
void showAddStudentDialog(BuildContext context, {int? initialSeatNo, VoidCallback? onSaved}) {
  final nameController = TextEditingController();
  final phoneController = TextEditingController(text: '+91 ');
  final examController = TextEditingController(text: 'UPSC / SSC');
  int selectedSeat = initialSeatNo ?? 1;
  String selectedShift = 'Full Day (07:00 AM - 10:00 PM)';
  String selectedPlan = 'Full Day Monthly (₹1,000)';
  int amount = 1000;
  String feeStatus = 'Paid';
  String paymentMode = 'UPI';

  // Find available seats
  final occupiedSeats = AdminData.members.map((m) => m.seatNo).toSet();
  final availableSeats = List.generate(27, (i) => i + 1)
      .where((s) => !occupiedSeats.contains(s) || s == initialSeatNo)
      .toList();
  if (availableSeats.isNotEmpty && !availableSeats.contains(selectedSeat)) {
    selectedSeat = availableSeats.first;
  }

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (dialogCtx, setDialogState) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: green.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.person_add_alt_1_rounded, color: green, size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Student Admission', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
                  Text('नया छात्र जोड़ें व सीट अलॉट करें', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('छात्र का नाम (Student Name):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 4),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Rahul Sharma',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),

              const Text('मोबाइल नंबर (Phone Number):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 4),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+91 98123 45678',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('सीट नंबर (Seat):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: availableSeats.contains(selectedSeat) ? selectedSeat : (availableSeats.isNotEmpty ? availableSeats.first : 1),
                              items: (availableSeats.isNotEmpty ? availableSeats : [1])
                                  .map((s) => DropdownMenuItem(value: s, child: Text('Seat S-${s.toString().padLeft(2, '0')}')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => selectedSeat = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('फीस स्थिति (Status):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: feeStatus,
                              items: ['Paid', 'Pending']
                                  .map((f) => DropdownMenuItem(
                                        value: f,
                                        child: Text(
                                          f,
                                          style: TextStyle(color: f == 'Paid' ? green : red, fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => feeStatus = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Text('शिफ्ट / प्लान (Shift & Plan):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedShift,
                    items: const [
                      DropdownMenuItem(
                        value: 'Full Day (07:00 AM - 10:00 PM)',
                        child: Text('Full Day (₹1,000 / माह)'),
                      ),
                      DropdownMenuItem(
                        value: 'Half Day Morning (07:00 AM - 02:00 PM)',
                        child: Text('Half Day Morning (₹700 / माह)'),
                      ),
                      DropdownMenuItem(
                        value: 'Half Day Evening (02:00 PM - 10:00 PM)',
                        child: Text('Half Day Evening (₹700 / माह)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedShift = val;
                          if (val.contains('Full Day')) {
                            selectedPlan = 'Full Day Monthly (₹1,000)';
                            amount = 1000;
                          } else {
                            selectedPlan = 'Half Day Monthly (₹700)';
                            amount = 700;
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text('तैयारी / लक्ष्य (Target Exam):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 4),
              TextField(
                controller: examController,
                decoration: InputDecoration(
                  hintText: 'e.g. UPSC, SSC CGL, HSSC, NEET',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),

              const Text('भुगतान माध्यम (Payment Mode):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: paymentMode,
                    items: const [
                      DropdownMenuItem(value: 'UPI', child: Text('UPI (GPay / PhonePe / Paytm)')),
                      DropdownMenuItem(value: 'Cash', child: Text('Cash (नकद)')),
                      DropdownMenuItem(value: 'Net Banking', child: Text('Net Banking / Bank Transfer')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => paymentMode = val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final newId = 'KL-${(AdminData.members.length + 101).toString().padLeft(4, '0')}';

              final newMember = MemberRecord(
                id: newId,
                name: name,
                phone: phoneController.text.trim(),
                seatNo: selectedSeat,
                exam: examController.text.trim(),
                shift: selectedShift,
                plan: selectedPlan,
                amount: amount,
                feeStatus: feeStatus,
                dueDate: '30 Days from today',
                paymentMode: paymentMode,
                attendanceStatus: 'Present',
                checkInTime: '08:00 AM',
                joinDate: 'Today',
              );

              AdminData.addMember(newMember);
              Navigator.pop(ctx);
              onSaved?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('छात्र $name (Seat S-${selectedSeat.toString().padLeft(2, '0')}) सफलतापूर्वक जुड़ गए!'),
                  backgroundColor: green,
                ),
              );
            },
            child: const Text('Admit Student (सेव करें)'),
          ),
        ],
      ),
    ),
  );
}

