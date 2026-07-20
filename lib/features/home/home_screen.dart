import 'package:flutter/material.dart';
import 'package:gallery/features/about/about_screen.dart';
import 'package:gallery/features/albums/screens/album_screen.dart';
import 'package:gallery/features/gallery/gallery_provider.dart';
import 'package:gallery/features/gallery/screens/gallery.dart';
import 'package:gallery/shared/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: IndexedStack(
    index: selectedIndex,
    children: [
      ChangeNotifierProvider(
      create: (_) => GalleryProvider(),
      child: const Gallery(),
    ),
      AlbumScreen(),
      AboutScreen(),
        ],
  ),
  bottomNavigationBar: GalleryBottomNavBar(
    selectedIndex: selectedIndex,
    onTap: (index) {
      setState(() {
        selectedIndex = index;
      });
    },
  ),
);
  }
}