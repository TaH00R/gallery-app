import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatefulWidget {
  final AssetEntity asset;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AssetThumbnail({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  late final Future<Uint8List> _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture =
        widget.asset.thumbnailData.then((value) => value!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                ),
              ),

              if (widget.isSelected)
                Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                  ),
                ),

              if (widget.asset.type == AssetType.video)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    color: Colors.black54,
                    child: const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              if (widget.isSelected)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.brown,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}