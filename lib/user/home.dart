import 'package:flutter/material.dart';
import 'login.dart';
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat datang di halaman Home!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Menutup aplikasi ketika tombol ditekan
                // Menggunakan pop untuk kembali ke halaman sebelumnya
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              child: Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna latar belakang tombol
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Ukuran padding tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
