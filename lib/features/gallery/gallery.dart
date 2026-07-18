import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:gallery/features/gallery/components/asset_thumbnail.dart';
import 'package:gallery/features/gallery/components/gallery_viewer.dart';
import 'package:gallery/shared/widgets/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class Gallery extends StatefulWidget {
  final AssetPathEntity? album;
  const Gallery({super.key, this.album});

  @override
  State<Gallery> createState() => _GalleryState();
}

enum SortMode { newest, oldest }

class _GalleryState extends State<Gallery> {
  final ScrollController _scrollController = ScrollController();
  List<AssetEntity> allAssets = [];
  List<AssetEntity> assets = [];
  bool _isDeleting = false;
  final Set<AssetEntity> selectedAssets = {};
  bool selectionMode = false;
  int selectedFilter = 0;
  SortMode sortMode = SortMode.newest;

  final filters = ["All", "Photos", "Videos", "Favorites"];

  Future<void> _fetchAssets() async {
    List<AssetEntity> result;

    if (widget.album == null) {
      result = await PhotoManager.getAssetListRange(start: 0, end: 1000000);
    } else {
      result = await widget.album!.getAssetListPaged(page: 0, size: 200);
    }

    if (!mounted) return;

    setState(() {
      allAssets = result;
      _applyFilter();
    });
  }

  void _applyFilter() {
    switch (selectedFilter) {
      case 0: // All
        assets = List.from(allAssets);
        break;

      case 1: // Photos
        assets = allAssets.where((a) => a.type == AssetType.image).toList();
        break;

      case 2: // Videos
        assets = allAssets.where((a) => a.type == AssetType.video).toList();
        break;

      case 3: // Favorites
        assets = allAssets.where((a) => a.isFavorite).toList();
        break;
    }
    assets.sort((a, b) {
      return sortMode == SortMode.newest
          ? b.createDateTime.compareTo(a.createDateTime)
          : a.createDateTime.compareTo(b.createDateTime);
    });
  }

