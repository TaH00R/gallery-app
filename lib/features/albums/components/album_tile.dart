import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumTile extends StatelessWidget {
  final AssetPathEntity album;

  const AlbumTile(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: album.assetCountAsync,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.photo_album_outlined,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  album.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text("$count items"),
              ],
            ),
          ),
        );
      },
    );
  }
}