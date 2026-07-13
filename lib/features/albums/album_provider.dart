import 'package:flutter/material.dart';
import 'package:gallery/features/albums/album_service.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumProvider extends ChangeNotifier {
  final AlbumService _albumService = AlbumService();

  List<AssetPathEntity> _albums = [];
  bool _isLoading = false;

  List<AssetPathEntity> get albums => _albums;
  bool get isLoading => _isLoading;

  Future<void> loadAlbums() async {
    _isLoading = true;
    notifyListeners();

    final granted = await _albumService.requestPermission();

    if (granted) {
      _albums = await _albumService.getAlbums();
    }

    _isLoading = false;
    notifyListeners();
  }
}