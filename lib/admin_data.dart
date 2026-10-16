import 'package:flutter/material.dart';

class MemberRecord {
  final String id;
  final String name;
  String phone;
  int seatNo;
  final String exam;
  String shift;
  String plan;
  int amount;
  String feeStatus; // 'Paid' or 'Pending'
  String dueDate;
  String paymentMode;
  String attendanceStatus; // 'Present', 'Absent', 'On Break'
  final String checkInTime;
  final String joinDate;

  MemberRecord({
    required this.id,
    required this.name,
    required this.phone,
    required this.seatNo,
    required this.exam,
    required this.shift,
    required this.plan,
    required this.amount,
    required this.feeStatus,
    required this.dueDate,
    required this.paymentMode,
    required this.attendanceStatus,
    required this.checkInTime,
    required this.joinDate,
  });
}

class LibraryFeeStructure {
  static const int fullDayMonthly = 1000;
  static const int halfDayMonthly = 700;
  static const String fullDayTiming = 'Full Day (07:00 AM - 10:00 PM)';
  static const String halfDayMorningTiming = 'Half Day Morning (07:00 AM - 02:00 PM)';
  static const String halfDayEveningTiming = 'Half Day Evening (02:00 PM - 10:00 PM)';
}

class AdminData {
  static final List<MemberRecord> members = [
    // 1. Aarav Sharma (Seat 12) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0248',
      name: 'Aarav Sharma',
      phone: '+91 98123 45678',
      seatNo: 12,
      exam: 'SSC CGL 2025',
      shift: 'Full Day (07:00 AM - 10:00 PM)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Paid',
      dueDate: '30 June 2026',
      paymentMode: 'UPI (GPay)',
      attendanceStatus: 'Present',
      checkInTime: '08:42 AM',
      joinDate: '10 Jan 2026',
    ),

