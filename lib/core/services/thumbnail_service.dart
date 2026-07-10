import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class ThumbnailService {
  ThumbnailService._();

  static Future<Uint8List?> loadThumbnail(
    AssetEntity asset,
  ) async {
    return asset.thumbnailDataWithSize(
      const ThumbnailSize(400, 400),
    );
  }
}