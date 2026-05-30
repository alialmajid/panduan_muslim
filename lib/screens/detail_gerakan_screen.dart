import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sholat_model.dart';

class DetailGerakanScreen extends StatelessWidget {
  final SholatModel sholatModel;

  const DetailGerakanScreen({Key? key, required this.sholatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          sholatModel.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Teks Arab
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                sholatModel.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                  height: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Label Latin
            Row(
              children: [
                Icon(Icons.menu_book, size: 20, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Text(
                  'Bacaan Latin',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Teks Latin
            Text(
              sholatModel.latin,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[800],
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),

            // Label Arti
            Row(
              children: [
                Icon(Icons.translate, size: 20, color: Colors.amber[700]),
                const SizedBox(width: 8),
                Text(
                  'Terjemahan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Teks Arti
            Text(
              sholatModel.translation,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
