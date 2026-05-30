import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surat_model.dart';
import '../models/ayat_model.dart';

class ApiService {
  static const String baseUrl = 'https://equran.id/api/v2';

  // Mendapatkan daftar seluruh surat
  Future<List<SuratModel>> getAllSurat() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Memeriksa struktur code 200 dan mengambil bagian 'data'
        if (jsonResponse['code'] == 200 && jsonResponse['data'] != null) {
          List<dynamic> data = jsonResponse['data'];
          return data.map((item) => SuratModel.fromJson(item)).toList();
        } else {
          throw Exception('Format data tidak sesuai');
        }
      } else {
        throw Exception('Gagal memuat surat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Mendapatkan detail surat beserta ayat-ayatnya
  Future<List<AyatModel>> getDetailSurat(int nomorSurat) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$nomorSurat'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['code'] == 200 && jsonResponse['data'] != null) {
          // Bagian ayat ada di dalam object data -> ayat
          List<dynamic> ayatData = jsonResponse['data']['ayat'];
          return ayatData.map((item) => AyatModel.fromJson(item)).toList();
        } else {
          throw Exception('Format data ayat tidak sesuai');
        }
      } else {
        throw Exception('Gagal memuat ayat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
