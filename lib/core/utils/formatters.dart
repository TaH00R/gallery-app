class Formatters {
  Formatters._();

  static String formatDuration(Duration duration) {
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);

    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    }

    return "${(bytes / 1024 / 1024).toStringAsFixed(1)} MB";
  }
}