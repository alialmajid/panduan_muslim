import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/sholat_data.dart';
import '../models/sholat_model.dart';
import '../theme/colors.dart';

class ListGerakanScreen extends StatelessWidget {
  final JenisSholatModel jenisSholat;

  const ListGerakanScreen({Key? key, required this.jenisSholat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SholatModel> tataCaraList = SholatData.getTataCara(jenisSholat);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Bacaan ${jenisSholat.nama}',
          style: GoogleFonts.elMessiri(
            fontWeight: FontWeight.bold, 
            fontSize: 16, 
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
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        itemCount: tataCaraList.length,
        itemBuilder: (context, index) {
          final item = tataCaraList[index];
          final isLast = index == tataCaraList.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timeline Line & Dot
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.elMessiri(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Card Content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.textSecondaryDark.withOpacity(0.1) : AppColors.textSecondaryLight.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nama Gerakan
                        Text(
                          item.name,
                          style: GoogleFonts.elMessiri(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Teks Arab
                        Text(
                          item.arabic,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            height: 2.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Teks Latin
                        Text(
                          item.latin,
                          style: GoogleFonts.elMessiri(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Terjemahan
                        Text(
                          item.translation,
                          style: GoogleFonts.elMessiri(
                            fontSize: 14,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fade(delay: (100 * index).ms).slideX(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }
}
