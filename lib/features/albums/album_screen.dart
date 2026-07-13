import 'package:flutter/material.dart';
import 'package:gallery/features/albums/components/album_grid.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AlbumGrid(),
      ),
    );
  }
}