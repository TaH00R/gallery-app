import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GalleryAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      foregroundColor: AppColors.appBarForeground,
      centerTitle: true,
      elevation: 0,
      // Center
      title: Text(
        title,
        style: GoogleFonts.boogaloo(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Stack(
    alignment: Alignment.center,
    children: [
      Positioned(
        left: 0,
        child: Image.asset("assets/images/branch.png", height: 150),
      ),
      Positioned(
        right: 0,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Image.asset("assets/images/branch.png", height: 150),
        ),
      ),
    ],
  ),
    );
  }
}