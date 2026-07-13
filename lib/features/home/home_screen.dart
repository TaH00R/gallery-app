import 'package:flutter/material.dart';
import 'package:gallery/features/about/about_screen.dart';
import 'package:gallery/shared/widgets/appbar.dart';
import 'package:gallery/shared/widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<String> titles = [
    'ABOUT',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(title: titles[selectedIndex]),
      ),
  body: IndexedStack(
    index: selectedIndex,
    children: const [
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