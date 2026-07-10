extension StringExtension on String {
  bool get isImage {
    final lower = toLowerCase();

    return lower.endsWith(".jpg") ||
        lower.endsWith(".jpeg") ||
        lower.endsWith(".png") ||
        lower.endsWith(".gif") ||
        lower.endsWith(".webp");
  }

  bool get isVideo {
    final lower = toLowerCase();

    return lower.endsWith(".mp4") ||
        lower.endsWith(".mov") ||
        lower.endsWith(".mkv") ||
        lower.endsWith(".avi");
  }

  String capitalize() {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1);
  }
}