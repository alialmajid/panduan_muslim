class AyatModel {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audioAyat;

  AyatModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audioAyat,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
      audioAyat: json['audio'] != null ? Map<String, String>.from(json['audio']) : {},
    );
  }
}
