import 'dart:typed_data';

class CacheService {
  CacheService._();

  static final Map<String, Uint8List> _thumbnailCache = {};

  static Uint8List? getThumbnail(String id) {
    return _thumbnailCache[id];
  }

  static void cacheThumbnail(String id, Uint8List bytes) {
    _thumbnailCache[id] = bytes;
  }

  static void clear() {
    _thumbnailCache.clear();
  }
}