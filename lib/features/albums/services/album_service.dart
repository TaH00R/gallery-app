import 'package:gallery/models/album.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumService {
  Future<bool> requestPermission() async {
    final permission = await PhotoManager.requestPermissionExtend();
    return permission.isAuth;
  }

  Future<List<Album>> getAlbums() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: false,
    );

    List<Album> albums = [];

    for (final path in paths) {
      final assets = await path.getAssetListPaged(
        page: 0,
        size: 1,
      );

      albums.add(
        Album(
          entity: path,
          cover: assets.isEmpty ? null : assets.first,
          count: await path.assetCountAsync,
        ),
      );
    }

    return albums;
  }

  Future<List<AssetEntity>> getMedia(
    AssetPathEntity album, {
    int page = 0,
    int size = 100,
  }) {
    return album.getAssetListPaged(
      page: page,
      size: size,
    );
  }
}