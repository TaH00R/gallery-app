import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class ThumbnailHelper {
  ThumbnailHelper._();

  static Future<Uint8List?> loadThumbnail(
    AssetEntity asset,
  ) async {
    return asset.thumbnailDataWithSize(
      const ThumbnailSize(300, 300),
    );
  }
}