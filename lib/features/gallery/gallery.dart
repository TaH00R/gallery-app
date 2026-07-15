import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/features/gallery/components/asset_thumbnail.dart';
import 'package:gallery/features/gallery/components/image_view.dart';
import 'package:gallery/features/gallery/components/video_view.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];

  final Set<AssetEntity> selectedAssets = {};

  bool selectionMode = false;

  Future<void> _fetchAssets() async {
    final result = await PhotoManager.getAssetListRange(
      start: 0,
      end: 1000000,
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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