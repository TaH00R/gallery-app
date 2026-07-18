import 'package:flutter/material.dart';
import 'package:gallery/features/home/home_screen.dart';
import 'package:photo_manager/photo_manager.dart';


class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Future<void> _request(BuildContext context) async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (permission.hasAccess) {
      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    if (permission.isAuth) return;

    PhotoManager.openSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.photo_library_rounded,
                  size: 90,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Allow Photo Access",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Gallery needs permission to access your photos and videos.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.orange.shade700,
                  ),
                  onPressed: () => _request(context),
                  child: const Text("Grant Permission"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}