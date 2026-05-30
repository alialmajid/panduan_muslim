class SholatModel {
  final String id;
  final String name;
  final String arabic;
  final String latin;
  final String translation;

  SholatModel({
    required this.id,
    required this.name,
    required this.arabic,
    required this.latin,
    required this.translation,
  });
}

class JenisSholatModel {
  final String id;
  final String nama;
  final String niatArab;
  final String niatLatin;
  final String niatArti;
  final bool isWajib;

  JenisSholatModel({
    required this.id,
    required this.nama,
    required this.niatArab,
    required this.niatLatin,
    required this.niatArti,
    required this.isWajib,
  });
}
