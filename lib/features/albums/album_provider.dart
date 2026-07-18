import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/core/services/album_service.dart';
import 'package:gallery/models/album.dart';
import 'package:photo_manager/photo_manager.dart';

enum AlbumSort {
  az,
  za,
}
class AlbumProvider extends ChangeNotifier {
  final AlbumService _service = AlbumService();

  List<Album> _allAlbums = [];
  List<Album> _albums = [];
  bool _loading = false;

  bool _initialized = false;
  bool _refreshing = false;

  AlbumSort _currentSort = AlbumSort.az;
  String _searchQuery = ""; 
  

  List<Album> get albums => _albums;
  bool get isLoading => _loading;

// Filter albums based on search query and sort order.
  void search(String query) {
  _searchQuery = query;
  _applyFilters();
  notifyListeners();
}

// Apply search and sort filters to the albums list.
void sort(AlbumSort sort) {
  _currentSort = sort;
  _applyFilters();
  notifyListeners();
}

// Apply search and sort filters to the albums list.
void _applyFilters() {
  _albums = _allAlbums.where((album) {
    return album.name
        .toLowerCase()
        .contains(_searchQuery.toLowerCase());
  }).toList();

  switch (_currentSort) {
    case AlbumSort.az:
      _albums.sort((a, b) => a.name.compareTo(b.name));
      break;

    case AlbumSort.za:
      _albums.sort((a, b) => b.name.compareTo(a.name));
      break;
  }
}

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

      _allAlbums = await _service.getAlbums();
  _applyFilters();
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