    // 2. Vikram Singh (Seat 02) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0102',
      name: 'Vikram Singh',
      phone: '+91 94160 11223',
      seatNo: 2,
      exam: 'UPSC Civil Services 2026',
      shift: 'Full Day (06:00 AM - 10:00 PM)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Paid',
      dueDate: '15 July 2026',
      paymentMode: 'Net Banking',
      attendanceStatus: 'Present',
      checkInTime: '07:15 AM',
      joinDate: '15 Jan 2026',
    ),

    // 3. Priya Verma (Seat 04) - Half Day (₹700)
    MemberRecord(
      id: 'KL-0104',
      name: 'Priya Verma',
      phone: '+91 98960 99887',
      seatNo: 4,
      exam: 'Banking PO (IBPS)',
      shift: 'Half Day Morning (07:00 AM - 02:00 PM)',
      plan: 'Half Day Monthly (₹700)',
      amount: 700,
      feeStatus: 'Paid',
      dueDate: '25 April 2026',
      paymentMode: 'UPI (PhonePe)',
      attendanceStatus: 'Present',
      checkInTime: '08:05 AM',
      joinDate: '25 Feb 2026',
    ),

    // 4. Rahul Yadav (Seat 05) - Half Day (₹700)
    MemberRecord(
      id: 'KL-0105',
      name: 'Rahul Yadav',
      phone: '+91 99920 33445',
      seatNo: 5,
      exam: 'SSC CGL / CHSL',
      shift: 'Half Day Evening (02:00 PM - 10:00 PM)',
      plan: 'Half Day Monthly (₹700)',
      amount: 700,
      feeStatus: 'Pending',
      dueDate: '05 April 2026 (Overdue)',
      paymentMode: 'Cash',
      attendanceStatus: 'On Break',
      checkInTime: '01:50 PM',
      joinDate: '05 Jan 2026',
    ),

    // 5. Neha Rani (Seat 07) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0107',
      name: 'Neha Rani',
      phone: '+91 97280 44556',
      seatNo: 7,
      exam: 'NEET PG Medical',
      shift: 'Full Day (24-Hour Pass)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Paid',
      dueDate: '31 Dec 2026',
      paymentMode: 'UPI (Paytm)',
      attendanceStatus: 'Present',
      checkInTime: '06:45 AM',
      joinDate: '01 Jan 2026',
    ),

    // 6. Mohit Chahal (Seat 09) - Half Day (₹700)
    MemberRecord(
      id: 'KL-0109',
      name: 'Mohit Chahal',
      phone: '+91 98130 55667',
      seatNo: 9,
      exam: 'Haryana CET & Police SI',
      shift: 'Half Day Morning (07:00 AM - 02:00 PM)',
      plan: 'Half Day Monthly (₹700)',
      amount: 700,
      feeStatus: 'Paid',
      dueDate: '28 April 2026',
      paymentMode: 'UPI (GPay)',
      attendanceStatus: 'Present',
      checkInTime: '07:30 AM',
      joinDate: '28 Feb 2026',
    ),

    // 7. Anjali Saini (Seat 11) - Half Day (₹700)
    MemberRecord(
      id: 'KL-0111',
      name: 'Anjali Saini',
      phone: '+91 90500 66778',
      seatNo: 11,
      exam: 'UGC NET English',
      shift: 'Half Day Morning (08:00 AM - 02:00 PM)',
      plan: 'Half Day Monthly (₹700)',
      amount: 700,
      feeStatus: 'Paid',
      dueDate: '20 May 2026',
      paymentMode: 'UPI',
      attendanceStatus: 'Present',
      checkInTime: '08:15 AM',
      joinDate: '20 Feb 2026',
    ),

    // 8. Deepak Malik (Seat 14) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0114',
      name: 'Deepak Malik',
      phone: '+91 94670 77889',
      seatNo: 14,
      exam: 'State PCS / HPSC',
      shift: 'Full Day (07:00 AM - 10:00 PM)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Pending',
      dueDate: '10 April 2026 (Overdue)',
      paymentMode: 'Pending Verification',
      attendanceStatus: 'Absent',
      checkInTime: '--',
      joinDate: '10 Jan 2026',
    ),

    // 9. Simran Kaur (Seat 16) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0116',
      name: 'Simran Kaur',
      phone: '+91 98965 88990',
      seatNo: 16,
      exam: 'Chartered Accountancy (CA Inter)',
      shift: 'Full Day (07:00 AM - 10:00 PM)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Paid',
      dueDate: '15 Aug 2026',
      paymentMode: 'UPI (PhonePe)',
      attendanceStatus: 'Present',
      checkInTime: '08:20 AM',
      joinDate: '15 Feb 2026',
    ),

    // 10. Amit Punia (Seat 18) - Half Day (₹700)
    MemberRecord(
      id: 'KL-0118',
      name: 'Amit Punia',
      phone: '+91 97290 12345',
      seatNo: 18,
      exam: 'CDS / AFCAT Defense',
      shift: 'Half Day Evening (02:00 PM - 10:00 PM)',
      plan: 'Half Day Monthly (₹700)',
      amount: 700,
      feeStatus: 'Paid',
      dueDate: '02 May 2026',
      paymentMode: 'Cash',
      attendanceStatus: 'On Break',
      checkInTime: '02:00 PM',
      joinDate: '02 March 2026',
    ),

    // 11. Kavita Joshi (Seat 21) - Half Day (₹700)
    MemberRecord(
      id: 'KL-0121',
      name: 'Kavita Joshi',
      phone: '+91 98125 67890',
      seatNo: 21,
      exam: 'Teaching Exams (CTET / HTET)',
      shift: 'Half Day Morning (07:00 AM - 01:00 PM)',
      plan: 'Half Day Monthly (₹700)',
      amount: 700,
      feeStatus: 'Paid',
      dueDate: '12 June 2026',
      paymentMode: 'UPI (GPay)',
      attendanceStatus: 'Present',
      checkInTime: '07:40 AM',
      joinDate: '12 March 2026',
    ),

    // 12. Sachin Tanwar (Seat 24) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0124',
      name: 'Sachin Tanwar',
      phone: '+91 94165 78901',
      seatNo: 24,
      exam: 'Railway RRB NTPC',
      shift: 'Full Day (07:00 AM - 10:00 PM)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Pending',
      dueDate: '01 April 2026 (Overdue)',
      paymentMode: 'Cash',
      attendanceStatus: 'Present',
      checkInTime: '09:10 AM',
      joinDate: '01 March 2026',
    ),

    // 13. Ritu Deswal (Seat 26) - Full Day (₹1,000)
    MemberRecord(
      id: 'KL-0126',
      name: 'Ritu Deswal',
      phone: '+91 99960 45678',
      seatNo: 26,
      exam: 'Judicial Services / Law',
      shift: 'Full Day (07:00 AM - 10:00 PM)',
      plan: 'Full Day Monthly (₹1,000)',
      amount: 1000,
      feeStatus: 'Paid',
      dueDate: '10 Sept 2026',
      paymentMode: 'Net Banking',
      attendanceStatus: 'Present',
      checkInTime: '08:00 AM',
      joinDate: '10 March 2026',
    ),
  ];

  static MemberRecord? getMemberBySeat(int seatNo) {
    try {
      return members.firstWhere((m) => m.seatNo == seatNo);
    } catch (_) {
      return null;
    }
  }

  static MemberRecord? getMemberById(String id) {
    try {
      return members.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Add a new student / member into the library database
  static void addMember(MemberRecord member) {
    members.add(member);
    alerts.insert(
      0,
      AppAlert(
        icon: 'seat',
        title: 'New Student Admitted',
        message: '${member.name} admitted to Seat S-${member.seatNo.toString().padLeft(2, '0')} (${member.plan}).',
        time: 'Just now',
        isPayment: member.feeStatus == 'Paid',
      ),
    );
  }

  /// Remove or vacate a member from a seat
  static void vacateSeat(int seatNo) {
    final m = getMemberBySeat(seatNo);
    if (m != null) {
      members.removeWhere((x) => x.seatNo == seatNo);
      alerts.insert(
        0,
        AppAlert(
          icon: 'seat',
          title: 'Seat S-${seatNo.toString().padLeft(2, '0')} Vacated',
          message: 'Desk S-${seatNo.toString().padLeft(2, '0')} (${m.name}) is now empty & available.',
          time: 'Just now',
          isPayment: false,
        ),
      );
    }
  }

  /// Remove a member by ID
  static void removeMember(String memberId) {
    final m = getMemberById(memberId);
    if (m != null) {
      members.removeWhere((x) => x.id == memberId);
      alerts.insert(
        0,
        AppAlert(
          icon: 'seat',
          title: 'Member Removed',
          message: '${m.name} (Seat S-${m.seatNo.toString().padLeft(2, '0')}) has been removed.',
          time: 'Just now',
          isPayment: false,
        ),
      );
    }
  }

  /// Reset or clear all demo student records
  static void clearAllDemoData() {
    members.clear();
  }

  // Admin Payment Credentials (Personal / Customizable)
  static String adminName = 'Kamal';
  static String adminUpiId = 'kamal.krishnalibrary@okhdfcbank';
  static String adminPhone = '+91 98123 45678';
  static String adminMerchantTitle = 'KRISHNA LIBRARY (KAMAL)';
  static String adminBankName = 'HDFC Bank / State Bank of India';
  static String? customQrImageUrl;
  static bool useCustomQr = false;
  static String qrDisplayType = 'qr'; // 'qr' or 'barcode' or 'image'

  static void updatePaymentQr({
    required String upiId,
    required String payeeName,
    required String merchantTitle,
    String? phone,
    String? bankName,
    String? customImageUrl,
    String? displayType,
  }) {
    adminUpiId = upiId.trim();
    adminName = payeeName.trim();
    adminMerchantTitle = merchantTitle.trim();
    if (phone != null && phone.trim().isNotEmpty) {
      adminPhone = phone.trim();
    }
    if (bankName != null && bankName.trim().isNotEmpty) {
      adminBankName = bankName.trim();
    }
    if (customImageUrl != null && customImageUrl.trim().isNotEmpty) {
      customQrImageUrl = customImageUrl.trim();
      useCustomQr = true;
    } else {
      customQrImageUrl = null;
      useCustomQr = false;
    }
    if (displayType != null) {
      qrDisplayType = displayType;
    }
  }

  static void resetPaymentQrToDefault() {
    adminName = 'Kamal';
    adminUpiId = 'kamal.krishnalibrary@okhdfcbank';
    adminPhone = '+91 98123 45678';
    adminMerchantTitle = 'KRISHNA LIBRARY (KAMAL)';
    adminBankName = 'HDFC Bank / State Bank of India';
    customQrImageUrl = null;
    useCustomQr = false;
    qrDisplayType = 'qr';
  }

  // Live Payment Transactions Ledger
  static final List<FeeTransaction> transactions = [
    FeeTransaction(
      txnId: 'KL-TXN-884192',
      memberId: 'KL-0248',
      memberName: 'Aarav Sharma',
      seatNo: 12,
      amount: 1000,
      plan: 'Full Day Monthly (₹1,000)',
      paymentMode: 'Google Pay (UPI)',
      utr: 'UPI592817402914',
      dateTime: '14 Oct 2026, 09:15 AM',
      status: 'Received by Admin Kamal ✓',
      receiptNo: 'REC-2026-084',
    ),
    FeeTransaction(
      txnId: 'KL-TXN-872391',
      memberId: 'KL-0102',
      memberName: 'Vikram Singh',
      seatNo: 2,
      amount: 1000,
      plan: 'Full Day Monthly (₹1,000)',
      paymentMode: 'PhonePe (UPI)',
      utr: 'UPI583920194821',
      dateTime: '13 Oct 2026, 05:40 PM',
      status: 'Received by Admin Kamal ✓',
      receiptNo: 'REC-2026-083',
    ),
    FeeTransaction(
      txnId: 'KL-TXN-865410',
      memberId: 'KL-0104',
      memberName: 'Priya Verma',
      seatNo: 4,
      amount: 700,
      plan: 'Half Day Monthly (₹700)',
      paymentMode: 'Paytm UPI',
      utr: 'UPI573829103948',
      dateTime: '12 Oct 2026, 11:20 AM',
      status: 'Received by Admin Kamal ✓',
      receiptNo: 'REC-2026-082',
    ),
    FeeTransaction(
      txnId: 'KL-TXN-851902',
      memberId: 'KL-0107',
      memberName: 'Neha Rani',
      seatNo: 7,
      amount: 1000,
      plan: 'Full Day Monthly (₹1,000)',
      paymentMode: 'BHIM UPI',
      utr: 'UPI562910482910',
      dateTime: '10 Oct 2026, 02:30 PM',
      status: 'Received by Admin Kamal ✓',
      receiptNo: 'REC-2026-081',
    ),
  ];

  // Dynamic Alerts & Notifications
  static final List<AppAlert> alerts = [
    AppAlert(
      icon: 'receipt',
      title: 'Fee Payment Received (₹1,000)',
      message: 'Aarav Sharma (Seat 12) paid monthly fee via Google Pay. Transferred to Admin Kamal.',
      time: 'Just now',
      isPayment: true,
    ),
    AppAlert(
      icon: 'book',
      title: 'Hindi & English PDFs Added',
      message: '14 curated study modules with MCQs uploaded for SSC CGL, Maths & Vyakaran.',
      time: 'Today, 08:30 AM',
      isPayment: false,
    ),
    AppAlert(
      icon: 'seat',
      title: 'Seat 12 Confirmed',
      message: 'Your assigned study desk is confirmed for this membership session.',
      time: 'Yesterday',
      isPayment: false,
    ),
  ];

  /// Process direct in-app fee payment to Admin Kamal
  static FeeTransaction payFeeOnline({
    required String memberId,
    required int amount,
    required String paymentMode,
    required String utr,
    String? planName,
  }) {
    final member = members.firstWhere(
      (m) => m.id == memberId,
      orElse: () => members.first,
    );

    // Update member record in live database
    member.feeStatus = 'Paid';
    // Extend due date by 30 days
    member.dueDate = '30 July 2026 (Renewed)';
    
    final newTxnId = 'KL-TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final newReceiptNo = 'REC-2026-${(transactions.length + 85).toString().padLeft(3, '0')}';
    final nowFormatted = 'Today, ${TimeOfDay.now().formatMinutes()}';

    final txn = FeeTransaction(
      txnId: newTxnId,
      memberId: member.id,
      memberName: member.name,
      seatNo: member.seatNo,
      amount: amount,
      plan: planName ?? member.plan,
      paymentMode: paymentMode,
      utr: utr.isNotEmpty ? utr : 'UPI${DateTime.now().millisecondsSinceEpoch}',
      dateTime: nowFormatted,
      status: 'Received by Admin Kamal ✓',
      receiptNo: newReceiptNo,
    );

    // Insert at front
    transactions.insert(0, txn);

    // Add alert
    alerts.insert(
      0,
      AppAlert(
        icon: 'receipt',
        title: 'Fee Payment Received (₹$amount)',
        message: '${member.name} (Seat ${member.seatNo.toString().padLeft(2, '0')}) paid fee via $paymentMode. Credited to Admin Kamal.',
        time: 'Just now',
        isPayment: true,
      ),
    );

    return txn;
  }

  // ==========================================
  // SEAT & SHIFT CHANGE REQUESTS (अर्जी प्रबंधन)
  // ==========================================
  static final List<SeatShiftRequest> seatRequests = [
    SeatShiftRequest(
      id: 'REQ-101',
      memberId: 'KL-0104',
      memberName: 'Priya Verma',
      phone: '+91 98960 99887',
      currentSeat: 4,
      requestedSeat: null,
      currentShift: 'Half Day Morning (07:00 AM - 02:00 PM)',
      requestedShift: 'Full Day (07:00 AM - 10:00 PM)',
      requestType: 'Shift Change',
      reason: 'IBPS PO Exam dates announced for next month. Need full day study access.',
      requestDate: 'Today, 09:30 AM',
      status: 'Pending',
    ),
    SeatShiftRequest(
      id: 'REQ-102',
      memberId: 'KL-0105',
      memberName: 'Rahul Yadav',
      phone: '+91 99920 33445',
      currentSeat: 5,
      requestedSeat: 1,
      currentShift: 'Half Day Evening (02:00 PM - 10:00 PM)',
      requestedShift: 'Half Day Evening (02:00 PM - 10:00 PM)',
      requestType: 'Seat Swap',
      reason: 'Need desk 01 near charging socket for daily laptop practice.',
      requestDate: 'Yesterday, 04:15 PM',
      status: 'Pending',
    ),
    SeatShiftRequest(
      id: 'REQ-100',
      memberId: 'KL-0109',
      memberName: 'Mohit Chahal',
      phone: '+91 98130 55667',
      currentSeat: 9,
      requestedSeat: 9,
      currentShift: 'Half Day Morning',
      requestedShift: 'Full Day (₹1,000)',
      requestType: 'Shift Change',
      reason: 'Shift upgraded for Haryana CET exam.',
      requestDate: '10 Oct 2026',
      status: 'Approved by Kamal',
      adminRemark: 'Approved and fees adjusted to ₹1,000.',
    ),
  ];

  static SeatShiftRequest submitSeatRequest({
    required String memberId,
    required String memberName,
    required String phone,
    required int currentSeat,
    int? requestedSeat,
    required String currentShift,
    required String requestedShift,
    required String requestType,
    required String reason,
  }) {
    final newId = 'REQ-${(seatRequests.length + 103)}';
    final req = SeatShiftRequest(
      id: newId,
      memberId: memberId,
      memberName: memberName,
      phone: phone,
      currentSeat: currentSeat,
      requestedSeat: requestedSeat,
      currentShift: currentShift,
      requestedShift: requestedShift,
      requestType: requestType,
      reason: reason,
      requestDate: 'Today, Just now',
      status: 'Pending',
    );

    seatRequests.insert(0, req);

    // Notify Admin Kamal
    alerts.insert(
      0,
      AppAlert(
        icon: 'seat',
        title: 'New $requestType Request',
        message: '$memberName (Seat $currentSeat) requested: ${requestedSeat != null ? 'New Seat $requestedSeat' : requestedShift}.',
        time: 'Just now',
        isPayment: false,
      ),
    );

    return req;
  }

  static void approveRequest(String requestId, {String? remark}) {
    final req = seatRequests.firstWhere((r) => r.id == requestId);
    req.status = 'Approved by Kamal';
    req.adminRemark = remark ?? 'Approved by Chief Admin Kamal';

    final member = members.firstWhere((m) => m.id == req.memberId);

    // Apply Seat Change if requested
    if (req.requestedSeat != null) {
      member.seatNo = req.requestedSeat!;
    }

    // Apply Shift Change if requested
    if (req.requestedShift.contains('Full Day')) {
      member.shift = LibraryFeeStructure.fullDayTiming;
      member.plan = 'Full Day Monthly (₹1,000)';
      member.amount = LibraryFeeStructure.fullDayMonthly;
    } else if (req.requestedShift.contains('Half Day')) {
      member.shift = req.requestedShift;
      member.plan = 'Half Day Monthly (₹700)';
      member.amount = LibraryFeeStructure.halfDayMonthly;
    }

    alerts.insert(
      0,
      AppAlert(
        icon: 'check',
        title: 'Request Approved by Kamal',
        message: '${member.name}\'s request for ${req.requestType} is approved and active.',
        time: 'Just now',
        isPayment: false,
      ),
    );
  }

  static void declineRequest(String requestId, {String? remark}) {
    final req = seatRequests.firstWhere((r) => r.id == requestId);
    req.status = 'Declined';
    req.adminRemark = remark ?? 'Seat is unavailable or conflict with hall timing.';
  }

  // ==========================================
  // EXPENSE MANAGEMENT & FINANCIALS (खर्च हिसाब)
  // ==========================================
  static final List<LibraryExpense> expenses = [
    LibraryExpense(
      id: 'EXP-501',
      title: 'Monthly Electricity Bill (3 ACs + Hall Lights + Fans)',
      category: 'Electricity',
      amount: 4850,
      date: '10 Oct 2026',
      paymentMode: 'Net Banking (DHBVN)',
      note: 'Meter #489218 - Main Study Hall & Reception',
    ),
    LibraryExpense(
      id: 'EXP-502',
      title: 'High-Speed Fiber Wi-Fi (300 Mbps Unlimited Dual-Band)',
      category: 'Internet / Wi-Fi',
      amount: 1199,
      date: '05 Oct 2026',
      paymentMode: 'UPI (JioFiber)',
      note: 'Account ID: 9812345678 - 300 Mbps unlimited plan',
    ),
    LibraryExpense(
      id: 'EXP-503',
      title: 'RO Water Purifier Service & Filter Replacement',
      category: 'Water & Cleaning',
      amount: 1200,
      date: '02 Oct 2026',
      paymentMode: 'Cash to Technician',
      note: 'Sediment and carbon filter changed + TDS calibration',
    ),
    LibraryExpense(
      id: 'EXP-504',
      title: 'Daily Newspapers & Monthly Exam Magazines',
      category: 'Newspapers',
      amount: 650,
      date: '01 Oct 2026',
      paymentMode: 'Cash at Counter',
      note: 'The Hindu, Dainik Jagran, Pratiyogita Darpan',
    ),
    LibraryExpense(
      id: 'EXP-505',
      title: 'Hall Daily Sanitization & Handwash Supplies',
      category: 'Water & Cleaning',
      amount: 450,
      date: '08 Oct 2026',
      paymentMode: 'UPI (Kamal)',
      note: 'Phenyl, handwash refill, air freshener',
    ),
  ];

  static void addExpense({
    required String title,
    required String category,
    required int amount,
    required String paymentMode,
    String? note,
  }) {
    final newId = 'EXP-${(expenses.length + 506)}';
    expenses.insert(
      0,
      LibraryExpense(
        id: newId,
        title: title,
        category: category,
        amount: amount,
        date: 'Today, ${TimeOfDay.now().formatMinutes()}',
        paymentMode: paymentMode,
        note: note ?? 'Recorded by Admin Kamal',
      ),
    );
  }

  static void deleteExpense(String expenseId) {
    expenses.removeWhere((e) => e.id == expenseId);
  }

  static int get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);
  static int get netProfit => totalRevenueCollected - totalExpenses;
  static int get pendingRequestsCount => seatRequests.where((r) => r.status == 'Pending').length;

  static int get totalOccupied => members.length;
  static int get totalSeats => 27;
  static int get availableSeats => totalSeats - totalOccupied;

  static int get paidCount => members.where((m) => m.feeStatus == 'Paid').length;
  static int get pendingCount => members.where((m) => m.feeStatus == 'Pending').length;

  static int get totalRevenueCollected =>
      members.where((m) => m.feeStatus == 'Paid').fold(0, (sum, m) => sum + m.amount);

  static int get totalPendingAmount =>
      members.where((m) => m.feeStatus == 'Pending').fold(0, (sum, m) => sum + m.amount);

  static int get presentCount => members.where((m) => m.attendanceStatus == 'Present').length;
  static int get breakCount => members.where((m) => m.attendanceStatus == 'On Break').length;
  static int get absentCount => members.where((m) => m.attendanceStatus == 'Absent').length;
}

