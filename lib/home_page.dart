  import 'package:flutter/material.dart';
  import 'dart:ui'; // Import untuk BackdropFilter

  class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/makkahbackground.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 7.0),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Menampilkan gambar logo Al-Quran
                  Image.asset(
                    'assets/bismillah2.png',
                    height: 80, // Ukuran gambar
                    width: 80,
                  ),
                  SizedBox(height: 10),
                  // Tombol untuk Baca Quran
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/bacaQuran');
                    },
                    child: Text(
                      'Baca Quran',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tombol untuk Tafsir Surah
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      // Navigasi ke halaman Pencarian Surah
                      Navigator.pushNamed(context, '/bacaTafsir');
                    },
                    child: Text(
                      'Tafsir Surah',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tombol untuk Halaman Doa
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      // Navigasi ke halaman Doa
                      Navigator.pushNamed(context, '/daftarDoa');
                    },
                    child: Text(
                      'Baca Doa',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
