import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PanduanMuslimApp());
}

class PanduanMuslimApp extends StatelessWidget {
  const PanduanMuslimApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panduan Sholat & Al-Quran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
