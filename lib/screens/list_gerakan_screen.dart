import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sholat_data.dart';
import '../models/sholat_model.dart';

class ListGerakanScreen extends StatelessWidget {
  final JenisSholatModel jenisSholat;

  const ListGerakanScreen({Key? key, required this.jenisSholat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SholatModel> tataCaraList = SholatData.getTataCara(jenisSholat);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bacaan ${jenisSholat.nama}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        itemCount: tataCaraList.length,
        itemBuilder: (context, index) {
          final item = tataCaraList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.teal.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Nama Gerakan (tanpa angka 1, 2, 3)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Teks Arab
                Text(
                  item.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                    height: 2.2,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Teks Latin
                Text(
                  item.latin,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.teal[700],
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Terjemahan
                Text(
                  item.translation,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
