import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/surat_model.dart';
import '../models/ayat_model.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (_currentlyPlayingUrl == url && _isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentlyPlayingUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.suratModel.namaLatin,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal[900]),
            ),
            Text(
              '${widget.suratModel.arti} • ${widget.suratModel.jumlahAyat} Ayat',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal[900],
        elevation: 0,
        centerTitle: false,
        actions: [
          if (widget.suratModel.audioFull.isNotEmpty)
            IconButton(
              icon: Icon(
                _currentlyPlayingUrl == widget.suratModel.audioFull[_selectedQari] && _isPlaying 
                    ? Icons.pause_circle_filled 
                    : Icons.play_circle_filled,
                size: 32,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Icon(Icons.record_voice_over_rounded, color: Colors.teal[600], size: 20),
                const SizedBox(width: 12),
                Text(
                  'Qari:',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedQari,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.teal[700]),
                        style: GoogleFonts.poppins(color: Colors.teal[800], fontWeight: FontWeight.w500),
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
                            // Stop playing audio if Qari is changed
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
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    'Koneksi Terputus',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Pastikan internet Anda aktif untuk memuat ayat Al-Quran.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<AyatModel> ayatList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              itemCount: ayatList.length + 1, // +1 untuk header bismillah
              itemBuilder: (context, index) {
                // Header Bismillah
                if (index == 0) {
                  // Surat At-Tawbah (Surat ke-9) tidak diawali Bismillah secara khusus
                  if (widget.suratModel.nomor == 9) return const SizedBox.shrink();
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.teal[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                        style: GoogleFonts.amiri(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }

                // Index ayat asli (-1 karena index 0 untuk header)
                final ayat = ayatList[index - 1];
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Ayat (Nomor & Menu)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Ayat ${ayat.nomorAyat}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (ayat.audioAyat.containsKey(_selectedQari) && ayat.audioAyat[_selectedQari]!.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                _currentlyPlayingUrl == ayat.audioAyat[_selectedQari] && _isPlaying 
                                    ? Icons.pause_circle_filled 
                                    : Icons.play_circle_outline,
                                color: Colors.teal[600],
                                size: 28,
                              ),
                              onPressed: () => _playAudio(ayat.audioAyat[_selectedQari]!),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Teks Arab
                      Text(
                        ayat.teksArab,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                          height: 2.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Teks Latin
                      Text(
                        ayat.teksLatin,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.teal[700],
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Teks Indonesia
                      Text(
                        ayat.teksIndonesia,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
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
