import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/features/gallery/components/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];

  Future<void> _fetchAssets() async {
    final result = await PhotoManager.getAssetListRange(start: 0, end: 1000000);
    setState(() {
      assets = result;
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchAssets();

    PhotoManager.addChangeCallback(_onGalleryChanged);
    PhotoManager.startChangeNotify();
  }

  void _onGalleryChanged(MethodCall call) {
    _fetchAssets();
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
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(asset: assets[index]);
        },
      ),
    );
  }
}
