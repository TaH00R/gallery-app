import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/features/gallery/components/asset_thumbnail.dart';
import 'package:gallery/features/gallery/components/image_view.dart';
import 'package:gallery/features/gallery/components/video_view.dart';
import 'package:gallery/shared/widgets/appbar.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];
  bool _isDeleting = false;
  final Set<AssetEntity> selectedAssets = {};
  bool selectionMode = false;

  Future<void> _fetchAssets() async {
    final result = await PhotoManager.getAssetListRange(start: 0, end: 1000000);
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

  void _openAsset(AssetEntity asset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          if (asset.type == AssetType.video) {
            return VideoView(videoFile: asset.file);
          }

          return ImageView(imageFile: asset.file);
        },
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

  Future<void> _shareSelected() async {
    // TODO
  }

  Future<void> _moveSelected() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(
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
          onShare: _shareSelected,
          onMove: _moveSelected,
        ),
      ),

      body: GestureDetector(
        // onPanStart:
        // onPanUpdate:
        // onPanEnd:
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: assets.length,
          itemBuilder: (_, index) {
            final asset = assets[index];

            return AssetThumbnail(
              key: ValueKey(asset.id),
              asset: asset,
              isSelected: selectedAssets.contains(asset),
              
              onTap: () {
                if (selectionMode) {
                  _toggleSelection(asset);
                } else {
                  _openAsset(asset);
                }
              },

              onLongPress: () {
                _startSelection(asset);
              },
            );
          },
        ),
      ),
    );
  }
}
