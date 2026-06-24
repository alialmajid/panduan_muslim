import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          _buildSectionTitle('Informasi Aplikasi', isDark),
          _buildMenuTile(
            context,
            title: 'Privacy Policy',
            icon: Remix.shield_keyhole_line,
            onTap: () => _showContentDialog(
              context,
              'Privacy Policy',
              'Kebijakan Privasi Aplikasi Panduan Muslim:\n\n1. Aplikasi ini membutuhkan akses lokasi (GPS) untuk menghitung arah kompas Kiblat dan jadwal sholat secara akurat.\n2. Data lokasi Anda dihitung secara lokal di dalam perangkat dan tidak pernah dikirimkan atau disimpan di server kami.\n3. Aplikasi ini tidak mengumpulkan data pribadi apa pun.\n\nDengan menggunakan aplikasi ini, Anda setuju dengan ketentuan privasi yang ditetapkan.',
            ),
          ),
          _buildMenuTile(
            context,
            title: 'Syarat dan Ketentuan',
            icon: Remix.article_line,
            onTap: () => _showContentDialog(
              context,
              'Syarat & Ketentuan',
              'Syarat dan Ketentuan Penggunaan:\n\n1. Aplikasi ini disediakan "sebagaimana adanya" untuk membantu umat Muslim dalam ibadah harian.\n2. Jadwal sholat dan arah kiblat dihitung secara astronomis dan disesuaikan dengan standar Kemenag RI, namun pengguna disarankan untuk tetap melakukan verifikasi mandiri.\n3. Hak cipta data Al-Quran bersumber dari API publik dan data lokal yang bersifat terbuka.\n\nTerima kasih telah menggunakan aplikasi ini.',
            ),
          ),
          _buildMenuTile(
            context,
            title: 'Tentang Aplikasi',
            icon: Remix.information_line,
            onTap: () => _showAboutDialog(context),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Tampilan', isDark),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, _) {
              return _buildThemeSelector(context, currentMode);
            },
          ),
          _buildSectionTitle('Lainnya', isDark),
          _buildMenuTile(
            context,
            title: 'Beri Rating',
            icon: Remix.star_line,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur segera hadir!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeMode currentMode) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: const Icon(Remix.palette_line, color: AppColors.primary),
        title: Text(
          'Tema Aplikasi',
          style: GoogleFonts.elMessiri(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        trailing: PopupMenuButton<ThemeMode>(
          initialValue: currentMode,
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onSelected: (ThemeMode newMode) async {
            themeNotifier.value = newMode;
            final prefs = await SharedPreferences.getInstance();
            if (newMode == ThemeMode.dark) {
              prefs.setString('theme_mode', 'dark');
            } else if (newMode == ThemeMode.light) {
              prefs.setString('theme_mode', 'light');
            } else {
              prefs.setString('theme_mode', 'system');
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.system, 
              child: Text('Default Sistem', style: GoogleFonts.elMessiri(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ),
            PopupMenuItem(
              value: ThemeMode.light, 
              child: Text('Terang', style: GoogleFonts.elMessiri(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ),
            PopupMenuItem(
              value: ThemeMode.dark, 
              child: Text('Gelap', style: GoogleFonts.elMessiri(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentMode == ThemeMode.dark 
                    ? 'Gelap' 
                    : currentMode == ThemeMode.light 
                        ? 'Terang' 
                        : 'Default Sistem',
                style: GoogleFonts.elMessiri(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Remix.arrow_down_s_line, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: GoogleFonts.elMessiri(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: GoogleFonts.elMessiri(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        trailing: Icon(Remix.arrow_right_s_line, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Image.asset('assets/logo.png', width: 40, height: 40, errorBuilder: (context, error, stackTrace) => const Icon(Remix.book_read_fill, color: AppColors.primary, size: 40)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Panduan Muslim',
                  style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          content: Text(
            'Versi 1.0.0\n\nAplikasi komprehensif untuk mendampingi ibadah harian Anda. Menyediakan Al-Quran, Jadwal Sholat, Arah Kiblat, dan Panduan Ibadah secara offline.',
            style: GoogleFonts.elMessiri(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup', style: GoogleFonts.elMessiri(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showContentDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            title,
            style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: GoogleFonts.elMessiri(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup', style: GoogleFonts.elMessiri(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
