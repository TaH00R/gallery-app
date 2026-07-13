import 'package:flutter/material.dart';
import 'package:gallery/features/albums/album_provider.dart';
import 'package:gallery/features/albums/components/album_tile.dart';
import 'package:provider/provider.dart';

class AlbumGrid extends StatefulWidget {
  const AlbumGrid({super.key});

  @override
  State<AlbumGrid> createState() => _AlbumGridState();
}

class _AlbumGridState extends State<AlbumGrid> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<AlbumProvider>().loadAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlbumProvider>();

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.albums.isEmpty) {
      return const Center(
        child: Text("No albums found"),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.albums.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return AlbumTile(provider.albums[index]);
      },
    );
  }
}