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
      title: Text(title,
      style: GoogleFonts.graduate(
        fontWeight: FontWeight.w600,
        fontSize: 25,)
       ),
      centerTitle: true,
    );
  }
}