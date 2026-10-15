import 'receipt_printer_stub.dart'
    if (dart.library.html) 'receipt_printer_web.dart' as platform_impl;

class ReceiptPrinterHelper {
  static void printReceipt(String htmlContent) {
    platform_impl.ReceiptPrinterPlatform.printReceiptHtml(htmlContent);
  }

  static void downloadReceipt({required String filename, required String htmlContent}) {
    platform_impl.ReceiptPrinterPlatform.downloadReceiptFile(
      filename: filename,
      htmlContent: htmlContent,
    );
  }
}
