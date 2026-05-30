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
      backgroundColor: Colors.white,
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
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
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
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<AyatModel> ayatList = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: ayatList.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              itemBuilder: (context, index) {
                final ayat = ayatList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Teks Arab beserta Nomor
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nomor Ayat
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.teal[50],
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            ayat.nomorAyat.toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Teks Arab - Dibungkus Expanded agar aman
                        Expanded(
                          child: Text(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 8),
                    // Terjemahan Indonesia
                    Text(
                      ayat.teksIndonesia,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ],
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
