import 'package:flutter/material.dart';
import 'admin_data.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);
const gold = Color(0xFFD4AF37);

/// Opens the Digital Library ID Card modal sheet for a member.
void showStudentIdCardSheet(
  BuildContext context, {
  MemberRecord? member,
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
    builder: (ctx) => _StudentIdCardModal(member: student),
  );
}

class _StudentIdCardModal extends StatefulWidget {
  final MemberRecord member;

  const _StudentIdCardModal({required this.member});

  @override
  State<_StudentIdCardModal> createState() => _StudentIdCardModalState();
}

class _StudentIdCardModalState extends State<_StudentIdCardModal> {
  bool showBack = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.member;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.90,
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.badge_outlined, color: blue, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Digital ID Card',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                      ),
                      Text(
                        'Official Gate Pass & Library Identity • Krishna Library',
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

          // Flip Switcher
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => showBack = false),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !showBack ? navy : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Card Front (पहचान पत्र)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: !showBack ? Colors.white : navy,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => showBack = true),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: showBack ? navy : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Card Back (नियम व आपातकालीन)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: showBack ? Colors.white : navy,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ID Card Container View
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showBack ? _buildCardBack(m) : _buildCardFront(m),
                  ),
                ),
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: navy,
                      side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.flip_camera_android, size: 18),
                    label: Text(showBack ? 'Show Front' : 'Flip to Back', style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => setState(() => showBack = !showBack),
                  ),
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
                    icon: const Icon(Icons.download_for_offline_outlined, size: 18),
                    label: const Text('Download Pass', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('ID Card of ${m.name} (${m.id}) saved to downloads successfully!'),
                          backgroundColor: green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD FRONT DESIGN (स्मार्ट डिजिटल आईडी)
  // ==========================================
  Widget _buildCardFront(MemberRecord m) {
    final initials = m.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return Container(
      key: const ValueKey('front'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8E2EC), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar with Library Name and Crest
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D233A), Color(0xFF1B3A57)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_stories, color: navy, size: 24),
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
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Self-Study & Focus Center • Branch 01',
                        style: TextStyle(
                          color: Color(0xFFF2B84B),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),

          // Sub-ribbon: STUDENT IDENTITY CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: const Color(0xFFE2E8F0),
            alignment: Alignment.center,
            child: const Text(
              'STUDENT IDENTITY CARD • सत्र 2025-2026',
              style: TextStyle(
                color: navy,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ),

          // Main Card Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar, Name and Roll No
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Box
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 76,
                          height: 86,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF26466D), Color(0xFF102A43)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: gold, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -6,
                          left: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'STUDENT',
                              style: TextStyle(
                                color: navy,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Name, ID and Exam
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: navy,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                'Member ID: ${m.id}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: blue,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, size: 14, color: blue),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '🎯 Target: ${m.exam}',
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📞 ${m.phone}',
                            style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Seat & Shift Info Matrix
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildIdMetaBlock(
                              'ALLOTTED SEAT',
                              'DESK S-${m.seatNo.toString().padLeft(2, '0')}',
                              purple,
                              Icons.event_seat,
                            ),
                          ),
                          Container(width: 1, height: 36, color: const Color(0xFFCBD5E1)),
                          Expanded(
                            child: _buildIdMetaBlock(
                              'VALID UNTIL',
                              m.dueDate,
                              green,
                              Icons.calendar_today,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildIdMetaBlock(
                              'DAILY SHIFT',
                              m.shift.split(' (').first,
                              navy,
                              Icons.schedule,
                            ),
                          ),
                          Container(width: 1, height: 36, color: const Color(0xFFCBD5E1)),
                          Expanded(
                            child: _buildIdMetaBlock(
                              'PLAN AMOUNT',
                              '₹${m.amount}/mo (Paid)',
                              blue,
                              Icons.verified_user,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Simulated QR & Barcode Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mock QR Code
                    Container(
                      width: 62,
                      height: 62,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(54, 54),
                            painter: _SimpleQrPainter(),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: navy,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Icon(Icons.school, size: 9, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Barcode & Verification text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1D Barcode bars simulation
                          CustomPaint(
                            size: const Size(180, 24),
                            painter: _BarcodePainter(),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '*KL-PASS-${m.id.replaceAll('KL-', '')}-${m.seatNo}*',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.5,
                              letterSpacing: 2,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Scan at entry gate for automatic attendance punch',
                            style: TextStyle(fontSize: 8.5, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Official Seal & Admin Sign
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Official Seal Badge
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: gold, width: 2),
                            color: gold.withValues(alpha: 0.12),
                          ),
                          child: const Center(
                            child: Icon(Icons.verified_outlined, color: Color(0xFFB8860B), size: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('OFFICIAL SEAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: navy)),
                            Text('Branch 01 Regd.', style: TextStyle(fontSize: 8.5, color: Colors.blueGrey)),
                          ],
                        ),
                      ],
                    ),

                    // Admin Kamal Signature
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        Container(height: 1, width: 90, color: navy.withValues(alpha: 0.3)),
                        const SizedBox(height: 2),
                        const Text(
                          'Library Director (Kamal)',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD BACK DESIGN (नियम, शर्ते व इमरजेंसी)
  // ==========================================
  Widget _buildCardBack(MemberRecord m) {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8E2EC), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: navy,
            child: const Row(
              children: [
                Icon(Icons.gavel, color: Color(0xFFF2B84B), size: 18),
                SizedBox(width: 8),
                Text(
                  'TERMS OF ADMISSION & CODE OF CONDUCT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRuleItem(1, 'Pin-drop silence must be observed at all times in the study hall.'),
                _buildRuleItem(2, 'This ID card is strictly non-transferable and must be carried daily.'),
                _buildRuleItem(3, 'Assigned Seat S-${m.seatNo} cannot be swapped without Admin Kamal\'s approval.'),
                _buildRuleItem(4, 'Mobile phones must remain on Silent / Vibrate mode at all desks.'),
                _buildRuleItem(5, 'Eating food & group discussions are permitted only in the pantry area.'),
                _buildRuleItem(6, 'High-Speed Wi-Fi is for educational purposes only (single device per student).'),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                // Emergency & Help Contacts
                const Text(
                  'Emergency & Helpdesk Contacts:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: navy),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Chief Admin Kamal (Director):',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ),
                          Text(
                            '+91 94160 00000',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: blue),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.desk, size: 16, color: green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Reception Helpdesk (Shift Issues):',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ),
                          Text(
                            '+91 98123 99999',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: green),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Branch 01, Main Market Road, Opp. Govt College',
                              style: TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Footer Note
                Center(
                  child: Text(
                    'If found lost, please return to Krishna Library Reception.\nCardholder ID: ${m.id} • Seat S-${m.seatNo}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9.5, color: Colors.blueGrey, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdMetaBlock(String label, String value, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(int no, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$no',
              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: navy),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// CUSTOM PAINTERS FOR SIMULATED QR & BARCODE
// ==========================================
class _SimpleQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = navy..style = PaintingStyle.fill;
    final w = size.width / 7;
    final h = size.height / 7;

    // Top-Left Finder
    canvas.drawRect(Rect.fromLTWH(0, 0, w * 2.5, h * 2.5), paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.5, h * 0.5, w * 1.5, h * 1.5), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(w * 0.8, h * 0.8, w * 0.9, h * 0.9), paint);

    // Top-Right Finder
    canvas.drawRect(Rect.fromLTWH(w * 4.5, 0, w * 2.5, h * 2.5), paint);
    canvas.drawRect(Rect.fromLTWH(w * 5.0, h * 0.5, w * 1.5, h * 1.5), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(w * 5.3, h * 0.8, w * 0.9, h * 0.9), paint);

    // Bottom-Left Finder
    canvas.drawRect(Rect.fromLTWH(0, h * 4.5, w * 2.5, h * 2.5), paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.5, h * 5.0, w * 1.5, h * 1.5), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(w * 0.8, h * 5.3, w * 0.9, h * 0.9), paint);

    // Some decorative data bits
    canvas.drawRect(Rect.fromLTWH(w * 3, h * 1, w, h), paint);
    canvas.drawRect(Rect.fromLTWH(w * 3, h * 3, w, h), paint);
    canvas.drawRect(Rect.fromLTWH(w * 4, h * 4, w, h), paint);
    canvas.drawRect(Rect.fromLTWH(w * 5, h * 5, w, h), paint);
    canvas.drawRect(Rect.fromLTWH(w * 3, h * 5, w, h), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = navy..style = PaintingStyle.fill;
    final barWidths = [
      3.0, 1.0, 2.0, 4.0, 1.0, 3.0, 1.0, 2.0, 5.0, 1.0, 2.0, 3.0, 1.0, 4.0, 2.0,
      1.0, 3.0, 2.0, 4.0, 1.0, 3.0, 1.0, 2.0, 4.0, 1.0, 3.0, 2.0, 1.0, 4.0, 2.0,
      1.0, 3.0, 1.0, 2.0, 4.0, 1.0, 3.0, 2.0, 1.0, 4.0, 1.0, 3.0, 2.0, 1.0, 3.0
    ];

    double x = 0;
    bool isBar = true;
    for (final w in barWidths) {
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
