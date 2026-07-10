import 'dart:io';

class FileUtils {
  FileUtils._();

  static bool exists(String path) {
    return File(path).existsSync();
  }

  static int size(String path) {
    return File(path).lengthSync();
  }

  static String extension(String path) {
    return path.split('.').last;
  }
}