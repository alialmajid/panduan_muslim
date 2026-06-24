import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_screen.dart';
import '../theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Tahan splash screen selama 2.5 detik
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Agar benar-benar di tengah
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika logo belum ada
                return Icon(
                  Icons.mosque,
                  size: 120,
                  color: AppColors.primary,
                );
              },
            ).animate().fade(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
            
            // Jarak yang dibuat "rapet"
            const SizedBox(height: 8),
            
            // Teks Aplikasi
            Text(
              'Panduan Muslim',
              style: GoogleFonts.elMessiri(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                height: 1.0, // Line height dirapatkan
              ),
            ).animate().fade(delay: 400.ms, duration: 800.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}
