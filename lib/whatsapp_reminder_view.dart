import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_data.dart';
import 'payment_view.dart';
import 'whatsapp_url_helper.dart';

const waGreen = Color(0xFF25D366);
const waDarkGreen = Color(0xFF075E54);
const waTeal = Color(0xFF128C7E);
const navy = Color(0xFF102A43);
const blue = Color(0xFF1769AA);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);

class WhatsAppTemplates {
  static String polite({
    required MemberRecord member,
    required String adminName,
    required String adminUpiId,
    required String adminPhone,
  }) {
    return '''
🏛️ *श्री कृष्णा लाइब्रेरी (Krishna Library)*
प्रिय *${member.name}* जी,

सादर प्रणाम। यह एक विनम्र स्मरण पत्र है कि आपकी लाइब्रेरी सीट की मासिक फीस का विवरण निम्न प्रकार है:

🪑 *सीट नंबर:* Seat S-${member.seatNo.toString().padLeft(2, '0')} (${member.shift})
💰 *बकाया फीस राशि:* ₹${member.amount}
📅 *देय तिथि (Due Date):* ${member.dueDate}

कृपया अपनी निर्धारित सीट को सुरक्षित रखने हेतु आज ही फीस ऑनलाइन जमा करें:
📲 *Admin Kamal UPI ID:* `$adminUpiId`
💳 *Payment Apps:* GPay / PhonePe / Paytm / BHIM UPI

भुगतान के पश्चात कृपया UTR / स्क्रीनशॉट इसी नंबर पर साझा करें।

धन्यवाद!
*$adminName (डायरेक्टर)*
*श्री कृष्णा लाइब्रेरी, ब्रांच-01*
📞 $adminPhone
'''.trim();
  }

  static String warning({
    required MemberRecord member,
    required String adminName,
    required String adminUpiId,
    required String adminPhone,
  }) {
    return '''
⚠️ *अति-आवश्यक सूचना: फीस अति-देय (Overdue Notice)*
🏛️ *श्री कृष्णा लाइब्रेरी (Krishna Library)*
प्रिय *${member.name}* जी,

आपके अध्ययन कक्ष की मासिक फीस अभी तक लंबित है:
🪑 *आवंटित डेस्क:* Seat S-${member.seatNo.toString().padLeft(2, '0')}
💰 *देय राशि:* ₹${member.amount}
⚠️ *विलंब स्थिति:* ${member.dueDate}

लाइब्रेरी नियमावली के अनुसार 48 घंटे के भीतर भुगतान न होने पर यह सीट प्रतीक्षा सूची (Waiting List) के छात्र को आवंटित कर दी जाएगी।

तुरंत UPI द्वारा शुल्क जमा करें:
📲 *UPI ID:* `$adminUpiId`
(PhonePe / Google Pay / Paytm)

सादर,
*$adminName (चीफ डायरेक्टर)*
कृष्णा लाइब्रेरी • मेन ब्रांच
📞 $adminPhone
'''.trim();
  }

  static String upiLink({
    required MemberRecord member,
    required String adminName,
    required String adminUpiId,
  }) {
    return '''
💳 *त्वरित UPI फीस भुगतान लिंक (Krishna Library)*
छात्र का नाम: *${member.name}* (ID: ${member.id})
सीट नंबर: *Seat S-${member.seatNo.toString().padLeft(2, '0')}*
कुल देय: *₹${member.amount}*

नीचे दिए गए UPI ID पर सीधे ₹${member.amount} ट्रांसफर करें:
👉 `$adminUpiId`
खाताधारक: *$adminName (Krishna Library)*

GPay, PhonePe, Paytm या Cred ऐप में UPI ID पेस्ट करके ट्रांसफर करें।
'''.trim();
  }
}

/// Opens the 1-Click WhatsApp Fee Due Reminder sheet for a single member
void showWhatsAppReminderSheet(
  BuildContext context, {
  required MemberRecord member,
  VoidCallback? onSent,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SingleWhatsAppReminderModal(
      member: member,
      onSent: onSent,
    ),
  );
}

class _SingleWhatsAppReminderModal extends StatefulWidget {
  final MemberRecord member;
  final VoidCallback? onSent;

  const _SingleWhatsAppReminderModal({
    required this.member,
    this.onSent,
  });

  @override
  State<_SingleWhatsAppReminderModal> createState() => _SingleWhatsAppReminderModalState();
}

