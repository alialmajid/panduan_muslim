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

  @override
  void initState() {
    super.initState();
    futureSurat = apiService.getAllSurat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Al-Quran Digital',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<SuratModel>>(
        future: futureSurat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<SuratModel> suratList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: suratList.length,
              itemBuilder: (context, index) {
                final surat = suratList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 0.785398, // 45 degrees
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.teal[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Text(
                                  surat.nomor.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                  ),
                                ),
                              ],
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
                                      fontWeight: FontWeight.w600,
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
    );
  }
}
