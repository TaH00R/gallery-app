import 'package:flutter/material.dart';
import 'package:gallery/features/gallery/components/image_view.dart';
import 'package:gallery/features/gallery/components/video_view.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryViewer extends StatefulWidget {
  final List<AssetEntity> assets;
  final int initialIndex;

  const GalleryViewer({
    super.key,
    required this.assets,
    required this.initialIndex,
  });

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.assets.length,
        itemBuilder: (_, index) {
          final asset = widget.assets[index];

          if (asset.type == AssetType.video) {
            return VideoView(asset: asset);
          }

          return ImageView(asset: asset);
        },
      ),
    );
  }
}