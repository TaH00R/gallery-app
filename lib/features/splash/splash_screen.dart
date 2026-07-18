import 'package:flutter/material.dart';
import 'package:gallery/features/home/home_screen.dart';
import 'package:gallery/features/permissions/permission_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: .92,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final results = await Future.wait([
      PhotoManager.requestPermissionExtend(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    final permission = results[0] as PermissionState;

    if (!mounted) return;

    if (permission.hasAccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PermissionScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xffF8F2EA);
    const accent = Color(0xffC86B3C);
    const dark = Color(0xff4B3425);

    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFF8F1),
              Color(0xffF6E9DB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withValues(alpha: .12),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.photo_library_rounded,
                        size: 58,
                        color: accent,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: dark,
                        letterSpacing: -.8,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Your memories, beautifully organized.",
                      style: TextStyle(
                        color: Colors.brown.shade400,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 60),

                    const SizedBox(
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: accent,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.brown.shade400,
                        fontSize: 14,
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