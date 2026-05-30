import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surat_model.dart';
import '../services/api_service.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Al-Quran Digital',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.teal[900]),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal[900],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama surat atau arti...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal[600]!, width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SuratModel>>(
              future: futureSurat,
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
                  final List<SuratModel> suratList = snapshot.data!.where((surat) {
                    return surat.namaLatin.toLowerCase().contains(_searchQuery) ||
                           surat.arti.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (suratList.isEmpty) {
                    return Center(
                      child: Text(
                        'Surat tidak ditemukan.',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: suratList.length,
              itemBuilder: (context, index) {
                final surat = suratList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1.5),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailSuratScreen(suratModel: surat),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Nomor Surat dengan hiasan
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  surat.nomor.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Info Surat
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surat.namaLatin,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${surat.tempatTurun} • ${surat.jumlahAyat} Ayat',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
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
                                color: Colors.teal[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
                  } else {
                    return const Center(child: Text('Tidak ada data surat.'));
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }
