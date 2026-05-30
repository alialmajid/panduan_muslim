import '../models/sholat_model.dart';

class SholatData {
  static List<SholatModel> getTataCara() {
    return [
      SholatModel(
        id: '1',
        name: 'Niat Sholat',
        arabic: 'أُصَلِّيْ فَرْضَ ... مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
        latin: 'Ushalli fardhol ... mustaqbilal qiblati adaa-an lillaahi ta\'aalaa.',
        translation: 'Aku berniat sholat fardhu ... menghadap kiblat karena Allah Ta\'ala.',
      ),
      SholatModel(
        id: '2',
        name: 'Takbiratul Ihram',
        arabic: 'اللّٰهُ أَكْبَرُ',
        latin: 'Allahu Akbar.',
        translation: 'Allah Maha Besar.',
      ),
      SholatModel(
        id: '3',
        name: 'Doa Iftitah',
        arabic: 'اللّٰهُ أَكْبَرُ كَبِيْرًا وَالْحَمْدُ لِلّٰهِ كَثِيْرًا وَسُبْحَانَ اللّٰهِ بُكْرَةً وَأَصِيْلًا',
        latin: 'Allahu akbar kabiiraa wal hamdu lillaahi katsiiraa, wa subhaanallaahi bukratan wa aṣiilaa.',
        translation: 'Allah Maha Besar dengan sebesar-besarnya, segala puji bagi Allah dengan pujian yang banyak, dan Maha Suci Allah pada waktu pagi dan petang.',
      ),
      SholatModel(
        id: '4',
        name: 'Membaca Surat Al-Fatihah',
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ. الرَّحْمٰنِ الرَّحِيْمِ. مٰلِكِ يَوْمِ الدِّيْنِ. اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُ. اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَ. صِرَاطَ الَّذِيْنَ اَنْعَمْتَ عَلَيْهِمْ ەۙ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّاۤلِّيْنَ.',
        latin: 'Bismillaahir rahmaanir rahiim. Alhamdu lillaahi rabbil \'aalamiin. Ar-rahmaanir-rahiim. Maaliki yaumid-diin. Iyyaaka na\'budu wa iyyaaka nasta\'iin. Ihdinas-siraatal-mustaqiim. Siraatal-laziina an\'amta \'alaihim ghairil-maghduubi \'alaihim wa lad-daalliin.',
        translation: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang. Segala puji bagi Allah, Tuhan seluruh alam. Yang Maha Pengasih, Maha Penyayang. Pemilik hari pembalasan. Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan. Tunjukilah kami jalan yang lurus. (yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.',
      ),
      SholatModel(
        id: '5',
        name: 'Membaca Surat Pendek',
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ هُوَ اللّٰهُ اَحَدٌۚ. اَللّٰهُ الصَّمَدُۚ. لَمْ يَلِدْ وَلَمْ يُوْلَدْۙ. وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَدٌࣖ.',
        latin: 'Qul huwallahu ahad. Allahus-samad. Lam yalid wa lam yuulad. Wa lam yakul lahu kufuwan ahad.',
        translation: 'Katakanlah (Muhammad), "Dialah Allah, Yang Maha Esa. Allah tempat meminta segala sesuatu. (Allah) tidak beranak dan tidak pula diperanakkan. Dan tidak ada sesuatu yang setara dengan Dia."',
      ),
      SholatModel(
        id: '6',
        name: 'Ruku\'',
        arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيْمِ وَبِحَمْدِهِ',
        latin: 'Subhaana rabbiyal \'adziimi wa bihamdih. (Dibaca 3x)',
        translation: 'Maha Suci Tuhanku Yang Maha Agung dan dengan memuji-Nya.',
      ),
      SholatModel(
        id: '7',
        name: 'I\'tidal',
        arabic: 'سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ. رَبَّنَا لَكَ الْحَمْدُ مِلْءُ السَّمٰوَاتِ وَمِلْءُ الْأَرْضِ وَمِلْءُ مَا شِئْتَ مِنْ شَيْءٍ بَعْدُ',
        latin: 'Sami\'allaahu liman hamidah. Rabbanaa lakal hamdu mil\'us samaawaati wa mil\'ul ardhi wa mil\'u maa syi\'ta min syai\'in ba\'du.',
        translation: 'Allah Maha Mendengar orang yang memuji-Nya. Ya Tuhan kami, bagi-Mu lah segala puji, sepenuh langit dan bumi, dan sepenuh barang yang Engkau kehendaki sesudah itu.',
      ),
      SholatModel(
        id: '8',
        name: 'Sujud Pertama',
        arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى وَبِحَمْدِهِ',
        latin: 'Subhaana rabbiyal a\'laa wa bihamdih. (Dibaca 3x)',
        translation: 'Maha Suci Tuhanku Yang Maha Tinggi dan dengan memuji-Nya.',
      ),
      SholatModel(
        id: '9',
        name: 'Duduk Di Antara Dua Sujud',
        arabic: 'رَبِّ اغْفِرْ لِيْ وَارْحَمْنِيْ وَاجْبُرْنِيْ وَارْفَعْنِيْ وَارْزُقْنِيْ وَاهْدِنِيْ وَعَافِنِيْ وَاعْفُ عَنِّيْ',
        latin: 'Rabbighfirlii warhamnii wajburnii warfa\'nii warzuqnii wahdinii wa\'aafinii wa\'fu \'annii.',
        translation: 'Ya Tuhanku, ampunilah aku, rahmatilah aku, cukupkanlah aku, angkatlah derajatku, berilah aku rezeki, berilah aku petunjuk, berilah aku kesehatan, dan maafkanlah aku.',
      ),
      SholatModel(
        id: '10',
        name: 'Sujud Kedua',
        arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى وَبِحَمْدِهِ',
        latin: 'Subhaana rabbiyal a\'laa wa bihamdih. (Dibaca 3x)',
        translation: 'Maha Suci Tuhanku Yang Maha Tinggi dan dengan memuji-Nya.',
      ),
      SholatModel(
        id: '11',
        name: 'Tasyahud Awal',
        arabic: 'اَلتَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلّٰهِ. اَلسَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ...',
        latin: 'Attahiyyaatul mubaarokaatush shalawaatuth thayyibaatu lillaah. Assalaamu\'alaika ayyuhan nabiyyu wa rahmatullaahi wa barakaatuh...',
        translation: 'Segala penghormatan, keberkahan, salawat, dan kebaikan hanya milik Allah. Semoga keselamatan, rahmat, dan berkah Allah tercurah kepadamu wahai Nabi...',
      ),
      SholatModel(
        id: '12',
        name: 'Tasyahud Akhir & Sholawat',
        arabic: 'اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ، وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا إِبْرَاهِيْمَ...',
        latin: 'Allahumma shalli \'alaa sayyidinaa muhammad, wa \'alaa aali sayyidinaa muhammad, kamaa shallaita \'alaa sayyidinaa ibraahiim...',
        translation: 'Ya Allah, limpahkanlah rahmat kepada Nabi Muhammad dan kepada keluarga Nabi Muhammad, sebagaimana Engkau telah melimpahkan rahmat kepada Nabi Ibrahim...',
      ),
      SholatModel(
        id: '13',
        name: 'Salam',
        arabic: 'اَلسَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
        latin: 'Assalaamu\'alaikum wa rahmatullaah.',
        translation: 'Semoga keselamatan dan rahmat Allah dilimpahkan kepadamu.',
      ),
    ];
  }
}
