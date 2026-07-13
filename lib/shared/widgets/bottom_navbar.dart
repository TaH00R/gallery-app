import 'package:flutter/material.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const GalleryBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            alignment: switch (selectedIndex) {
  0 => const Alignment(-0.67, 0),
  1 => const Alignment(0.0, 0),
  _ => const Alignment(0.67, 0),
},
            child: Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.bottomNavBarForeground,
                      AppColors.bottomNavBarForeground,
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.bottomNavBarBackground,
                    width: 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.bottomNavBarForeground.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  selectedIndex == 0
                      ? Icons.map_rounded
                      : Icons.photo_library_rounded,
                  color: Colors.brown,
                  size: 25,
                ),
              ),
            ),
          ),

          Row(
            children: [
              _NavButton(
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                index: 0,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              _NavButton(
                icon: Icons.photo_album_rounded,
                label: 'Albums',
                index: 1,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              _NavButton(
                icon: Icons.question_mark_outlined,
                label: 'About',
                index: 2,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: SizedBox(
          height: 68,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1 : 0.45,
                child: Column(
                  children: [
                    if (!isSelected) ...[
                      const SizedBox(height: 15),
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                    ] else ...[
                      const SizedBox(height: 43),
                    ],
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}