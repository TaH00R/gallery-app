import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/core/services/album_service.dart';
import 'package:gallery/models/album.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumProvider extends ChangeNotifier {
  final AlbumService _service = AlbumService();

  List<Album> _albums = [];
  bool _loading = false;

  bool _initialized = false;
  bool _refreshing = false;

  List<Album> get albums => _albums;
  bool get isLoading => _loading;

  /// Initialize provider and start listening for gallery changes.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await loadAlbums();

    PhotoManager.addChangeCallback(_onGalleryChanged);
    PhotoManager.startChangeNotify();
  }

  /// Reload albums when the gallery changes.
  Future<void> _onGalleryChanged(MethodCall call) async {
    await loadAlbums();
  }

  /// Load all albums.
  Future<void> loadAlbums() async {
    if (_refreshing) return;
    _refreshing = true;

    _loading = true;
    notifyListeners();

    try {
      final hasPermission = await _service.requestPermission();

      if (!hasPermission) {
        _albums = [];
        return;
      }

      _albums = await _service.getAlbums();
    } catch (e) {
      debugPrint("AlbumProvider Error: $e");
    } finally {
      _loading = false;
      _refreshing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    PhotoManager.removeChangeCallback(_onGalleryChanged);
    PhotoManager.stopChangeNotify();
    super.dispose();
  }
}