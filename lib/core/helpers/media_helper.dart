import 'package:photo_manager/photo_manager.dart';

class MediaHelper {
  MediaHelper._();

  static bool isImage(AssetEntity asset) =>
      asset.type == AssetType.image;

  static bool isVideo(AssetEntity asset) =>
      asset.type == AssetType.video;
}