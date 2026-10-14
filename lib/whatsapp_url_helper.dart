import 'whatsapp_url_stub.dart'
    if (dart.library.html) 'whatsapp_url_web.dart' as platform_impl;

class WhatsAppLauncher {
  static void openChat({required String phone, required String message}) {
    // Sanitize phone number (remove spaces, +, dashes)
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (!cleanPhone.startsWith('91') && cleanPhone.length == 10) {
      cleanPhone = '91$cleanPhone';
    }
    final encodedText = Uri.encodeComponent(message);
    final url = 'https://wa.me/$cleanPhone?text=$encodedText';
    platform_impl.openWhatsAppUrl(url);
  }
}
