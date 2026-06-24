import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/sholat_data.dart';
import '../models/sholat_model.dart';
import '../theme/colors.dart';
import 'list_gerakan_screen.dart';

class TataCaraScreen extends StatelessWidget {
  const TataCaraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<JenisSholatModel> semuaSholat = SholatData.getJenisSholat();
    final List<JenisSholatModel> sholatWajib = semuaSholat.where((s) => s.isWajib).toList();
    final List<JenisSholatModel> sholatSunnah = semuaSholat.where((s) => !s.isWajib).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            'Panduan Sholat',
            style: GoogleFonts.elMessiri(
              fontWeight: FontWeight.bold, 
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Remix.arrow_left_s_line, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            labelStyle: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.elMessiri(fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'Sholat Wajib'),
              Tab(text: 'Sholat Sunnah'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(sholatWajib, isDark),
            _buildList(sholatSunnah, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<JenisSholatModel> list, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.2) : AppColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListGerakanScreen(jenisSholat: item),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Remix.user_star_line, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nama,
                            style: GoogleFonts.elMessiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Panduan & niat lengkap',
                            style: GoogleFonts.elMessiri(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Remix.arrow_right_s_line, size: 20, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fade(delay: (50 * index).ms).slideX(begin: 0.1, end: 0);
      },
    );
  }
}
