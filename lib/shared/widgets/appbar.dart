import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool selectionMode;
  final bool isDeleting;
  final int selectedCount;

  final VoidCallback? onCloseSelection;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onMove;

  final String title;

  const GalleryAppBar({
    this.isDeleting = false,
    super.key,
    this.selectionMode = false,
    this.selectedCount = 0,
    this.onCloseSelection,
    this.onDelete,
    this.onShare,
    this.onMove,
    this.title = 'GALLERY',
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      foregroundColor: AppColors.appBarForeground,
      elevation: 0,
      centerTitle: !selectionMode,

      leading: selectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onCloseSelection,
            )
          : null,

      title: Text(
        selectionMode ? '$selectedCount SELECTED' : title,
        style: !selectionMode
            ? GoogleFonts.boogaloo(fontSize: 30, fontWeight: FontWeight.w600)
            : GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
      ),

     actions: selectionMode
    ? [
        IconButton(
          onPressed: isDeleting ? null : onShare,
          icon: const Icon(Icons.share),
        ),
        IconButton(
          onPressed: isDeleting ? null : onMove,
          icon: const Icon(Icons.drive_file_move),
        ),
        IconButton(
          onPressed: isDeleting ? null : onDelete,
          icon: isDeleting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.delete),
        ),
      ]
    : null,

      flexibleSpace: selectionMode
          ? null
          : Stack(
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
