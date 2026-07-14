import 'package:photo_manager/photo_manager.dart';

class AlbumService {
  /// Request gallery permission
  Future<bool> requestPermission() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission.isAuth;
  }

  /// Get all albums
  Future<List<AssetPathEntity>> getAlbums() async {
    return PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: false,
    );
  }

  /// Get media from an album
  Future<List<AssetEntity>> getAlbumMedia(
    AssetPathEntity album, {
    int page = 0,
    int size = 100,
  }) async {
    return album.getAssetListPaged(
      page: page,
      size: size,
    );
  }

  /// Number of items in an album
  Future<int> getAlbumCount(AssetPathEntity album) async {
    return album.assetCountAsync;
  }

  /// Cover image
  Future<AssetEntity?> getAlbumCover(
    AssetPathEntity album,
  ) async {
    final assets = await album.getAssetListPaged(
      page: 0,
      size: 1,
    );

    return assets.isEmpty ? null : assets.first;
  }
}