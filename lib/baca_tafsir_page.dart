import 'package:flutter/material.dart';
import 'dart:ui'; // Import untuk BackdropFilter
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BacaTafsirPage extends StatefulWidget {
  @override
  _BacaTafsirPageState createState() => _BacaTafsirPageState();
}

class _BacaTafsirPageState extends State<BacaTafsirPage> {
  List<dynamic> _surahList = [];
  List<dynamic> _filteredSurahList = [];
  bool _isLoading = true;
  String? _lastReadSurah;
  TextEditingController _searchController = TextEditingController();

  // Fungsi untuk mengambil daftar Surah dari API
  Future<void> _getSurahList() async {
    final response = await http.get(Uri.parse('https://equran.id/api/v2/surat'));
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body)['data'];
        if (data != null) {
          setState(() {
            _surahList = data;
            _filteredSurahList = data; // Awalnya tampilkan seluruh surah
            _isLoading = false;
          });
        } else {
          print('Data null ditemukan');
        }
      } catch (e) {
        print('Error decoding response: $e');
      }
    } else {
      print('Failed to load Surah: ${response.statusCode}');
      throw Exception('Failed to load Surah');
    }
  }

  // Fungsi untuk mengambil surah terakhir yang dibaca dari shared_preferences
  Future<void> _getLastReadSurah() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastRead = prefs.getString('lastReadSurah');
    print('Last Read Surah: $lastRead');  // Log data

    setState(() {
      _lastReadSurah = lastRead;
    });
  }

  // Fungsi untuk menyimpan surah terakhir yang dibaca ke shared_preferences
  Future<void> _saveLastReadSurah(String surahName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastReadSurah', surahName);
  }

  // Fungsi untuk memfilter daftar surah berdasarkan pencarian
  void _filterSurahList(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _filteredSurahList = _surahList
            .where((surah) =>
                surah['nama'].toLowerCase().contains(query.toLowerCase()) ||
                surah['namaLatin'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredSurahList = _surahList; // Jika tidak ada query, tampilkan semua surah
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSurahList();
    _getLastReadSurah();
    _searchController.addListener(() {
      _filterSurahList(_searchController.text); // Setiap input berubah, lakukan pencarian
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Baca Tafsir',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Surah...',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
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
                : Column(
                    children: [
                      // Menampilkan Surah yang terakhir dibaca
                      if (_lastReadSurah != null)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Surah Terakhir Dibaca: $_lastReadSurah',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredSurahList.length,
                          itemBuilder: (context, index) {
                            var surah = _filteredSurahList[index];
                            String surahName = surah['nama'] ?? 'Unknown Surah';  // Set default jika null
                            String surahNameLatin = surah['namaLatin'] ?? 'Unknown Surah Latin';  // Set default jika null
                            int surahNumber = surah['nomor'] ?? -1;  // Set default jika null

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white.withOpacity(0.1), // Putih transparan
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.white, // Pojok putih
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Menampilkan Nama Latin di atas Nama Arab
                                      Text(
                                        surahNameLatin,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white, // Teks latin putih
                                        ),
                                      ),
                                      Text(
                                        '$surahName ($surahNumber)',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Teks Arab putih
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    surah['arti'] ?? 'Arti tidak tersedia',  // Tambahkan pengecekan null untuk arti
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  onTap: () {
                                    // Menyimpan surah yang dipilih
                                    _saveLastReadSurah(surahName);
                                    Navigator.pushNamed(
                                      context,
                                      '/tafsirSurah',
                                      arguments: {
                                        'surahId': surahNumber,
                                        'surahName': surahName
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
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