class _SingleWhatsAppReminderModalState extends State<_SingleWhatsAppReminderModal> {
  String selectedTemplateId = 'polite'; // 'polite', 'warning', 'upi_link'
  late TextEditingController messageController;
  late TextEditingController phoneController;
  bool isCopied = false;
  bool saveToStudentProfile = false;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: _generateMessage('polite'));
    phoneController = TextEditingController(text: widget.member.phone);
  }

  @override
  void dispose() {
    messageController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String _generateMessage(String templateId) {
    if (templateId == 'warning') {
      return WhatsAppTemplates.warning(
        member: widget.member,
        adminName: AdminData.adminName,
        adminUpiId: AdminData.adminUpiId,
        adminPhone: AdminData.adminPhone,
      );
    } else if (templateId == 'upi_link') {
      return WhatsAppTemplates.upiLink(
        member: widget.member,
        adminName: AdminData.adminName,
        adminUpiId: AdminData.adminUpiId,
      );
    }
    return WhatsAppTemplates.polite(
      member: widget.member,
      adminName: AdminData.adminName,
      adminUpiId: AdminData.adminUpiId,
      adminPhone: AdminData.adminPhone,
    );
  }

  void _switchTemplate(String templateId) {
    setState(() {
      selectedTemplateId = templateId;
      messageController.text = _generateMessage(templateId);
      isCopied = false;
    });
  }

  void _copyNotice() {
    Clipboard.setData(ClipboardData(text: messageController.text));
    setState(() => isCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WhatsApp fee reminder copied to clipboard!'),
        backgroundColor: waDarkGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendViaWhatsApp() {
    final text = messageController.text.trim();
    final targetPhone = phoneController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया कोई संदेश दर्ज करें।')),
      );
      return;
    }

    if (targetPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सही 10-अंकीय फोन नंबर दर्ज करें।')),
      );
      return;
    }

    if (saveToStudentProfile) {
      widget.member.phone = targetPhone;
    }

    // Launch WhatsApp directly with targetPhone (real or student)
    WhatsAppLauncher.openChat(
      phone: targetPhone,
      message: text,
    );

    // Also copy to clipboard for convenience
    Clipboard.setData(ClipboardData(text: text));

    // Record an Admin Alert in system
    AdminData.alerts.insert(
      0,
      AppAlert(
        icon: 'payment',
        title: 'WhatsApp Reminder Sent',
        message: 'Dispatched fee notice to ${widget.member.name} (Seat ${widget.member.seatNo.toString().padLeft(2, '0')}) on $targetPhone for ₹${widget.member.amount}.',
        time: 'Just now',
        isPayment: true,
      ),
    );

    widget.onSent?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp for $targetPhone...'),
        backgroundColor: waDarkGreen,
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    color: waGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.chat_bubble_outline, color: waDarkGreen, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            '1-Click WhatsApp Notice',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.verified, color: waGreen, size: 16),
                        ],
                      ),
                      Text(
                        'Direct reminder to ${widget.member.name} • ${widget.member.phone}',
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),

            // Target Student Summary Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: red.withValues(alpha: 0.15),
                    child: Text(
                      widget.member.name.isNotEmpty ? widget.member.name[0] : 'S',
                      style: const TextStyle(color: red, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.member.name,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: navy),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Seat S-${widget.member.seatNo.toString().padLeft(2, '0')} • ${widget.member.shift}',
                          style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Status: ${widget.member.dueDate}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: red),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('OVERDUE', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${widget.member.amount}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Recipient WhatsApp Mobile Number Input Box (Editable for Real/Original Phone testing)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: waGreen.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.phone_android, size: 16, color: waDarkGreen),
                          SizedBox(width: 6),
                          Text(
                            'Recipient Phone (भेजने वाला व्हाट्सएप नंबर):',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: waDarkGreen),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            phoneController.text = widget.member.phone;
                          });
                        },
                        child: const Text('Reset ↻', style: TextStyle(color: blue, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: (val) => setState(() {}),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.chat_bubble_outline, color: waGreen, size: 20),
                      hintText: 'Enter 10-digit original phone number (e.g. 9812345678)',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: waGreen, width: 2)),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: navy),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.info_outline, size: 13, color: Colors.blueGrey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '💡 आप यहाँ अपना असली व्हाट्सएप नंबर डालकर तुरंत टेस्ट कर सकते हैं।',
                          style: TextStyle(fontSize: 10.5, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Checkbox(
                        value: saveToStudentProfile,
                        activeColor: waDarkGreen,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (val) => setState(() => saveToStudentProfile = val ?? false),
                      ),
                      const Expanded(
                        child: Text(
                          'Save this number in student permanent library record',
                          style: TextStyle(fontSize: 11, color: navy, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Template Selector Chips
            const Text(
              'Select Notice Message Style (संदेश प्रारूप चुनें):',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: navy),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTemplateChip('polite', '🙏 नम्र तगादा (Polite)'),
                _buildTemplateChip('warning', '⚠️ अंतिम चेतावनी (Warning)'),
                _buildTemplateChip('upi_link', '💳 केवल UPI लिंक (Payment Link)'),
              ],
            ),
            const SizedBox(height: 14),

            // WhatsApp Chat Bubble Preview Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEAE2), // WhatsApp wallpaper bg
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD1D7DB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.chat, size: 14, color: waDarkGreen),
                          SizedBox(width: 6),
                          Text(
                            'WhatsApp Preview (लाइव पूर्वावलोकन)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: waDarkGreen),
                          ),
                        ],
                      ),
                      Text(
                        'To: ${phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : widget.member.phone}',
                        style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Chat bubble
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9FDD3), // Outgoing WhatsApp bubble green
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: messageController,
                          maxLines: 8,
                          style: const TextStyle(fontSize: 12.5, height: 1.4, color: Colors.black87),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Just now • ', style: TextStyle(fontSize: 10, color: Colors.black45)),
                            Icon(Icons.done_all, size: 14, color: Color(0xFF53BDEB)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Actions: Open WhatsApp, Copy Notice, Mark Paid
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: waGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text(
                      'Open WhatsApp & Send',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                    ),
                    onPressed: _sendViaWhatsApp,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isCopied ? green : navy,
                      side: BorderSide(color: isCopied ? green : const Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: Icon(isCopied ? Icons.check : Icons.copy, size: 17),
                    label: Text(
                      isCopied ? 'Copied ✓' : 'Copy Text',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                    onPressed: _copyNotice,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Alternative Action: Collect in person / Mark Paid
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: green,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 17),
                label: Text(
                  'Received cash/transfer already? Collect & Mark Seat S-${widget.member.seatNo.toString().padLeft(2, '0')} Paid',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showFeePaymentSheet(
                    context,
                    member: widget.member,
                    onPaymentSuccess: widget.onSent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateChip(String templateId, String label) {
    final isSelected = selectedTemplateId == templateId;
    return InkWell(
      onTap: () => _switchTemplate(templateId),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? waDarkGreen : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? waDarkGreen : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            color: isSelected ? Colors.white : navy,
          ),
        ),
      ),
    );
  }
}

