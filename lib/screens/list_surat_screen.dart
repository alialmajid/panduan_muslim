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
          'Bacaan Al-Quran',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<SuratModel>>(
        future: futureSurat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<SuratModel> suratList = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: suratList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final surat = suratList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.star_border, size: 45, color: Colors.amber[600]),
                      Text(
                        surat.nomor.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    surat.namaLatin,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal[900],
                    ),
                  ),
                  subtitle: Text(
                    '${surat.tempatTurun} • ${surat.jumlahAyat} Ayat',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Text(
                    surat.nama,
                    style: GoogleFonts.amiri(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailSuratScreen(suratModel: surat),
                      ),
                    );
                  },
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
