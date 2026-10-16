// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'file_picker_model.dart';

void pickLocalFile({
  required String accept,
  required void Function(PickedFileData file) onFilePicked,
  void Function()? onCancel,
}) {
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = accept;
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final blobUrl = html.Url.createObjectUrlFromBlob(file);

      if (file.name.endsWith('.txt') || file.name.endsWith('.md')) {
        final reader = html.FileReader();
        reader.onLoadEnd.listen((_) {
          final content = reader.result as String?;
          onFilePicked(
            PickedFileData(
              name: file.name,
              sizeInBytes: file.size,
              blobUrl: blobUrl,
              textContent: content,
            ),
          );
        });
        reader.readAsText(file);
      } else {
        onFilePicked(
          PickedFileData(
            name: file.name,
            sizeInBytes: file.size,
            blobUrl: blobUrl,
          ),
        );
      }
    } else {
      onCancel?.call();
    }
  });
}

void downloadFile({required String url, required String filename}) {
  final anchor = html.AnchorElement(href: url)
    ..target = '_blank'
    ..download = filename;
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
}
