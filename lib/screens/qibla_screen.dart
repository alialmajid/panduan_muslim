import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' show pi;
import '../theme/colors.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Future.wait([
          _deviceSupport,
          FlutterQiblah.checkLocationStatus(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error.toString()}',
                textAlign: TextAlign.center,
                style: GoogleFonts.elMessiri(color: Colors.red),
              ),
            );
          }

          final hasSupport = snapshot.data![0] as bool?;
          final locationStatus = snapshot.data![1] as LocationStatus;

          if (hasSupport != true) {
            return Center(
              child: Text(
                'Perangkat Anda tidak mendukung sensor kompas.',
                style: GoogleFonts.elMessiri(fontSize: 16),
              ),
            );
          }

          if (locationStatus.enabled &&
              locationStatus.status == LocationPermission.denied) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Izin lokasi diperlukan untuk menghitung arah kiblat.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.elMessiri(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await FlutterQiblah.requestPermissions();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: Text('Beri Izin Akses',
                        style: GoogleFonts.elMessiri(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          if (locationStatus.enabled &&
              locationStatus.status == LocationPermission.deniedForever) {
            return Center(
              child: Text(
                'Izin lokasi ditolak permanen. Silakan ubah dari pengaturan aplikasi.',
                textAlign: TextAlign.center,
                style: GoogleFonts.elMessiri(fontSize: 16),
              ),
            );
          }

          return _buildQiblahCompass(isDark);
        },
      ),
    );
  }

  Widget _buildQiblahCompass(bool isDark) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal mendapatkan arah kiblat. Pastikan GPS & Lokasi aktif.',
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(fontSize: 16),
            ),
          );
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return Center(
            child: Text(
              'Arah tidak ditemukan. Mohon kalibrasi kompas Anda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(fontSize: 16),
            ),
          );
        }

        // qiblahDirection.direction is the angle from north
        // qiblahDirection.offset is the angle from current heading to qibla
        final compassAngle = qiblahDirection.direction * (pi / 180) * -1;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${qiblahDirection.direction.toStringAsFixed(0)}°',
                style: GoogleFonts.elMessiri(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ).animate().fade().scale(),
              const SizedBox(height: 12),
              Text(
                'Putar HP Anda hingga Ikon Kabah\nsejajar dengan panah tengah',
                textAlign: TextAlign.center,
                style: GoogleFonts.elMessiri(
                  fontSize: 16,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ).animate().fade().slideY(),
              const SizedBox(height: 64),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Compass Dial
                  Transform.rotate(
                    angle: compassAngle,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // North Marker
                          Positioned(
                            top: 10,
                            child: Text(
                              'U',
                              style: GoogleFonts.elMessiri(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'S',
                              style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 15,
                            child: Text(
                              'T',
                              style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 15,
                            child: Text(
                              'B',
                              style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                          // Qibla Indicator (Clean Marker) on the dial
                          Transform.rotate(
                            angle: qiblahDirection.qiblah * (pi / 180),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: const FaIcon(
                                  FontAwesomeIcons.kaaba,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(),

                  // Center Needle (Panah Statis Menghadap ke Atas)
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -30,
                        child: Icon(
                          Remix.arrow_up_s_fill,
                          color: AppColors.primary,
                          size: 40,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