class FeeTransaction {
  final String txnId;
  final String memberId;
  final String memberName;
  final int seatNo;
  final int amount;
  final String plan;
  final String paymentMode;
  final String utr;
  final String dateTime;
  final String status;
  final String receiptNo;

  FeeTransaction({
    required this.txnId,
    required this.memberId,
    required this.memberName,
    required this.seatNo,
    required this.amount,
    required this.plan,
    required this.paymentMode,
    required this.utr,
    required this.dateTime,
    required this.status,
    required this.receiptNo,
  });
}

class AppAlert {
  final String icon;
  final String title;
  final String message;
  final String time;
  final bool isPayment;

  AppAlert({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isPayment,
  });
}

extension TimeOfDayFormat on TimeOfDay {
  String formatMinutes() {
    final h = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final m = minute.toString().padLeft(2, '0');
    final p = period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }
}

class SeatShiftRequest {
  final String id;
  final String memberId;
  final String memberName;
  final String phone;
  final int currentSeat;
  final int? requestedSeat;
  final String currentShift;
  final String requestedShift;
  final String requestType; // 'Seat Swap', 'Shift Change', 'Both'
  final String reason;
  final String requestDate;
  String status; // 'Pending', 'Approved by Kamal', 'Declined'
  String? adminRemark;

  SeatShiftRequest({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.phone,
    required this.currentSeat,
    this.requestedSeat,
    required this.currentShift,
    required this.requestedShift,
    required this.requestType,
    required this.reason,
    required this.requestDate,
    this.status = 'Pending',
    this.adminRemark,
  });
}

class LibraryExpense {
  final String id;
  final String title;
  final String category; // 'Electricity', 'Internet / Wi-Fi', 'Hall Rent', 'Water & Cleaning', 'Newspapers', 'Repairs & Misc'
  final int amount;
  final String date;
  final String paymentMode; // 'UPI', 'Bank Transfer', 'Cash'
  final String note;

  LibraryExpense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.paymentMode,
    this.note = '',
  });
}


