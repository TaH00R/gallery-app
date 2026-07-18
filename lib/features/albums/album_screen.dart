import 'package:flutter/material.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:gallery/features/albums/components/album_grid.dart';
import 'package:gallery/features/albums/components/album_search_bar.dart';
import 'package:gallery/shared/widgets/appbar.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(title: 'ALBUMS'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: AlbumSearchBar(),
            ),
            const SizedBox(height: 16),
            const Expanded(child: AlbumGrid()),
          ],
        ),
      ),
    );
  }
}


