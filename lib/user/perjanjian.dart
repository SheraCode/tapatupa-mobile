import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapatupa/user/buat-permohonan.dart';
import 'package:tapatupa/user/detail-perjanjian.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class perjanjian extends StatefulWidget {
  @override
  _PerjanjianState createState() => _PerjanjianState();
}

class _PerjanjianState extends State<perjanjian> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    bayar(),
    RetributionListPage(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Permohonan'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Tagihan'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Pembayaran'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? _permohonanData;

  @override
  void initState() {
    super.initState();
    _fetchPermohonanData();
  }

  Future<void> _fetchPermohonanData() async {
    try {
      final response = await http.get(Uri.parse('http://tapatupa.manoume.com/api/perjanjian-mobile/1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _permohonanData = data['perjanjianSewa'];
        });
      } else {
        print('Failed to fetch permohonan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching permohonan data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Bagian atas dengan gambar
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      height: screenHeight / 4 + MediaQuery.of(context).padding.top,
                      width: double.infinity,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.8), // Menambahkan opacity
                          BlendMode.darken,
                        ),
                        child: Image.asset(
                          'assets/bg_layar.png', // Ganti dengan path gambar Anda
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 19),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/miranda.JPG',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Perjanjian Sewa',
                              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -90),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                if (_permohonanData != null && _permohonanData!.isNotEmpty) {
                                  final int id = _permohonanData![0]['idPerjanjianSewa']; // Pastikan key 'id' sesuai dengan API
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => detailPerjanjian(id: id),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nomor Surat Perjanjian: ${_permohonanData?[0]['nomorSuratPerjanjian'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.insert_drive_file,
                                                size: 32,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                _permohonanData != null &&
                                                    _permohonanData!.isNotEmpty
                                                    ? _permohonanData![0]['namaStatus']
                                                    : 'Loading...',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tanggal Disahkan: ${_permohonanData?[0]['tanggalDisahkan'] ?? 'Loading...'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Tanggal Berlaku: \n${_permohonanData?[0]['tanggalAwalBerlaku'] ?? 'Loading...'} - ${_permohonanData?[0]['tanggalAkhirBerlaku'] ?? 'Loading...'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Objek Retribusi: \n${_permohonanData?[0]['objekRetribusi'] ?? 'Loading...'} - ${_permohonanData?[0]['kodeObjekRetribusi'] ?? 'Loading...'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

