import 'package:flutter/material.dart';
import 'package:gallery/features/gallery/gallery_provider.dart';
import 'package:provider/provider.dart';

import 'package:gallery/app/app.dart';
import 'package:gallery/features/albums/album_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AlbumProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GalleryProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}