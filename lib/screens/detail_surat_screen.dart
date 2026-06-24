import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/surat_model.dart';
import '../models/ayat_model.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';

class DetailSuratScreen extends StatefulWidget {
  final SuratModel suratModel;

  const DetailSuratScreen({Key? key, required this.suratModel}) : super(key: key);

  @override
  _DetailSuratScreenState createState() => _DetailSuratScreenState();
}

class _DetailSuratScreenState extends State<DetailSuratScreen> {
  final ApiService apiService = ApiService();
  late Future<List<AyatModel>> futureAyat;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;
  
  String _selectedQari = '05';
  final Map<String, String> _qariNames = {
    '01': 'Abdullah Al-Juhany',
    '02': 'Abdul Muhsin',
    '03': 'Abdurrahman Sudais',
    '04': 'Ibrahim Al-Dossari',
    '05': 'Misyari Rasyid',
    '06': 'Yasser Al-Dosari',
  };

  @override
  void initState() {
    super.initState();
    futureAyat = apiService.getDetailSurat(widget.suratModel.nomor);
    _saveLastRead();
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
    
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentlyPlayingUrl = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _saveLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String suratJson = jsonEncode(widget.suratModel.toJson());
      await prefs.setString('last_read_surat', suratJson);
    } catch (e) {
      debugPrint('Error saving last read: $e');
    }
  }

  Future<void> _playAudio(String url) async {
    // Cek koneksi internet terlebih dahulu
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        _showNoInternetPopup();
        return;
      }
    } catch (_) {
      _showNoInternetPopup();
      return;
    }

    if (_currentlyPlayingUrl == url && _isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        await _audioPlayer.play(UrlSource(url));
        setState(() {
          _currentlyPlayingUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memutar audio. Pastikan koneksi internet Anda stabil.')),
        );
      }
    }
  }

  void _showNoInternetPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Remix.wifi_off_line, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Tidak Ada Koneksi',
              style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Memutar audio murottal membutuhkan koneksi internet aktif. Al-Qur\'an tetap bisa dibaca secara offline.',
          style: GoogleFonts.elMessiri(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.suratModel.namaLatin,
              style: GoogleFonts.elMessiri(
                fontWeight: FontWeight.bold, 
                fontSize: 18, 
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              '${widget.suratModel.arti} • ${widget.suratModel.jumlahAyat} Ayat',
              style: GoogleFonts.elMessiri(
                fontSize: 12, 
                fontWeight: FontWeight.normal, 
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Remix.arrow_left_s_line, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.suratModel.audioFull.isNotEmpty)
            IconButton(
              icon: Icon(
                _currentlyPlayingUrl == widget.suratModel.audioFull[_selectedQari] && _isPlaying 
                    ? Remix.pause_circle_fill
                    : Remix.play_circle_fill,
                size: 28,
                color: AppColors.primary,
              ),
              onPressed: () {
                final audioUrl = widget.suratModel.audioFull[_selectedQari];
                if (audioUrl != null && audioUrl.isNotEmpty) {
                  _playAudio(audioUrl);
                }
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header Qari Selection
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.textSecondaryDark.withOpacity(0.1) : AppColors.textSecondaryLight.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Remix.mic_line, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Qari:',
                  style: GoogleFonts.elMessiri(
                    fontWeight: FontWeight.w600, 
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedQari,
                        isExpanded: true,
                        dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        icon: Icon(Remix.arrow_down_s_line, color: AppColors.primary),
                        style: GoogleFonts.elMessiri(
                          color: AppColors.primary, 
                          fontWeight: FontWeight.bold,
                        ),
                        items: _qariNames.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedQari = value;
                            });
                            if (_isPlaying) {
                              _audioPlayer.stop();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AyatModel>>(
              future: futureAyat,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                } else if (snapshot.hasError) {
                  return Center(
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
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final List<AyatModel> ayatList = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                    itemCount: ayatList.length + 1, // +1 for Bismillah header
                    itemBuilder: (context, index) {
                      // Header Bismillah
                      if (index == 0) {
                        if (widget.suratModel.nomor == 9) return const SizedBox.shrink();
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                              style: GoogleFonts.amiri(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ).animate().fade().slideY(begin: 0.2);
                      }

                      final ayat = ayatList[index - 1];
                      
                      return Container(
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
                            // Header Ayat (Nomor & Menu)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${ayat.nomorAyat}',
                                      style: GoogleFonts.elMessiri(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Remix.share_forward_line, color: AppColors.primary, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Remix.bookmark_line, color: AppColors.primary, size: 20),
                                      onPressed: () {},
                                    ),
                                    if (ayat.audioAyat.containsKey(_selectedQari) && ayat.audioAyat[_selectedQari]!.isNotEmpty)
                                      IconButton(
                                        icon: Icon(
                                          _currentlyPlayingUrl == ayat.audioAyat[_selectedQari] && _isPlaying 
                                              ? Remix.pause_circle_fill 
                                              : Remix.play_circle_fill,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                        onPressed: () => _playAudio(ayat.audioAyat[_selectedQari]!),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Teks Arab
                            Text(
                              ayat.teksArab,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.amiri(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                height: 2.2,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Teks Latin
                            Text(
                              ayat.teksLatin,
                              style: GoogleFonts.elMessiri(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Teks Indonesia
                            Text(
                              ayat.teksIndonesia,
                              style: GoogleFonts.elMessiri(
                                fontSize: 14,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(delay: (50 * (index % 10)).ms).slideX(begin: 0.1, end: 0);
                    },
                  );
                } else {
                  return const Center(child: Text('Tidak ada ayat.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
