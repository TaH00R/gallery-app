import 'package:flutter/material.dart';
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
      assets = await PhotoManager.getAssetListRange(
        start : 0,
        end : 1000000,
      );
      setState(() {});
    }

    @override
    initState() {
      super.initState();
      _fetchAssets();
    }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: assets.length,
          itemBuilder: (_, index){
            return AssetThumbnail(asset: assets[index]);
          }),
    );
  }
}