import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

class TafsirSurahPage extends StatefulWidget {
  @override
  _TafsirSurahPageState createState() => _TafsirSurahPageState();
}

class _TafsirSurahPageState extends State<TafsirSurahPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _tafsirData;
  String? _surahName;
  int? _surahId;

  Future<void> _getTafsir(int surahId) async {
    try {
      final response =
          await http.get(Uri.parse('https://equran.id/api/v2/tafsir/$surahId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['data'] != null) {
          setState(() {
            _tafsirData = data['data'];
            _isLoading = false;
          });
        } else {
          print('Tafsir data not found');
          setState(() {
            _isLoading = false; // Stop loading if data not found
          });
        }
      } else {
        print('Failed to load Tafsir: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Stop loading on error
        });
        throw Exception('Failed to load Tafsir');
      }
    } catch (e) {
      print('Error fetching Tafsir: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null &&
        arguments.containsKey('surahName') &&
        arguments.containsKey('surahId')) {
      _surahName = arguments['surahName'] ?? 'Unknown Surah';
      _surahId = arguments['surahId'] ?? -1;

      if (_surahId != -1 && _surahName != 'Unknown Surah') {
        _getTafsir(_surahId!);
      } else {
        print("Invalid surah data");
        setState(() {
          _isLoading = false; // Stop loading if surah data is invalid
        });
      }
    } else {
      print("No arguments or incomplete arguments passed");
      setState(() {
        _isLoading = false; // Stop loading if no arguments
      });
    }
  }

  // Function to clean HTML tags like <i> and </i>
  String _removeHtmlTags(String text) {
    final document = htmlParser.parse(text);
    return document.body?.text ?? text; // Mengambil teks tanpa tag HTML
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tafsir Surah: $_surahName',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background dengan efek blur
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/makkahbackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black.withOpacity(
                    0.6), // Lebih gelap untuk kontras yang lebih baik
              ),
            ),
          ),
          // Konten utama
          Center(
            child: _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white)) // Loader putih
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Info Surah (Nama, Terjemahan, dll.)
                          Text(
                            'Surah: ${_tafsirData?['nama']} (${_tafsirData?['namaLatin']})',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Jumlah Ayat: ${_tafsirData?['jumlahAyat']}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Tempat Turun: ${_tafsirData?['tempatTurun']}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          // Deskripsi Surah
                          Text(
                            _tafsirData?['deskripsi'] ??
                                'Deskripsi tidak tersedia',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          // Daftar Tafsir Ayat
                          if (_tafsirData?['tafsir'] != null) ...[
                            for (var tafsir in _tafsirData!['tafsir']) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Card(
                                  color: Colors.white.withOpacity(0.1),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    title: Text(
                                      'Ayat ${tafsir['ayat']}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      _removeHtmlTags(tafsir['teks'] ??
                                          'Tafsir tidak tersedia'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ] else ...[
                            Text('Tafsir tidak tersedia',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
