import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery/features/gallery/components/image_view.dart';
import 'package:gallery/features/gallery/components/video_view.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;
  const AssetThumbnail({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
      return FutureBuilder<Uint8List>(
        future: asset.thumbnailData.then((value) => value!),
        builder: (context, snapshot) {
          final bytes = snapshot.data;
          if (bytes == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return InkWell(
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                if(asset.type == AssetType.video){
                  return VideoView(videoFile :  asset.file);
                }
              return ImageView(imageFile :  asset.file);
            }));
              },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                  )),
            
                  if(asset.type == AssetType.video)
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
              ],
            ),
          );
        },
      );
  }
}