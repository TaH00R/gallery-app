import 'package:photo_manager/photo_manager.dart';

class GalleryService {
  GalleryService._();

  static Future<List<AssetPathEntity>> getAlbums() async {
    return PhotoManager.getAssetPathList(
      type: RequestType.common,
    );
  }

  static Future<List<AssetEntity>> getMedia(
    AssetPathEntity album,
  ) async {
    return album.getAssetListPaged(
      page: 0,
      size: await album.assetCountAsync,
    );
  }
}