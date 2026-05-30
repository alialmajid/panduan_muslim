import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sholat_data.dart';
import '../models/sholat_model.dart';
import 'list_gerakan_screen.dart';

class TataCaraScreen extends StatelessWidget {
  const TataCaraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<JenisSholatModel> semuaSholat = SholatData.getJenisSholat();
    final List<JenisSholatModel> sholatWajib = semuaSholat.where((s) => s.isWajib).toList();
    final List<JenisSholatModel> sholatSunnah = semuaSholat.where((s) => !s.isWajib).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Pilihan Sholat',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.teal[900]),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal[900],
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.teal[700],
            indicatorWeight: 3,
            labelColor: Colors.teal[800],
            unselectedLabelColor: Colors.grey[500],
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.normal),
            tabs: const [
              Tab(text: 'Sholat Wajib'),
              Tab(text: 'Sholat Sunnah'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(sholatWajib),
            _buildList(sholatSunnah),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<JenisSholatModel> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
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
                    builder: (context) => ListGerakanScreen(jenisSholat: item),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.mosque_rounded, color: Colors.teal[700], size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nama,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tata cara & niat lengkap',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
