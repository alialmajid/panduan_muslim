# Panduan Muslim 🕌

Panduan Muslim adalah aplikasi panduan ibadah harian berbasis Flutter yang didesain secara profesional, bersih (*clean*), dan elegan menggunakan pendekatan *Enterprise Flat Design*. Aplikasi ini dirancang untuk memudahkan umat Islam dalam belajar tata cara sholat yang lengkap dan akurat, serta membaca dan mendengarkan murottal Al-Quran secara digital.

---

## 🌟 Fitur Utama

### 1. 📖 Al-Quran Digital & Audio Murottal
*   **Akses Penuh 114 Surat:** Menyajikan seluruh ayat Al-Quran lengkap dengan teks Arab (menggunakan font Amiri yang indah), cara baca Latin, dan terjemahan Bahasa Indonesia.
*   **Pencarian Pintar:** Kemudahan mencari surat spesifik berdasarkan Nama Latin maupun Terjemahan/Artinya.
*   **Pemutar Audio Fleksibel:** Mendengarkan lantunan ayat per ayat atau *full* satu surat.
*   **Pilihan Qari Beragam:** Mendukung pergantian suara pembaca (Qari) dari tokoh terkemuka dunia:
    *   Abdullah Al-Juhany
    *   Abdul Muhsin
    *   Abdurrahman Sudais
    *   Ibrahim Al-Dossari
    *   Misyari Rasyid
    *   Yasser Al-Dosari

### 2. 🤲 Tata Cara Sholat (Lengkap & Terperinci)
*   **Kategori Wajib & Sunnah:** Filterisasi yang membedakan sholat Fardhu (Subuh, Dzuhur, Ashar, Maghrib, Isya) dan sholat Sunnah (Dhuha, Tahajjud).
*   **Panduan Langkah-demi-Langkah:** Menyediakan rincian dari Niat hingga Salam (kiri dan kanan).
*   **Teks Lengkap:** Menghindari teks terpotong (*...*). Doa Iftitah, Tasyahud Awal, dan Tasyahud Akhir (lengkap dengan Sholawat Ibrahimiyah) disajikan penuh beserta transliterasi dan terjemahannya.

### 3. 🏠 Smart Home Screen
*   **Riwayat Terakhir Dibaca:** Secara otomatis mengingat dan menampilkan Surat Al-Quran terakhir yang sedang Anda buka. Cukup klik sekali di *Home Screen* untuk melanjutkan bacaan!
*   **Hadits Harian:** Menyediakan suntikan motivasi rohani di tampilan awal.
*   **Desain Kelas Enterprise:** Menggunakan filosofi desain *solid, flat, no glow* dengan penggunaan garis tepi 1.5px dan proporsi lekukan sudut (border-radius 12) yang nyaman dan elegan di mata layaknya aplikasi profesional tingkat atas.

---

## 🛠️ Teknologi & *Libraries*

Proyek ini dibangun menggunakan **Flutter (Dart)** dengan beberapa *dependency* utama:
*   `http: ^1.2.0`: Melakukan penarikan (*fetch*) data API Al-Quran (bersumber dari EQuran.id).
*   `google_fonts: ^6.2.1`: Menyajikan tipografi premium (Poppins untuk UI, Amiri untuk teks Arab).
*   `audioplayers: ^6.6.0`: Memutar *stream* audio Murottal tanpa lag.
*   `shared_preferences: ^2.5.5`: Menyimpan data lokal seperti riwayat Surat Terakhir Dibaca.

---

## 🚀 Instalasi & Menjalankan Aplikasi

1. **Pastikan Flutter SDK terinstal** di sistem operasi Anda.
2. Buka Terminal atau Command Prompt, lalu lakukan *clone* atau arahkan ke direktori proyek ini:
   ```bash
   cd panduan_muslim
   ```
3. Unduh seluruh pustaka (*dependencies*):
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi di emulator atau perangkat fisik Anda:
   ```bash
   flutter run
   ```

---

## 📂 Struktur Direktori Utama
*   `/lib/models/`: Konfigurasi *Data Class* (Model) untuk integrasi dari format JSON API (AyatModel, SuratModel, dll).
*   `/lib/data/`: Data statis internal (*Mock/Local Data*) untuk bacaan Tata Cara Sholat.
*   `/lib/services/`: Penanganan koneksi internet (*Network Fetch*) melalui `ApiService`.
*   `/lib/screens/`: 
    *   `home_screen.dart`: Dashboard utama dan logika Riwayat Bacaan.
    *   `tata_cara_screen.dart` & `list_gerakan_screen.dart`: Halaman panduan sholat.
    *   `list_surat_screen.dart` & `detail_surat_screen.dart`: Halaman Al-Quran.

---

*Dibuat untuk memudahkan langkah kebaikan. Semoga bermanfaat!* 🌿
