import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapatupa/user/buat-permohonan.dart';
import 'package:tapatupa/user/home.dart';
import 'package:tapatupa/user/tagihan.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class permohonan extends StatefulWidget {
  @override
  _PermohonanState createState() => _PermohonanState();
}

class _PermohonanState extends State<permohonan> {
  int _currentIndex = 1; // Set the initial index to 1

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    tagihans(),
    RetributionListPage(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.red.withOpacity(0.7),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: _pages[_currentIndex], // Change the displayed page
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.view_list),
        //       label: 'Permohonan',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.account_balance_wallet),
        //       label: 'Tagihan',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.history),
        //       label: 'Pembayaran',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //   ],
        //   currentIndex: _currentIndex,
        //   selectedItemColor: Colors.red,
        //   unselectedItemColor: Colors.grey,
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index; // Update the current index when tapped
        //     });
        //   },
        // ),
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
  String? idPersonal;


  @override
  void initState() {
    super.initState();
    _loadIdPersonal(); // Load idPersonal first

  }

  // Load idPersonal from SharedPreferences
  Future<void> _loadIdPersonal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idPersonal = prefs.getInt('idPersonal'); // Assuming you stored it as int

    if (idPersonal != null) {
      // Convert idPersonal to String before passing to _fetchPermohonanData
      _fetchPermohonanData(idPersonal.toString());
    } else {
      print('No idPersonal found in SharedPreferences');
    }
  }

  // Fetch permohonan data based on idPersonal
  Future<void> _fetchPermohonanData(String idPersonal) async {
    try {
      final response = await http.get(Uri.parse('http://tapatupa.manoume.com/api/permohonan-mobile/$idPersonal'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _permohonanData = data['permohonanSewa'];
          print(_permohonanData);
        });
      } else {
        print('Failed to fetch permohonan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching permohonan data: $e');
    }
  }




  // Function to fetch permohonan data
  // Future<void> _fetchPermohonanData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? idPersonal = prefs.getString('idPersonal'); // Retrieve idPersonal from shared preferences
  // print(idPersonal);
  //   if (idPersonal != null) {
  //     try {
  //       final response = await http.get(Uri.parse('http://tapatupa.manoume.com/api/permohonan-mobile/$idPersonal')); // Replace '1' with idPersonal
  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         setState(() {
  //           _permohonanData = data['permohonanSewa'];
  //         });
  //       } else {
  //         print('Failed to fetch permohonan data: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       print('Error fetching permohonan data: $e');
  //     }
  //   } else {
  //     print('idPersonal not found');
  //   }
  // }

  // Fetch permohonan data based on idPersonal
  // Future<void> _fetchPermohonanData(String idPersonal) async {
  //   try {
  //     final response = await http.get(Uri.parse('http://tapatupa.manoume.com/api/permohonan-mobile/$idPersonal'));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         _permohonanData = data['permohonanSewa'];
  //       });
  //     } else {
  //       print('Failed to fetch permohonan data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching permohonan data: $e');
  //   }
  // }

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
                          Colors.black.withOpacity(0.5), // Menambahkan opacity
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
                              'Permohonan',
                              style: TextStyle(fontSize: 18, color: Colors.white),
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
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: _permohonanData != null && _permohonanData!.isNotEmpty
                                  ? Column(
                                children: _permohonanData!.map((data) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nomor Permohonan: ${data['nomorSuratPermohonan'] ?? 'Loading...'}',
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
                                                  color: Colors.blue.withOpacity(0.1),
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
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  data['namaStatus'] ?? 'Loading...',
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
                                                  'Jenis Permohonan: ${data['jenisPermohonan'] ?? 'Loading...'}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Tanggal Permohonan: ${data['tanggalDiajukan'] ?? 'Loading...'}',
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
                                      SizedBox(height: 20),
                                    ],
                                  );
                                }).toList(),
                              )
                                  : Center(
                                child: Text('Data tidak tersedia'),
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
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              // Navigasi ke halaman FormulirPermohonan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormulirPermohonan()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
