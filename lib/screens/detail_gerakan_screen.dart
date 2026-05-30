import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sholat_model.dart';

class DetailGerakanScreen extends StatelessWidget {
  final SholatModel sholatModel;

  const DetailGerakanScreen({Key? key, required this.sholatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          sholatModel.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container Teks Arab
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
              child: Text(
                sholatModel.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                  height: 2.2,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Teks Latin
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.teal[50], shape: BoxShape.circle),
                  child: Icon(Icons.spellcheck_rounded, size: 20, color: Colors.teal[700]),
                ),
                const SizedBox(width: 12),
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                sholatModel.latin,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.teal[700],
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Terjemahan
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber[50], shape: BoxShape.circle),
                  child: Icon(Icons.translate_rounded, size: 20, color: Colors.amber[700]),
                ),
                const SizedBox(width: 12),
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                sholatModel.translation,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
