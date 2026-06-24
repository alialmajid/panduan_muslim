import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://equran.id/api/v2';
  final dir = Directory('assets/data/surat');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  print('Mulai mengunduh daftar surat...');
  final resSurat = await http.get(Uri.parse('$baseUrl/surat'));
  if (resSurat.statusCode == 200) {
    await File('assets/data/surat.json').writeAsString(resSurat.body);
    print('Berhasil mengunduh daftar surat.');
  } else {
    print('Gagal mengunduh daftar surat: ${resSurat.statusCode}');
    return;
  }
  
  for (int i = 1; i <= 114; i++) {
    print('Mengunduh detail surat $i...');
    final resDetail = await http.get(Uri.parse('$baseUrl/surat/$i'));
    if (resDetail.statusCode == 200) {
      await File('assets/data/surat/$i.json').writeAsString(resDetail.body);
    } else {
      print('Gagal mengunduh surat $i');
    }
    // Delay sedikit agar tidak terkena rate limit
    await Future.delayed(Duration(milliseconds: 200)); 
  }
  print('Semua data berhasil diunduh ke folder assets/data!');
}
