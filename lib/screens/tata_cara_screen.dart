import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sholat_data.dart';
import '../models/sholat_model.dart';
import 'detail_gerakan_screen.dart';

class TataCaraScreen extends StatelessWidget {
  const TataCaraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SholatModel> tataCaraList = SholatData.getTataCara();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Tata Cara Sholat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: tataCaraList.length,
        itemBuilder: (context, index) {
          final item = tataCaraList[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.teal[100],
                foregroundColor: Colors.teal[900],
                child: Text(
                  item.id,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                item.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.teal),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailGerakanScreen(sholatModel: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
