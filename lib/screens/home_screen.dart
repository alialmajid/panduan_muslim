import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tata_cara_screen.dart';
import 'list_surat_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surat_model.dart';
import 'detail_surat_screen.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        toolbarHeight: 0, // Hide appbar but keep safe area color
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assalamu\'alaikum,',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hamba Allah',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Section Terakhir Dibaca
              if (_lastReadSurat != null) ...[
                Text(
                  'Terakhir Dibaca',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailSuratScreen(suratModel: _lastReadSurat!),
                      ),
                    ).then((_) => _loadLastRead()); // Reload when coming back
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.menu_book_rounded, color: Colors.teal[700], size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _lastReadSurat!.namaLatin,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal[900],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ayat 1 • ${_lastReadSurat!.arti}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // Kartu Info (Hadits/Quote) - Solid Enterprise Style
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.teal[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Hadits Hari Ini',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '"Barangsiapa menempuh jalan untuk menuntut ilmu, maka Allah akan mudahkan baginya jalan menuju surga."\n(HR. Muslim)',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Menu Utama',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context,
                      title: 'Tata Cara\nSholat',
                      icon: Icons.mosque_rounded,
                      iconColor: Colors.teal[700]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TataCaraScreen()),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: 'Al-Quran\nDigital',
                      icon: Icons.menu_book_rounded,
                      iconColor: Colors.teal[700]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListSuratScreen()),
                        ).then((_) => _loadLastRead());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
