import 'file_picker_model.dart';

void pickLocalFile({
  required String accept,
  required void Function(PickedFileData file) onFilePicked,
  void Function()? onCancel,
}) {
  // Stub fallback for non-web environments
}

void downloadFile({required String url, required String filename}) {
  // Stub fallback for non-web environments
}
