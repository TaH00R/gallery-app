import 'package:flutter/material.dart';
import 'package:gallery/features/albums/album_provider.dart';
import 'package:provider/provider.dart';

class AlbumSearchBar extends StatelessWidget {
  const AlbumSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              context.read<AlbumProvider>().search(value);
            },
            decoration: InputDecoration(
              hintText: "Search albums...",
              prefixIcon: const Icon(Icons.search, color: Colors.deepOrangeAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.deepOrangeAccent,
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        PopupMenuButton<AlbumSort>(
          icon: const Icon(Icons.sort_by_alpha_rounded, color: Colors.deepOrangeAccent),
          onSelected: (sort) {
            context.read<AlbumProvider>().sort(sort);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: AlbumSort.az,
              child: Text("A → Z"),
            ),
            PopupMenuItem(
              value: AlbumSort.za,
              child: Text("Z → A"),
            ),
          ],
        ),
      ],
    );
  }
}