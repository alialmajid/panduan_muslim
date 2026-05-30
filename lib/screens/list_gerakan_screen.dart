import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sholat_data.dart';
import '../models/sholat_model.dart';
import 'detail_gerakan_screen.dart';

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
          jenisSholat.nama,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemCount: tataCaraList.length,
        itemBuilder: (context, index) {
          final item = tataCaraList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.08),
                  spreadRadius: 2,
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
                      builder: (context) => DetailGerakanScreen(sholatModel: item),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.id,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.teal[300]),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
