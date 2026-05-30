import '../models/sholat_model.dart';

class SholatData {
  static List<SholatModel> getTataCara() {
    return [
      SholatModel(
        id: '1',
        name: 'Niat Sholat Subuh',
        arabic: 'أُصَلِّى فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
        latin: 'Ushalli fardhos subhi rok\'ataini mustaqbilal qiblati adaa-an lillaahi ta\'aalaa.',
        translation: 'Aku berniat sholat fardhu Subuh dua rakaat menghadap kiblat karena Allah Ta\'ala.',
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
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ...',
        latin: 'Bismillaahir rahmaanir rahiim. Alhamdu lillaahi rabbil \'aalamiin...',
        translation: 'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah, Tuhan seluruh alam...',
      ),
      SholatModel(
        id: '5',
        name: 'Ruku\'',
        arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيْمِ وَبِحَمْدِهِ',
        latin: 'Subhaana rabbiyal \'adziimi wa bihamdih. (3x)',
        translation: 'Maha Suci Tuhanku Yang Maha Agung dan dengan memuji-Nya.',
      ),
      SholatModel(
        id: '6',
        name: 'I\'tidal',
        arabic: 'سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ. رَبَّنَا لَكَ الْحَمْدُ',
        latin: 'Sami\'allaahu liman hamidah. Rabbanaa lakal hamd.',
        translation: 'Allah Maha Mendengar orang yang memuji-Nya. Ya Tuhan kami, bagi-Mu lah segala puji.',
      ),
      SholatModel(
        id: '7',
        name: 'Sujud',
        arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى وَبِحَمْدِهِ',
        latin: 'Subhaana rabbiyal a\'laa wa bihamdih. (3x)',
        translation: 'Maha Suci Tuhanku Yang Maha Tinggi dan dengan memuji-Nya.',
      ),
      SholatModel(
        id: '8',
        name: 'Duduk Di Antara Dua Sujud',
        arabic: 'رَبِّ اغْفِرْ لِيْ وَارْحَمْنِيْ وَاجْبُرْنِيْ وَارْفَعْنِيْ وَارْزُقْنِيْ وَاهْدِنِيْ وَعَافِنِيْ وَاعْفُ عَنِّيْ',
        latin: 'Rabbighfirlii warhamnii wajburnii warfa\'nii warzuqnii wahdinii wa\'aafinii wa\'fu \'annii.',
        translation: 'Ya Tuhanku, ampunilah aku, rahmatilah aku, cukupkanlah aku, angkatlah derajatku, berilah aku rezeki, berilah aku petunjuk, berilah aku kesehatan, dan maafkanlah aku.',
      ),
      SholatModel(
        id: '9',
        name: 'Tahiyat / Tasyahud Akhir',
        arabic: 'اَلتَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلّٰهِ...',
        latin: 'Attahiyyaatul mubaarokaatush shalawaatuth thayyibaatu lillaah...',
        translation: 'Segala penghormatan, keberkahan, salawat, dan kebaikan hanya milik Allah...',
      ),
      SholatModel(
        id: '10',
        name: 'Salam',
        arabic: 'اَلسَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
        latin: 'Assalaamu\'alaikum wa rahmatullaah.',
        translation: 'Semoga keselamatan dan rahmat Allah dilimpahkan kepadamu.',
      ),
    ];
  }
}
