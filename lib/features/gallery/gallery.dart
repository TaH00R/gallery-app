import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:gallery/features/gallery/components/asset_thumbnail.dart';
import 'package:gallery/features/gallery/components/gallery_viewer.dart';
import 'package:gallery/shared/widgets/appbar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class Gallery extends StatefulWidget {
  final AssetPathEntity? album;
  const Gallery({super.key, this.album});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];
  bool _isDeleting = false;
  final Set<AssetEntity> selectedAssets = {};
  bool selectionMode = false;

  Future<void> _fetchAssets() async {
    List<AssetEntity> result;

    if (widget.album == null) {
      result = await PhotoManager.getAssetListRange(start: 0, end: 1000000);
    } else {
      result = await widget.album!.getAssetListPaged(page: 0, size: 200);
    }

    if (!mounted) return;

    setState(() {
      assets = result;
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

  Future<void> _moveSelected() async {
    // TODO
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

    final photos = assets.where((a) => a.type == AssetType.image).length;

    final videos = assets.where((a) => a.type == AssetType.video).length;
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
          onMove: _moveSelected,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: GestureDetector(
          // onPanStart:
          // onPanUpdate:
          // onPanEnd:
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
                child: Text(
                      "$photos Photos • $videos Videos",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              ),

              ...days.map((entry) {
                final date = entry.key;
                final dayAssets = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "${formatDate(date).toUpperCase()} (${dayAssets.length})",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
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
                                assets.indexWhere((a) => a.id == asset.id),
                              );
                            }
                          },

                          onLongPress: () {
                            _startSelection(asset);
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
