import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';

class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({Key? key}) : super(key: key);

  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  PrayerTimes? _prayerTimes;
  String _locationName = 'Mencari lokasi...';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initJadwalSholat();
  }

  Future<void> _initJadwalSholat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 1. Cek Permission Lokasi
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Layanan GPS/Lokasi tidak aktif.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak permanen. Buka pengaturan aplikasi.');
      }

      // 2. Dapatkan Kordinat
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // 3. Dapatkan Nama Kota
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          _locationName = "${place.subAdministrativeArea ?? place.locality ?? 'Lokasi Anda'}";
        } else {
          _locationName = 'Lokasi Ditemukan';
        }
      } catch (e) {
        _locationName = 'Kordinat: ${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      }

      // 4. Hitung Jadwal Sholat (Kemenag RI: Subuh 20deg, Isya 18deg)
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.other.getParameters();
      params.fajrAngle = 20.0;
      params.ishaAngle = 18.0;
      params.madhab = Madhab.shafi;
      
      final date = DateComponents.from(DateTime.now());
      final prayerTimes = PrayerTimes(coordinates, date, params);

      if (mounted) {
        setState(() {
          _prayerTimes = prayerTimes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildJadwalContent(isDark),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Remix.error_warning_line, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Jadwal',
              style: GoogleFonts.elMessiri(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initJadwalSholat,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text('Coba Lagi', style: GoogleFonts.elMessiri(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalContent(bool isDark) {
    if (_prayerTimes == null) return const SizedBox();

    final now = DateTime.now();
    final formatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    // Tentukan waktu sholat berikutnya
    final nextPrayer = _prayerTimes!.nextPrayer();
    String nextPrayerName = '';
    DateTime? nextPrayerTime;

    if (nextPrayer == Prayer.fajr) {
      nextPrayerName = 'Subuh';
      nextPrayerTime = _prayerTimes!.fajr;
    } else if (nextPrayer == Prayer.sunrise) {
      nextPrayerName = 'Syuruq';
      nextPrayerTime = _prayerTimes!.sunrise;
    } else if (nextPrayer == Prayer.dhuhr) {
      nextPrayerName = 'Dzuhur';
      nextPrayerTime = _prayerTimes!.dhuhr;
    } else if (nextPrayer == Prayer.asr) {
      nextPrayerName = 'Ashar';
      nextPrayerTime = _prayerTimes!.asr;
    } else if (nextPrayer == Prayer.maghrib) {
      nextPrayerName = 'Maghrib';
      nextPrayerTime = _prayerTimes!.maghrib;
    } else if (nextPrayer == Prayer.isha) {
      nextPrayerName = 'Isya';
      nextPrayerTime = _prayerTimes!.isha;
    } else {
      nextPrayerName = 'Subuh (Besok)';
      // Asumsi besok
      nextPrayerTime = _prayerTimes!.fajr.add(const Duration(days: 1));
    }

    Duration diff = nextPrayerTime.difference(now);
    if (diff.isNegative) diff = const Duration(seconds: 0);
    String countdown = '${diff.inHours} Jam ${diff.inMinutes % 60} Menit';

    return RefreshIndicator(
      onRefresh: _initJadwalSholat,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Remix.map_pin_2_fill, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _locationName,
                        style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Menuju $nextPrayerName',
                    style: GoogleFonts.elMessiri(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    countdown,
                    style: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormatter.format(now),
                    style: GoogleFonts.elMessiri(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ).animate().fade().slideY(begin: -0.1),
            
            const SizedBox(height: 32),
            Text(
              'Jadwal Hari Ini',
              style: GoogleFonts.elMessiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ).animate().fade().slideX(),
            const SizedBox(height: 16),
            
            // List Waktu
            _buildTimeCard('Subuh', formatter.format(_prayerTimes!.fajr), Remix.sun_cloudy_line, isDark, nextPrayer == Prayer.fajr).animate().fade(delay: 100.ms).slideY(),
            _buildTimeCard('Terbit/Syuruq', formatter.format(_prayerTimes!.sunrise), Remix.sun_line, isDark, nextPrayer == Prayer.sunrise).animate().fade(delay: 150.ms).slideY(),
            _buildTimeCard('Dzuhur', formatter.format(_prayerTimes!.dhuhr), Remix.sun_fill, isDark, nextPrayer == Prayer.dhuhr).animate().fade(delay: 200.ms).slideY(),
            _buildTimeCard('Ashar', formatter.format(_prayerTimes!.asr), Remix.cloud_windy_line, isDark, nextPrayer == Prayer.asr).animate().fade(delay: 250.ms).slideY(),
            _buildTimeCard('Maghrib', formatter.format(_prayerTimes!.maghrib), Remix.moon_cloudy_line, isDark, nextPrayer == Prayer.maghrib).animate().fade(delay: 300.ms).slideY(),
            _buildTimeCard('Isya', formatter.format(_prayerTimes!.isha), Remix.moon_clear_fill, isDark, nextPrayer == Prayer.isha).animate().fade(delay: 350.ms).slideY(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String name, String time, IconData icon, bool isDark, bool isNext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isNext 
            ? AppColors.primary.withOpacity(isDark ? 0.2 : 0.1) 
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(16),
        border: isNext ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 1) : null,
        boxShadow: isNext ? [] : [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: isNext ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const SizedBox(width: 16),
          Text(
            name,
            style: GoogleFonts.elMessiri(
              fontSize: 16,
              fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
              color: isNext ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: GoogleFonts.elMessiri(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isNext ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
