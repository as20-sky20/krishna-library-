// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;

class ReceiptPrinterPlatform {
  static void printReceiptHtml(String htmlContent) {
    try {
      // Injects automatic window.print() inside the HTML
      final printableHtml = htmlContent.replaceFirst(
        '</body>',
        '<script>window.onload = function() { setTimeout(function(){ window.print(); }, 250); };</script></body>',
      );
      final encodedUri = Uri.dataFromString(
        printableHtml,
        mimeType: 'text/html',
        encoding: utf8,
      ).toString();
      html.window.open(encodedUri, '_blank');
    } catch (_) {
      html.window.print();
    }
  }

  static void downloadReceiptFile({required String filename, required String htmlContent}) {
    try {
      final bytes = utf8.encode(htmlContent);
      final blob = html.Blob([bytes], 'text/html');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (_) {
      // Fallback ignored
    }
  }
}
