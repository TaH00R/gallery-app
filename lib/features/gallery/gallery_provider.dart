import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

enum SortMode { newest, oldest }

enum GalleryFilter {
  all,
  photos,
  videos,
  favorites,
}

class GalleryProvider extends ChangeNotifier {
  GalleryProvider({this.album});

  final AssetPathEntity? album;

  final ScrollController scrollController = ScrollController();

  final List<AssetEntity> _allAssets = [];
  final List<AssetEntity> _assets = [];
  final Set<AssetEntity> _selectedAssets = {};

  bool _selectionMode = false;
  bool _isDeleting = false;
  bool _isLoading = false;
  bool _isListening = false;

  GalleryFilter _selectedFilter = GalleryFilter.all;
  SortMode _sortMode = SortMode.newest;

  // Getters
  UnmodifiableListView<AssetEntity> get assets =>
      UnmodifiableListView(_assets);

  UnmodifiableSetView<AssetEntity> get selectedAssets =>
      UnmodifiableSetView(_selectedAssets);

  bool get selectionMode => _selectionMode;

  bool get isDeleting => _isDeleting;

  bool get isLoading => _isLoading;

  GalleryFilter get selectedFilter => _selectedFilter;

  SortMode get sortMode => _sortMode;

  int get selectedCount => _selectedAssets.length;

  bool get areAllSelectedFavorite =>
      _selectedAssets.isNotEmpty &&
      _selectedAssets.every((e) => e.isFavorite);

  // Asset Loading
  Future<void> fetchAssets() async {
    _isLoading = true;
    notifyListeners();

    List<AssetEntity> result;

    if (album == null) {
      result = await PhotoManager.getAssetListRange(
        start: 0,
        end: 1000000,
      );
    } else {
      result = await album!.getAssetListPaged(
        page: 0,
        size: 200,
      );
    }

    _allAssets
      ..clear()
      ..addAll(result);

    _applyFilter();

    _isLoading = false;
    notifyListeners();
  }

  // Filters
  void setFilter(GalleryFilter filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    _applyFilter();

    notifyListeners();
  }

  void toggleSort() {
    _sortMode = _sortMode == SortMode.newest
        ? SortMode.oldest
        : SortMode.newest;

    _applyFilter();

    notifyListeners();
  }

  void _applyFilter() {
    _assets.clear();

    switch (_selectedFilter) {
      case GalleryFilter.all:
        _assets.addAll(_allAssets);
        break;

      case GalleryFilter.photos:
        _assets.addAll(
          _allAssets.where((a) => a.type == AssetType.image),
        );
        break;

      case GalleryFilter.videos:
        _assets.addAll(
          _allAssets.where((a) => a.type == AssetType.video),
        );
        break;

      case GalleryFilter.favorites:
        _assets.addAll(
          _allAssets.where((a) => a.isFavorite),
        );
        break;
    }

    _assets.sort((a, b) {
      return _sortMode == SortMode.newest
          ? b.createDateTime.compareTo(a.createDateTime)
          : a.createDateTime.compareTo(b.createDateTime);
    });
  }

  // Selection
  void startSelection(AssetEntity asset) {
    _selectionMode = true;
    _selectedAssets.add(asset);

    notifyListeners();
  }

  void toggleSelection(AssetEntity asset) {
    if (_selectedAssets.contains(asset)) {
      _selectedAssets.remove(asset);

      if (_selectedAssets.isEmpty) {
        _selectionMode = false;
      }
    } else {
      _selectedAssets.add(asset);
    }

    notifyListeners();
  }

  void clearSelection() {
    if (_selectedAssets.isEmpty && !_selectionMode) return;

    _selectedAssets.clear();
    _selectionMode = false;

    notifyListeners();
  }

  // Internal Media Operations
  Future<void> _deleteAssets(List<AssetEntity> assets) async {
    if (_isDeleting || assets.isEmpty) return;

    _isDeleting = true;
    notifyListeners();

    try {
      final ids = assets.map((e) => e.id).toList();

      final deletedIds = await PhotoManager.editor.deleteWithIds(ids);

      if (deletedIds.isNotEmpty) {
        _allAssets.removeWhere((a) => deletedIds.contains(a.id));
        _assets.removeWhere((a) => deletedIds.contains(a.id));
      }
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  Future<void> _shareAssets(List<AssetEntity> assets) async {
    if (assets.isEmpty) return;

    final files = <XFile>[];

    for (final asset in assets) {
      final file = await asset.originFile;
      if (file != null) {
        files.add(XFile(file.path));
      }
    }

    if (files.isEmpty) return;

    await SharePlus.instance.share(
      ShareParams(files: files),
    );
  }

  Future<void> _toggleFavoriteAssets(List<AssetEntity> assets) async {
    if (assets.isEmpty) return;

    final makeFavorite = !assets.every((e) => e.isFavorite);

    for (final asset in assets) {
      await PhotoManager.plugin.favoriteAsset(
        asset.id,
        makeFavorite,
      );
    }

    await fetchAssets();
  }

  // Multi Selection
  Future<void> deleteSelected() async {
    await _deleteAssets(_selectedAssets.toList());
    clearSelection();
  }

  Future<void> shareSelected() async {
    await _shareAssets(_selectedAssets.toList());
  }

  Future<void> toggleFavoriteSelected() async {
    await _toggleFavoriteAssets(_selectedAssets.toList());
    clearSelection();
  }

  // Single Asset
  Future<void> deleteAsset(AssetEntity asset) async {
    await _deleteAssets([asset]);
  }

  Future<void> shareAsset(AssetEntity asset) async {
    await _shareAssets([asset]);
  }

  Future<void> toggleFavoriteAsset(AssetEntity asset) async {
    await _toggleFavoriteAssets([asset]);
  }

  // Gallery Listener
  void onGalleryChanged(MethodCall call) {
    fetchAssets();
  }

  void startListening() {
    if (_isListening) return;

    PhotoManager.addChangeCallback(onGalleryChanged);
    PhotoManager.startChangeNotify();

    _isListening = true;
  }

  void stopListening() {
    if (!_isListening) return;

    PhotoManager.removeChangeCallback(onGalleryChanged);
    PhotoManager.stopChangeNotify();

    _isListening = false;
  }

  @override
  void dispose() {
    stopListening();
    scrollController.dispose();
    super.dispose();
  }
}