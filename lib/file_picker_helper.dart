import 'file_picker_model.dart';
import 'file_picker_stub.dart'
    if (dart.library.html) 'file_picker_web.dart' as platform_impl;

export 'file_picker_model.dart';

class LocalFilePicker {
  /// Opens the native device file picker dialog to pick a PDF or document file.
  static void pickPdf({
    required void Function(PickedFileData file) onFilePicked,
    void Function()? onCancel,
  }) {
    platform_impl.pickLocalFile(
      accept: '.pdf,application/pdf,.doc,.docx,.txt',
      onFilePicked: onFilePicked,
      onCancel: onCancel,
    );
  }

  /// Downloads a file to device storage.
  static void download({required String url, required String filename}) {
    platform_impl.downloadFile(url: url, filename: filename);
  }
}
