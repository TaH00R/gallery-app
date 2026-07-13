class MediaInfo {
  final int width;
  final int height;
  final int size;
  final String mimeType;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  const MediaInfo({
    required this.width,
    required this.height,
    required this.size,
    required this.mimeType,
    required this.createdAt,
    this.modifiedAt,
  });
}