import 'package:flutter/material.dart';
import 'package:tapatupa/user/profile_edit.dart';


class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle, size: 40, color: Colors.black38),
                        title: Text('Miranda', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        subtitle: Text('Kantor', style: TextStyle(color: Colors.black)),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => profile_edit()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 4),
                              Text('Edit', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.black38),
                        title: Text('081377060672', style: TextStyle(color: Colors.black)),
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card, color: Colors.black38),
                        title: Text('1212394053374739', style: TextStyle(color: Colors.black)),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.black38),
                        title: Text('Gedung Fairgrounds Lt 5-10, JL SCBD No 126, Jakarta Selatan', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Margin untuk memberi jarak antar container
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar belakang putih
                  borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow dengan sedikit transparansi
                      spreadRadius: 2, // Radius penyebaran shadow
                      blurRadius: 5, // Radius blur shadow
                      offset: Offset(0, 3), // Posisi shadow, (x, y)
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.lock, color: Colors.black38),
                  title: Text('Ganti Kata Sandi'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Aksi untuk mengganti kata sandi
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Jarak dari sisi kiri/kanan dan atas/bawah
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar belakang putih
                  borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Warna shadow dengan transparansi
                      spreadRadius: 2, // Radius penyebaran shadow
                      blurRadius: 5, // Radius blur shadow
                      offset: Offset(0, 3), // Posisi shadow, (x, y)
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red), // Ikon berwarna merah
                  title: Text(
                    'Keluar',
                    style: TextStyle(color: Colors.red), // Teks berwarna merah
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Aksi untuk keluar dari akun

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
