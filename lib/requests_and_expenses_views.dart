import 'package:flutter/material.dart';
import 'admin_data.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);

// ========================================================
// 1. STUDENT SEAT / SHIFT CHANGE REQUEST BOTTOM SHEET
// ========================================================
void showSeatChangeRequestSheet(
  BuildContext context, {
  MemberRecord? member,
  VoidCallback? onStateChange,
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
    builder: (ctx) => _SeatChangeRequestModalContent(
      member: student,
      onStateChange: onStateChange,
    ),
  );
}

class _SeatChangeRequestModalContent extends StatefulWidget {
  final MemberRecord member;
  final VoidCallback? onStateChange;

  const _SeatChangeRequestModalContent({
    required this.member,
    this.onStateChange,
  });

  @override
  State<_SeatChangeRequestModalContent> createState() => _SeatChangeRequestModalContentState();
}

class _SeatChangeRequestModalContentState extends State<_SeatChangeRequestModalContent> {
  String requestType = 'Seat Swap'; // 'Seat Swap', 'Shift Change', 'Both'
  int? selectedNewSeat;
  late String selectedNewShift;
  final TextEditingController reasonController = TextEditingController();
  bool isSubmitting = false;

  // Find all currently available seats
  List<int> get availableSeats {
    final occupied = AdminData.members.map((m) => m.seatNo).toSet();
    return List.generate(AdminData.totalSeats, (i) => i + 1)
        .where((s) => !occupied.contains(s))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    selectedNewShift = widget.member.shift.contains('Full Day')
        ? LibraryFeeStructure.halfDayMorningTiming
        : LibraryFeeStructure.fullDayTiming;
    final avail = availableSeats;
    if (avail.isNotEmpty) {
      selectedNewSeat = avail.first;
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  void _submit() async {
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a brief reason for your request.')),
      );
      return;
    }

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    AdminData.submitSeatRequest(
      memberId: widget.member.id,
      memberName: widget.member.name,
      phone: widget.member.phone,
      currentSeat: widget.member.seatNo,
      requestedSeat: (requestType == 'Seat Swap' || requestType == 'Both') ? selectedNewSeat : null,
      currentShift: widget.member.shift,
      requestedShift: (requestType == 'Shift Change' || requestType == 'Both') ? selectedNewShift : widget.member.shift,
      requestType: requestType,
      reason: reason,
    );

    if (!mounted) return;
    setState(() => isSubmitting = false);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request submitted successfully! Admin Kamal has been notified.'),
        backgroundColor: green,
      ),
    );

    widget.onStateChange?.call();
  }

  @override
  Widget build(BuildContext context) {
    final myPastRequests = AdminData.seatRequests
        .where((r) => r.memberId == widget.member.id)
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 6,
        bottom: MediaQuery.of(context).viewInsets.bottom + 26,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: purple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.swap_horiz, color: purple, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seat & Shift Change Request',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: navy),
                      ),
                      Text(
                        'Apply for desk swap or timing shift to Admin Kamal',
                        style: TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 14),

            // Current Seat Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: navy,
                    child: Text(
                      'S${widget.member.seatNo.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Desk: Seat ${widget.member.seatNo.toString().padLeft(2, '0')} (${widget.member.name})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
                        ),
                        Text(
                          'Current Shift: ${widget.member.shift}',
                          style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Request Type Selector
            const Text(
              'What do you want to change?',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTypeChip('Seat Swap', Icons.event_seat_outlined),
                const SizedBox(width: 8),
                _buildTypeChip('Shift Change', Icons.access_time),
                const SizedBox(width: 8),
                _buildTypeChip('Both', Icons.sync_alt),
              ],
            ),
            const SizedBox(height: 16),

            // Select Target Seat (if Seat Swap or Both)
            if (requestType == 'Seat Swap' || requestType == 'Both') ...[
              const Text(
                'Select New Empty Seat to Move To:',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy),
              ),
              const SizedBox(height: 8),
              if (availableSeats.isEmpty)
                const Text('No seats are currently vacant.', style: TextStyle(color: red, fontSize: 12))
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: availableSeats.map((seat) {
                      final isSel = selectedNewSeat == seat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text('Seat ${seat.toString().padLeft(2, '0')}'),
                          selected: isSel,
                          selectedColor: purple,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : navy,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isSel ? purple : const Color(0xFFCBD5E1)),
                          ),
                          onSelected: (_) => setState(() => selectedNewSeat = seat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 16),
            ],

            // Select Target Shift (if Shift Change or Both)
            if (requestType == 'Shift Change' || requestType == 'Both') ...[
              const Text(
                'Select Desired Shift Timing:',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedNewShift,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                ),
                items: const [
                  DropdownMenuItem(
                    value: LibraryFeeStructure.fullDayTiming,
                    child: Text('Full Day: 07:00 AM - 10:00 PM (₹1,000/mo)'),
                  ),
                  DropdownMenuItem(
                    value: LibraryFeeStructure.halfDayMorningTiming,
                    child: Text('Half Day Morning: 07:00 AM - 02:00 PM (₹700/mo)'),
                  ),
                  DropdownMenuItem(
                    value: LibraryFeeStructure.halfDayEveningTiming,
                    child: Text('Half Day Evening: 02:00 PM - 10:00 PM (₹700/mo)'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedNewShift = val);
                },
              ),
              const SizedBox(height: 16),
            ],

            // Reason Input
            const Text(
              'Reason for Request (कारण लिखें):',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: navy),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. Need seat near window, or exam next month needing full day...',
                hintStyle: const TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
              ),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 18),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: isSubmitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send, size: 18),
                label: const Text('Submit Request to Admin Kamal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                onPressed: isSubmitting ? null : _submit,
              ),
            ),

            // Show existing request history if any
            if (myPastRequests.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'My Submitted Requests Status:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: navy),
              ),
              const SizedBox(height: 8),
              ...myPastRequests.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          r.status.contains('Approved')
                              ? Icons.check_circle
                              : r.status == 'Declined'
                                  ? Icons.cancel
                                  : Icons.hourglass_top,
                          size: 16,
                          color: r.status.contains('Approved')
                              ? green
                              : r.status == 'Declined'
                                  ? red
                                  : amber,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${r.requestType}: ${r.requestedSeat != null ? 'Seat ${r.requestedSeat}' : r.requestedShift}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (r.status.contains('Approved') ? green : (r.status == 'Declined' ? red : amber)).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            r.status,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: r.status.contains('Approved') ? green : (r.status == 'Declined' ? red : amber),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, IconData icon) {
    final isSel = requestType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => requestType = type),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? purple.withValues(alpha: 0.12) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSel ? purple : const Color(0xFFE2E8F0),
              width: isSel ? 1.8 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(icon, size: 16, color: isSel ? purple : Colors.blueGrey),
              const SizedBox(height: 3),
              Text(
                type,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSel ? FontWeight.w900 : FontWeight.bold,
                  color: isSel ? purple : navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================================
// 2. ADMIN SEAT & SHIFT REQUESTS APPROVAL SHEET (कमल अर्जी कंसोल)
// ========================================================
void showAdminRequestsSheet(BuildContext context, {VoidCallback? onStateChange}) {
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
        final pending = AdminData.seatRequests.where((r) => r.status == 'Pending').toList();
        final processed = AdminData.seatRequests.where((r) => r.status != 'Pending').toList();

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
                        color: purple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.rule_folder_outlined, color: purple, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Student Requests (अर्जी प्रबंधन)',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                          ),
                          Text(
                            '${pending.length} Pending • ${processed.length} Processed • Chief Admin Kamal',
                            style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 14),

                if (AdminData.seatRequests.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('No student requests found.', style: TextStyle(color: Colors.blueGrey)),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: AdminData.seatRequests.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 10),
                      itemBuilder: (ctx, idx) {
                        final r = AdminData.seatRequests[idx];
                        final isPending = r.status == 'Pending';

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isPending ? Colors.white : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isPending ? purple.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
                              width: isPending ? 1.5 : 1,
                            ),
                            boxShadow: isPending
                                ? [BoxShadow(color: purple.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))]
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: purple.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          r.requestType.toUpperCase(),
                                          style: const TextStyle(color: purple, fontSize: 10, fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Seat ${r.currentSeat.toString().padLeft(2, '0')} -> ${r.requestedSeat != null ? 'Seat ${r.requestedSeat.toString().padLeft(2, '0')}' : 'Shift'}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: navy),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: (isPending ? amber : (r.status.contains('Approved') ? green : red)).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      r.status,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: isPending ? amber : (r.status.contains('Approved') ? green : red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${r.memberName} (${r.memberId}) • ${r.phone}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: navy),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reason: "${r.reason}"',
                                style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                              ),
                              if (r.requestedShift != r.currentShift) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Shift Requested: ${r.requestedShift}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blue),
                                ),
                              ],
                              const SizedBox(height: 10),

                              if (isPending) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        icon: const Icon(Icons.check, size: 16),
                                        label: const Text('Approve (स्वीकार करें)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        onPressed: () {
                                          setSheetState(() {
                                            AdminData.approveRequest(r.id);
                                          });
                                          onStateChange?.call();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: red,
                                          side: BorderSide(color: red.withValues(alpha: 0.5)),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        icon: const Icon(Icons.close, size: 16),
                                        label: const Text('Decline', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        onPressed: () {
                                          setSheetState(() {
                                            AdminData.declineRequest(r.id);
                                          });
                                          onStateChange?.call();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Text(
                                  r.adminRemark ?? 'Processed by Kamal',
                                  style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                                ),
                              ],
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

// ========================================================
// 3. ADMIN EXPENSE & NET PROFIT TRACKER (खर्चे व बचत हिसाब)
// ========================================================
void showExpenseManagerSheet(BuildContext context, {VoidCallback? onStateChange}) {
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
        final totalIncome = AdminData.totalRevenueCollected;
        final totalExp = AdminData.totalExpenses;
        final netProfit = AdminData.netProfit;

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.88,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance, color: green, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Library Financials (खर्चे व मुनाफा)',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                          ),
                          Text(
                            'Monthly P&L, Utility Bills & Net Profit • Kamal',
                            style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 14),

                // 3-Way Financial Overview Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Fees In',
                        '₹$totalIncome',
                        green,
                        Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Expense',
                        '₹$totalExp',
                        red,
                        Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryCard(
                        'Net Profit',
                        '₹$netProfit',
                        navy,
                        Icons.savings_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Add Expense Button & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monthly Library Operating Expenses:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(Icons.add, size: 15),
                      label: const Text('+ Add Expense'),
                      onPressed: () {
                        _showAddExpenseDialog(context, onAdded: () {
                          setSheetState(() {});
                          onStateChange?.call();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Expenses List
                Expanded(
                  child: ListView.separated(
                    itemCount: AdminData.expenses.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 8),
                    itemBuilder: (ctx, idx) {
                      final e = AdminData.expenses[idx];
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(e.category).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getCategoryIcon(e.category),
                                color: _getCategoryColor(e.category),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${e.category} • ${e.date} • Mode: ${e.paymentMode}',
                                    style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                                  ),
                                  if (e.note.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      e.note,
                                      style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '-₹${e.amount}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: red),
                                ),
                                InkWell(
                                  onTap: () {
                                    setSheetState(() {
                                      AdminData.deleteExpense(e.id);
                                    });
                                    onStateChange?.call();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Icon(Icons.delete_outline, size: 16, color: Colors.blueGrey),
                                  ),
                                ),
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

Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: color)),
            Icon(icon, size: 14, color: color),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
      ],
    ),
  );
}

Color _getCategoryColor(String cat) {
  switch (cat) {
    case 'Electricity':
      return amber;
    case 'Internet / Wi-Fi':
      return blue;
    case 'Water & Cleaning':
      return green;
    case 'Newspapers':
      return purple;
    default:
      return navy;
  }
}

IconData _getCategoryIcon(String cat) {
  switch (cat) {
    case 'Electricity':
      return Icons.bolt;
    case 'Internet / Wi-Fi':
      return Icons.wifi;
    case 'Water & Cleaning':
      return Icons.water_drop_outlined;
    case 'Newspapers':
      return Icons.newspaper;
    default:
      return Icons.receipt;
  }
}

void _showAddExpenseDialog(BuildContext context, {required VoidCallback onAdded}) {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  String selectedCat = 'Electricity';
  String selectedMode = 'UPI';

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Library Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title / Description',
                  hintText: 'e.g. Electric fan repair, Wi-Fi recharge...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedCat,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Electricity', child: Text('Electricity', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Internet / Wi-Fi', child: Text('Wi-Fi', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Water & Cleaning', child: Text('Cleaning', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Newspapers', child: Text('News', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Repairs & Misc', child: Text('Misc', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCat = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Payment Note / Bill No.',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white),
                    onPressed: () {
                      final title = titleController.text.trim();
                      final amount = int.tryParse(amountController.text.trim()) ?? 0;
                      if (title.isEmpty || amount <= 0) return;

                      AdminData.addExpense(
                        title: title,
                        category: selectedCat,
                        amount: amount,
                        paymentMode: selectedMode,
                        note: noteController.text.trim(),
                      );
                      Navigator.pop(ctx);
                      onAdded();
                    },
                    child: const Text('Save Expense'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
