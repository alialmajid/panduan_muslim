import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/surat_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import 'detail_surat_screen.dart';

class ListSuratScreen extends StatefulWidget {
  const ListSuratScreen({Key? key}) : super(key: key);

  @override
  _ListSuratScreenState createState() => _ListSuratScreenState();
}

class _ListSuratScreenState extends State<ListSuratScreen> {
  final ApiService apiService = ApiService();
  late Future<List<SuratModel>> futureSurat;
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureSurat = apiService.getAllSurat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.all(24.0),
              child: _buildSearchBar(isDark),
            ),
          ),
          FutureBuilder<List<SuratModel>>(
            future: futureSurat,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Remix.wifi_off_line, size: 64, color: AppColors.primary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'Koneksi Terputus',
                          style: GoogleFonts.elMessiri(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final List<SuratModel> suratList = snapshot.data!.where((surat) {
                  return surat.namaLatin.toLowerCase().contains(_searchQuery) ||
                         surat.arti.toLowerCase().contains(_searchQuery);
                }).toList();

                if (suratList.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Surat tidak ditemukan.',
                        style: GoogleFonts.elMessiri(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final surat = suratList[index];
                        return _buildSuratCard(context, surat, index, isDark);
                      },
                      childCount: suratList.length,
                    ),
                  ),
                );
              } else {
                return const SliverFillRemaining(
                  child: Center(child: Text('Tidak ada data surat.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Remix.arrow_left_s_line, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Text(
          'Al-Qur\'an',
          style: GoogleFonts.elMessiri(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return TextField(
      controller: _searchController,
      style: GoogleFonts.elMessiri(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        hintText: 'Cari surah atau terjemahan...',
        hintStyle: GoogleFonts.elMessiri(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        prefixIcon: Icon(Remix.search_line, color: AppColors.primary),
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.textSecondaryDark.withOpacity(0.1) : AppColors.textSecondaryLight.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
    );
  }

  Widget _buildSuratCard(BuildContext context, SuratModel surat, int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.03),
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
                builder: (context) => DetailSuratScreen(suratModel: surat),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Ornamen SVG dengan Nomor Surat
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/number_frame.svg',
                        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                        placeholderBuilder: (context) => Icon(Remix.hexagon_line, size: 48, color: AppColors.primary.withOpacity(0.5)),
                      ),
                      Text(
                        surat.nomor.toString(),
                        style: GoogleFonts.elMessiri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Info Surat Latin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surat.namaLatin,
                        style: GoogleFonts.elMessiri(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            surat.tempatTurun.toUpperCase(),
                            style: GoogleFonts.elMessiri(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            ' • ${surat.jumlahAyat} AYAT',
                            style: GoogleFonts.elMessiri(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Nama Arab
                Text(
                  surat.nama,
                  style: GoogleFonts.amiri(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    height: 1.5, // Mengatur agar harakat tidak terpotong
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(delay: (50 * (index % 10)).ms).slideX(begin: 0.1, end: 0);
  }
}
