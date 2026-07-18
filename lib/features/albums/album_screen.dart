import 'package:flutter/material.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:gallery/features/albums/components/album_grid.dart';
import 'package:gallery/shared/widgets/appbar.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(title: 'ALBUMS')
      ),
      body: SafeArea(
          child: AlbumGrid(),
      ),
    );
  }
}