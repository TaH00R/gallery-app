import 'dart:io';

class MetadataService {
  MetadataService._();

  static Future<int> getFileSize(File file) async {
    return await file.length();
  }

  static Future<DateTime> getModifiedDate(File file) async {
    return await file.lastModified();
  }
}