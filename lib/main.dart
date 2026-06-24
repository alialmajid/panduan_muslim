import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

// Global notifier for theme
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Mengizinkan runtime fetching agar font google dapat didownload
  GoogleFonts.config.allowRuntimeFetching = true;
  
  // Inisialisasi format tanggal untuk bahasa Indonesia
  await initializeDateFormatting('id_ID', null);
  
  // Load saved theme
  final prefs = await SharedPreferences.getInstance();
  final themeStr = prefs.getString('theme_mode') ?? 'system';
  if (themeStr == 'dark') {
    themeNotifier.value = ThemeMode.dark;
  } else if (themeStr == 'light') {
    themeNotifier.value = ThemeMode.light;
  } else {
    themeNotifier.value = ThemeMode.system;
  }
  
  runApp(const PanduanMuslimApp());
}

class PanduanMuslimApp extends StatelessWidget {
  const PanduanMuslimApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Panduan Sholat & Al-Quran',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
