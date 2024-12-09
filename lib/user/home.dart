import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapatupa/user/detail-perjanjian.dart';
import 'package:tapatupa/user/perjanjian.dart';
import 'package:tapatupa/user/permohonan.dart';
import 'package:tapatupa/user/tarif-objek.dart';
import 'RetributionListPage.dart'; // Import your RetributionListPage here
import 'profile.dart'; // Import the ProfilePage here
import 'bayar.dart';

class home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<home> {
  int _currentIndex = 0; // This keeps track of the selected bottom nav item

  // Pages for BottomNavigationBar items
  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    bayar(), // For the 'Bayar' Page
    RetributionListPage(), // For the 'History' Page
    profile(), // The Profile Page
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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: 'Permohonan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Tagihan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Pembayaran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the current index when tapped
            });
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight / 4 + MediaQuery.of(context).padding.top,
            color: Colors.red.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 19,
              ),
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
                        'Hi, Miranda\nSelamat datang di Aplikasi \nObjek Retribusi Tapanuli Utara',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
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
                  transform: Matrix4.translationValues(0, -(screenHeight / 4 - 110), 0),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildIconCard(Icons.view_list, 'Permohonan', onTap: () {
                          _navigateWithTransition(context, permohonan());
                        }),
                        _buildIconCard(Icons.home_work, 'Objek Retribusi', onTap: () {
                          _navigateWithTransition(context, RetributionListPage());
                        }),
                        _buildIconCard(Icons.receipt_long, 'Tarif Objek', onTap: () {
                          _navigateWithTransition(context, TarifObjekListPage());
                        }),
                        _buildIconCard(Icons.handshake_outlined, 'Perjanjian', onTap: () {
                          _navigateWithTransition(context, perjanjian());
                        }),
                        _buildIconCard(Icons.credit_card, 'Tagihan', onTap: () {
                          _navigateWithTransition(context, bayar());
                        }),
                        _buildIconCard(Icons.payments, 'Pembayaran', onTap: () {
                          _navigateWithTransition(context, HomePage());
                        }),

                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -90),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ayoo, Jangan lupa membayar kewajiban \nretribusi anda untuk Tapanuli Utara yang \nlebih indah dan bersih',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'assets/img.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Informasi Tagihan',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tagihan anda belum lunas',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                              SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Jumlah Tagihan: ',
                                  style: TextStyle(fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: 'Rp 1.500.000',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Lakukan Pembayaran',
                                      style: TextStyle(fontSize: 14, color: Colors.blue),
                                    ),
                                    Icon(Icons.arrow_right, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Informasi Tagihan',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tagihan bulan :', style: TextStyle(fontSize: 16)),
                                  Text('Januari', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Objek :', style: TextStyle(fontSize: 16)),
                                  Text('Ruko', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Alamat :', style: TextStyle(fontSize: 16)),
                                  Text('Jl. Merdeka No. 10', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Kecamatan :', style: TextStyle(fontSize: 16)),
                                  Text('Siantar', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Kabupaten :', style: TextStyle(fontSize: 16)),
                                  Text('Tapanuli Utara', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildIconCard(IconData icon, String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.red),
          SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }

  void _navigateWithTransition(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Text('This is the profile page'),
      ),
    );
  }
}

