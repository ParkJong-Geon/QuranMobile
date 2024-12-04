import 'package:flutter/material.dart';
import 'dart:ui'; // Import untuk BackdropFilter
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarDoaPage extends StatefulWidget {
  @override
  _DaftarDoaPageState createState() => _DaftarDoaPageState();
}

class _DaftarDoaPageState extends State<DaftarDoaPage> {
  List<dynamic> _doaList = [];
  List<dynamic> _filteredDoaList = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  // Fungsi untuk mengambil daftar doa dari API
  Future<void> _fetchDoaList() async {
    final response = await http.get(Uri.parse('https://doa-doa-api-ahmadramadhan.fly.dev/api'));
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        setState(() {
          _doaList = data;
          _filteredDoaList = data; // Awalnya tampilkan semua doa
          _isLoading = false;
        });
      } catch (e) {
        print('Error decoding response: $e');
      }
    } else {
      print('Failed to load doa: ${response.statusCode}');
      setState(() {
        _isLoading = false; // Hentikan loading jika gagal
      });
    }
  }

  // Fungsi untuk memfilter daftar doa berdasarkan pencarian
  void _filterDoaList(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _filteredDoaList = _doaList
            .where((doa) =>
                doa['doa'].toLowerCase().contains(query.toLowerCase()) ||
                doa['ayat'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredDoaList = _doaList; // Tampilkan semua doa jika tidak ada query
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDoaList();
    _searchController.addListener(() {
      _filterDoaList(_searchController.text); // Setiap input berubah, lakukan pencarian
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Doa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Doa...',
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
          // Background blur
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
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredDoaList.length,
                          itemBuilder: (context, index) {
                            var doa = _filteredDoaList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white.withOpacity(0.1), // Transparan putih
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.white, // Border putih
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                  title: Text(
                                    doa['doa'] ?? 'Doa tidak tersedia',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    doa['ayat'] ?? '',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
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
