import 'package:flutter/material.dart';
import 'home.dart'; // Import halaman home
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'; // Pastikan mengimpor AwesomeSnackbarContent

class login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackbar(String title, String message, ContentType contentType) {
    var snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 155), // Menempatkan snackbar di atas layar
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _login() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Memeriksa apakah username dan password kosong
    if (username.isEmpty || password.isEmpty) {
      _showSnackbar("Gagal", "Email Atau Password Harus Diisi", ContentType.failure);
      return; // Keluar dari fungsi jika ada field yang kosong
    }

    // Memeriksa username dan password
    if (username == 'super admin' && password == 'super1234') {
      // Jika benar, arahkan ke halaman home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()),
      );
      _showSnackbar("Benar", "Anda berhasil login", ContentType.success);
    } else {
      // Jika salah, tampilkan pesan error
      _showSnackbar("Gagal", "Username atau password salah", ContentType.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/tapatupa.JPG', // Gambar yang akan ditampilkan
                  width: 200, // Ukuran gambar
                  height: 200,
                ),
                SizedBox(height: 20), // Jarak antara gambar dan field input
                TextField(
                  controller: _usernameController, // Menggunakan controller
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16), // Jarak antara field input
                TextField(
                  controller: _passwordController, // Menggunakan controller
                  obscureText: true, // Agar password tidak terlihat
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20), // Jarak antara field input dan tombol
                SizedBox(
                  width: double.infinity, // Tombol login akan memenuhi lebar
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent], // Warna gradien merah
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Sudut melengkung
                    ),
                    child: TextButton(
                      onPressed: _login, // Memanggil fungsi _login saat tombol ditekan
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white), // Warna teks
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
