import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapatupa/user/login.dart';
import 'package:tapatupa/user/profile_edit.dart';

class profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<profile> {
  String _namaLengkap = '';
  String _fotoUser = '';
  int _roleId = 0;
  int _idPersonal = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaLengkap = prefs.getString('namaLengkap') ?? 'Nama tidak ditemukan';
      _fotoUser = prefs.getString('fotoUser') ?? '';
      _roleId = prefs.getInt('roleId') ?? 0;
      _idPersonal = prefs.getInt('idPersonal') ?? 0; // Memuat idPersonal
    });

    // Mencetak semua data ke konsol
    print('Nama Lengkap: $_namaLengkap');
    print('Foto User: $_fotoUser');
    print('Role ID: $_roleId');
    print('ID Personal: $_idPersonal');
  }

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
                        title: Text(_namaLengkap, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
                        title: Text('-', style: TextStyle(color: Colors.black)),
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card, color: Colors.black38),
                        title: Text('-', style: TextStyle(color: Colors.black)),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.black38),
                        title: Text('-', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
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
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text(
                    'Keluar',
                    style: TextStyle(color: Colors.red),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    // Hapus sesi dan arahkan ke halaman login
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); // Menghapus semua data dalam SharedPreferences

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                          (route) => false,
                    );
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