/// Opens the Batch WhatsApp Reminder for all overdue members
void showBatchWhatsAppReminderSheet(BuildContext context, {VoidCallback? onSent}) {
  final pendingMembers = AdminData.members.where((m) => m.feeStatus == 'Pending').toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setBatchState) {
        final totalOverdue = pendingMembers.fold<int>(0, (sum, m) => sum + m.amount);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.82,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: waGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.campaign_outlined, color: waDarkGreen, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Batch WhatsApp Fee Notices',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                          ),
                          Text(
                            '${pendingMembers.length} students have fee dues pending (Total: ₹$totalOverdue)',
                            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 14),

                // Top Total Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF380D0D), Color(0xFF6B1D1D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL OVERDUE REVENUE',
                            style: TextStyle(color: Color(0xFFFF9E9E), fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹$totalOverdue',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${pendingMembers.length} active library seats awaiting payment',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: waGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.send, size: 15),
                        label: const Text('Send All', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                        onPressed: () {
                          // Copy consolidated broadcast notice
                          final consolidated = StringBuffer();
                          consolidated.writeln('📢 *कृष्णा लाइब्रेरी फीस तगादा सूची (Admin Kamal)*');
                          consolidated.writeln('कुल बकाया: ₹$totalOverdue (${pendingMembers.length} छात्र)\n');
                          for (final m in pendingMembers) {
                            consolidated.writeln('• ${m.name} (Seat S-${m.seatNo}): ₹${m.amount} (${m.dueDate}) - ${m.phone}');
                          }
                          consolidated.writeln('\nUPI ID: ${AdminData.adminUpiId}');
                          Clipboard.setData(ClipboardData(text: consolidated.toString()));

                          for (final m in pendingMembers) {
                            AdminData.alerts.insert(
                              0,
                              AppAlert(
                                icon: 'payment',
                                title: 'Batch WhatsApp Sent',
                                message: 'Dispatched fee notice to ${m.name} (Seat ${m.seatNo}) for ₹${m.amount}.',
                                time: 'Just now',
                                isPayment: true,
                              ),
                            );
                          }

                          onSent?.call();
                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Consolidated fee reminders generated & copied! Admin alerts logged.'),
                              backgroundColor: waDarkGreen,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Pending Fee Students List (व्यक्तिगत रूप से भेजें):',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: navy),
                ),
                const SizedBox(height: 10),

                // List of pending members
                Expanded(
                  child: ListView.separated(
                    itemCount: pendingMembers.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 10),
                    itemBuilder: (c, idx) {
                      final m = pendingMembers[idx];
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
                                color: red.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'S${m.seatNo.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontWeight: FontWeight.w900, color: red, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.name,
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: navy),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${m.phone} • ${m.shift}',
                                    style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Due: ${m.dueDate}',
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: red),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${m.amount}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: red),
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: waGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: const Icon(Icons.send_rounded, size: 12),
                                  label: const Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    showWhatsAppReminderSheet(
                                      context,
                                      member: m,
                                      onSent: () {
                                        setBatchState(() {});
                                        onSent?.call();
                                      },
                                    );
                                  },
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
