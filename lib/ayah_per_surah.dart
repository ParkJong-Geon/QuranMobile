  import 'dart:ui';
  import 'package:flutter/material.dart';
  import 'dart:convert';
  import 'package:http/http.dart' as http;

  class AyatPerSurahPage extends StatefulWidget {
    @override
    _AyatPerSurahPageState createState() => _AyatPerSurahPageState();
  }

  class _AyatPerSurahPageState extends State<AyatPerSurahPage> {
    List<dynamic> _ayatList = [];
    bool _isLoading = true;
    String? _surahName;
    int? _surahId;

    // Fungsi untuk mengambil daftar ayat berdasarkan surahId
    Future<void> _getAyatList(int surahId) async {
      final response =
          await http.get(Uri.parse('https://equran.id/api/v2/surat/$surahId'));
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body); // Decode JSON response
          print(
              'Data received: $data'); // Debugging: Print the entire data for inspection

          // Pastikan data yang kita ambil ada di dalam key 'data' dan 'ayat'
          if (data != null &&
              data['data'] != null &&
              data['data']['ayat'] != null) {
            setState(() {
              // Ambil list ayat dari JSON dan simpan ke dalam _ayatList
              _ayatList = data['data']['ayat'];
              _isLoading = false;
            });
          } else {
            print('Data ayat tidak ditemukan di respons.');
          }
        } catch (e) {
          print('Error decoding response: $e');
        }
      } else {
        print('Failed to load Ayat: ${response.statusCode}');
        throw Exception('Failed to load Ayat');
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
        _surahName = arguments['surahName'] ??
            'Unknown Surah'; // Set default name jika null
        _surahId = arguments['surahId'] ?? -1; // Set default id jika null

        print(
            'Surah Name: $_surahName, Surah Id: $_surahId'); // Log untuk debugging

        if (_surahId != -1 && _surahName != 'Unknown Surah') {
          _getAyatList(_surahId!);
        } else {
          print("Invalid surah data");
        }
      } else {
        print("No arguments or incomplete arguments passed");
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ayat per Surah: $_surahName',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Background Gambar dengan Efek Blur
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
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            // Konten utama
            Center(
                child: _isLoading
                    ? CircularProgressIndicator() // Menunggu data
                    : ListView.builder(
                        itemCount: _ayatList.length,
                        itemBuilder: (context, index) {
                          var ayat = _ayatList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white.withOpacity(0.1),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                title: Text(
                                  'Ayat ${ayat['nomorAyat']}', // Nomor ayat
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ayat['teksArab'] ??
                                          'Ayat tidak tersedia', // Ayat dalam bahasa Arab
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      ayat['teksIndonesia'] ??
                                          'Terjemahan tidak tersedia', // Terjemahan
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
          ],
        ),
      );
    }
  }