  void _toggleSort() {
    setState(() {
      sortMode = sortMode == SortMode.newest
          ? SortMode.oldest
          : SortMode.newest;

      _applyFilter();
    });
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (selectedAssets.contains(asset)) {
        selectedAssets.remove(asset);

        if (selectedAssets.isEmpty) {
          selectionMode = false;
        }
      } else {
        selectedAssets.add(asset);
      }
    });
  }

  void _startSelection(AssetEntity asset) {
    setState(() {
      selectionMode = true;
      selectedAssets.add(asset);
    });
  }

  void _openAsset(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GalleryViewer(assets: assets, initialIndex: index),
      ),
    );
  }

  void _onGalleryChanged(MethodCall call) {
    _fetchAssets();
  }

  @override
  void initState() {
    super.initState();

    _fetchAssets();

    PhotoManager.addChangeCallback(_onGalleryChanged);
    PhotoManager.startChangeNotify();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    PhotoManager.removeChangeCallback(_onGalleryChanged);
    PhotoManager.stopChangeNotify();

    super.dispose();
  }

  Future<void> _deleteSelected() async {
    if (_isDeleting || selectedAssets.isEmpty) return;

    final ids = selectedAssets.map((e) => e.id).toList();

    setState(() {
      _isDeleting = true;
    });

    try {
      final deletedIds = await PhotoManager.editor.deleteWithIds(ids);

      if (!mounted) return;

      if (deletedIds.isNotEmpty) {
        setState(() {
          assets.removeWhere((asset) => deletedIds.contains(asset.id));
          selectedAssets.clear();
          selectionMode = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> shareAssets(List<AssetEntity> assets) async {
    final files = <XFile>[];

    for (final asset in assets) {
      final file = await asset.originFile;
      if (file != null) {
        files.add(XFile(file.path));
      }
    }

    if (files.isEmpty) return;

    await SharePlus.instance.share(ShareParams(files: files));
  }

  Future<void> _toggleFavoriteSelected() async {
    if (selectedAssets.isEmpty) return;

    final makeFavorite = !selectedAssets.every((e) => e.isFavorite);

    for (final asset in selectedAssets) {
      await PhotoManager.plugin.favoriteAsset(asset.id, makeFavorite);
    }

    await _fetchAssets();

    if (!mounted) return;

    setState(() {
      selectedAssets.clear();
      selectionMode = false;
    });
  }

  Map<DateTime, List<AssetEntity>> _groupAssetsByDay() {
    final Map<DateTime, List<AssetEntity>> grouped = {};

    for (final asset in assets) {
      final date = asset.createDateTime;

      final key = DateTime(date.year, date.month, date.day);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(asset);
    }

    return grouped;
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = today.difference(target).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    if (diff < 7) return DateFormat('EEEE').format(date);

    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final groupedAssets = _groupAssetsByDay();
    final days = groupedAssets.entries.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(
          title: widget.album?.name ?? "GALLERY",
          selectionMode: selectionMode,
          selectedCount: selectedAssets.length,

          onCloseSelection: () {
            setState(() {
              selectionMode = false;
              selectedAssets.clear();
            });
          },

          isDeleting: _isDeleting,
          onDelete: _deleteSelected,
          onShare: () => shareAssets(selectedAssets.toList()),
          onFavorite: _toggleFavoriteSelected,
          isFavorite:
              selectedAssets.isNotEmpty &&
              selectedAssets.every((e) => e.isFavorite),
        ),
      ),

      body: GestureDetector(
        // onPanStart:
        // onPanUpdate:
        // onPanEnd:
        child: DraggableScrollbar.semicircle(
          backgroundColor: AppColors.primary,
          heightScrollThumb: 48.0,
          controller: _scrollController,
          child: ListView(
            scrollCacheExtent: ScrollCacheExtent.pixels(1000),
            controller: _scrollController,
            children: [
              //Padding for the filter chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _toggleSort,
                        icon: Icon(
                          sortMode == SortMode.newest
                              ? Icons.arrow_circle_down_outlined
                              : Icons.arrow_circle_up_outlined,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      _chip(icon: Icons.apps, text: "All", index: 0),
                      const SizedBox(width: 8),
                      _chip(icon: Icons.image_outlined, text: "IMG", index: 1),
                      const SizedBox(width: 8),
                      _chip(
                        icon: Icons.videocam_outlined,
                        text: "VID",
                        index: 2,
                      ),
                      const SizedBox(width: 8),
                      _chip(icon: Icons.favorite_border, text: "FAV", index: 3),
                    ],
                  ),
                ),
              ),

              ...days.map((entry) {
                final date = entry.key;
                final dayAssets = entry.value;

                //Padding and container for each day with a grid of assets
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 4.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFFE7D8C8)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 8),
                          color: Colors.black.withOpacity(.05),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding for the date and item count
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.grass_outlined,
                                size: 20,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formatDate(date),
                                style: GoogleFonts.saira(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),

                              const Spacer(),

                              Text(
                                "${dayAssets.length} items",
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Grid of assets for the day
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            bottom: 5.0,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),

                            itemCount: dayAssets.length,

                            itemBuilder: (_, index) {
                              final asset = dayAssets[index];

                              return AssetThumbnail(
                                key: ValueKey(asset.id),
                                asset: asset,
                                isSelected: selectedAssets.contains(asset),

                                onTap: () {
                                  if (selectionMode) {
                                    _toggleSelection(asset);
                                  } else {
                                    _openAsset(
                                      assets.indexWhere(
                                        (a) => a.id == asset.id,
                                      ),
                                    );
                                  }
                                },

                                onLongPress: () {
                                  _startSelection(asset);
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String text,
    required int index,
  }) {
    final selected = selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
          _applyFilter();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: .06),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
