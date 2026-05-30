import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surat_model.dart';
import '../models/ayat_model.dart';
import '../services/api_service.dart';

class DetailSuratScreen extends StatefulWidget {
  final SuratModel suratModel;

  const DetailSuratScreen({Key? key, required this.suratModel}) : super(key: key);

  @override
  _DetailSuratScreenState createState() => _DetailSuratScreenState();
}

class _DetailSuratScreenState extends State<DetailSuratScreen> {
  final ApiService apiService = ApiService();
  late Future<List<AyatModel>> futureAyat;

  @override
  void initState() {
    super.initState();
    futureAyat = apiService.getDetailSurat(widget.suratModel.nomor);
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
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              '${widget.suratModel.arti} • ${widget.suratModel.jumlahAyat} Ayat',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.teal[50]),
            ),
          ],
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<List<AyatModel>>(
        future: futureAyat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat ayat: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red),
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
                      gradient: LinearGradient(
                        colors: [Colors.teal[700]!, Colors.teal[500]!],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
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
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(20),
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
                          Icon(Icons.more_horiz_rounded, color: Colors.grey[400]),
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
    );
  }
}
