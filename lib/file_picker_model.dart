class PickedFileData {
  final String name;
  final int sizeInBytes;
  final String blobUrl;
  final String? textContent;

  const PickedFileData({
    required this.name,
    required this.sizeInBytes,
    required this.blobUrl,
    this.textContent,
  });

  String get formattedSize {
    if (sizeInBytes <= 0) return 'Document File';
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
