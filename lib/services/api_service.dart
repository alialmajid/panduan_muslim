import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/surat_model.dart';
import '../models/ayat_model.dart';

class ApiService {
  // Mendapatkan daftar seluruh surat dari file JSON lokal
  Future<List<SuratModel>> getAllSurat() async {
    try {
      final String response = await rootBundle.loadString('assets/data/surat.json');
      final Map<String, dynamic> jsonResponse = json.decode(response);
      
      if (jsonResponse['code'] == 200 && jsonResponse['data'] != null) {
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => SuratModel.fromJson(item)).toList();
      } else {
        throw Exception('Format data tidak sesuai');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan memuat data lokal: $e');
    }
  }

  // Mendapatkan detail surat beserta ayat-ayatnya dari file JSON lokal
  Future<List<AyatModel>> getDetailSurat(int nomorSurat) async {
    try {
      final String response = await rootBundle.loadString('assets/data/surat/$nomorSurat.json');
      final Map<String, dynamic> jsonResponse = json.decode(response);
      
      if (jsonResponse['code'] == 200 && jsonResponse['data'] != null) {
        List<dynamic> ayatData = jsonResponse['data']['ayat'];
        return ayatData.map((item) => AyatModel.fromJson(item)).toList();
      } else {
        throw Exception('Format data ayat tidak sesuai');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan memuat data lokal ayat: $e');
    }
  }
}
