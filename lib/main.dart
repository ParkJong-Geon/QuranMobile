import 'package:appquran/ayah_per_surah.dart';
import 'package:appquran/baca_tafsir_page.dart';
import 'package:appquran/daftar_doa_page.dart';
import 'package:appquran/tafsir_surah_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import halaman utama
import 'baca_quran_page.dart'; // Import halaman Baca Quran

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Quran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set halaman pertama yang ditampilkan
      routes: {
        '/': (context) => HomePage(), // Halaman utama
        '/bacaQuran': (context) => BacaQuranPage(), // Halaman Baca Quran
        '/ayatPerSurah': (context) =>
            AyatPerSurahPage(), // Halaman Ayat per Surah
        '/bacaTafsir': (context) => BacaTafsirPage(),
        '/tafsirSurah': (context) => TafsirSurahPage(),
        '/daftarDoa': (context) => DaftarDoaPage(),
      },
    );
  }
}
