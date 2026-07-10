import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gallery/shared/widgets/appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse(
      "https://github.com/TaH00R/gallery-app",
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch GitHub");
    }
  }

  Widget featureTile(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.brown.shade100,
        child: Icon(
          icon,
          color: Colors.brown.shade700,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GalleryAppBar(
        title: "ABOUT",
      ),
      backgroundColor: const Color(0xffF8F5F0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/svgs/camera.svg",
                    width: 90,
                    height: 90,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Memories. Organized.",
                    style: TextStyle(
                      color: Colors.brown.shade600,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "Gallery is a beautifully crafted photo and video manager built with Flutter. Organize your memories into albums, relive your favorite moments, and enjoy a clean, distraction-free experience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Chip(
                    backgroundColor: Colors.brown.shade100,
                    label: Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Features",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  featureTile(
                    Icons.folder_copy_outlined,
                    "Albums",
                    "Keep your memories neatly organized.",
                  ),
                  featureTile(
                    Icons.play_circle_outline,
                    "Video Playback",
                    "Play videos directly inside the app.",
                  ),
                  featureTile(
                    Icons.share_outlined,
                    "Share",
                    "Share photos and videos instantly.",
                  ),
                  featureTile(
                    Icons.edit_outlined,
                    "Edit",
                    "Open media in your favorite editor.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Open Source",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Gallery is completely open source. Feel free to explore the source code, report issues, or contribute to make it even better.",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _launchGitHub,
                      icon: const Icon(Icons.code),
                      label: const Text("View on GitHub"),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Made with Flutter",
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "© 2026 TaHooR",
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}