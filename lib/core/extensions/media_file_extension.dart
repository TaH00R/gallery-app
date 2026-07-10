import 'package:photo_manager/photo_manager.dart';

extension AssetEntityExtension on AssetEntity {
  bool get isPhoto => type == AssetType.image;

  bool get isVideo => type == AssetType.video;
}