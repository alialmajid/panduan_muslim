import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surat_model.dart';
import '../theme/colors.dart';
import 'detail_surat_screen.dart';
import 'list_surat_screen.dart';
import 'tata_cara_screen.dart';
import 'qibla_screen.dart';
import 'jadwal_sholat_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SuratModel? _lastReadSurat;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? suratJson = prefs.getString('last_read_surat');
      if (suratJson != null) {
        setState(() {
          _lastReadSurat = SuratModel.fromJson(jsonDecode(suratJson));
        });
      }
    } catch (e) {
      debugPrint('Error loading last read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  if (_lastReadSurat != null) _buildLastReadCard(isDark).animate().fade().slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'Menu Utama',
                    style: GoogleFonts.elMessiri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ).animate().fade().slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 16),
                  _buildMenuGrid(isDark),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
      actions: [
        IconButton(
          icon: const Icon(Remix.settings_4_line, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Pattern Placeholder (Or you can use existing image if preferred)
            // SvgPicture.asset('assets/images/islamic_pattern.svg', fit: BoxFit.cover),
            Image.asset(
              'assets/images/bg.jpg', 
              fit: BoxFit.cover,
              color: isDark ? Colors.black.withOpacity(0.6) : AppColors.primary.withOpacity(0.8),
              colorBlendMode: BlendMode.srcOver,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Remix.sun_cloudy_line, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Builder(
                        builder: (context) {
                          final today = HijriCalendar.now();
                          const hijriMonths = [
                            'Muharram', 'Safar', 'Rabiul Awal', 'Rabiul Akhir', 
                            'Jumadil Awal', 'Jumadil Akhir', 'Rajab', 'Sya\'ban', 
                            'Ramadhan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
                          ];
                          final monthName = hijriMonths[today.hMonth - 1];
                          final hijriString = '${today.hDay} $monthName ${today.hYear} H';
                          
                          return Text(
                            hijriString,
                            style: GoogleFonts.elMessiri(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      ),
                    ],
                  ).animate().fade(delay: 200.ms).slideX(),
                  const SizedBox(height: 8),
                  Text(
                    'Assalamu\'alaikum,\nHamba Allah',
                    style: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate().fade(delay: 300.ms).slideY(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastReadCard(bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSuratScreen(suratModel: _lastReadSurat!),
          ),
        ).then((_) => _loadLastRead());
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : AppColors.primary.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Remix.book_read_line, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terakhir Dibaca',
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _lastReadSurat!.namaLatin,
                    style: GoogleFonts.elMessiri(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ayat 1 • ${_lastReadSurat!.arti}',
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Remix.arrow_right_s_line, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(bool isDark) {
    final menus = [
      {
        'title': 'Al-Quran',
        'icon': 'assets/icons/quran.svg',
        'color': AppColors.primary,
        'route': const ListSuratScreen(),
      },
      {
        'title': 'Tata Cara\nSholat',
        'icon': 'assets/icons/praying.svg',
        'color': AppColors.accentGold,
        'route': const TataCaraScreen(),
      },
      {
        'title': 'Jadwal\nSholat',
        'icon': 'assets/icons/clock.svg',
        'color': const Color(0xFF3B82F6), // Blue
        'route': const JadwalSholatScreen(),
      },
      {
        'title': 'Kiblat',
        'icon': 'assets/icons/qibla.svg',
        'color': const Color(0xFF8B5CF6), // Purple
        'route': const QiblaScreen(),
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return _buildMenuCard(
          isDark,
          title: menu['title'] as String,
          iconPath: menu['icon'] as String,
          color: menu['color'] as Color,
          onTap: () {
            if (menu['route'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => menu['route'] as Widget),
              ).then((_) {
                if (menu['title'] == 'Al-Quran') {
                  _loadLastRead();
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur akan segera hadir')),
              );
            }
          },
        ).animate().fade(delay: (200 + (index * 100)).ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildMenuCard(bool isDark, {
    required String title,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : color.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                placeholderBuilder: (context) => Icon(Remix.image_line, size: 32, color: color), // Placeholder if SVG not found
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
