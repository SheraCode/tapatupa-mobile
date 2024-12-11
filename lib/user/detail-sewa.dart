import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tapatupa/user/pembayaran.dart';

class detailPerjanjianSewa extends StatefulWidget {
  final int id; // Variabel untuk menerima ID

  detailPerjanjianSewa({required this.id}); // Konstruktor untuk menerima ID

  @override
  _DetailPerjanjianSewaState createState() => _DetailPerjanjianSewaState();
}

class _DetailPerjanjianSewaState extends State<detailPerjanjianSewa> {
  Map<String, dynamic>? _detailPerjanjianSewa;
  List<dynamic>? _tagihanDetail;
  List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    _fetchDetailPerjanjianData();
  }

  Future<void> _fetchDetailPerjanjianData() async {
    try {
      final response = await http.get(
        Uri.parse('http://tapatupa.manoume.com/api/tagihan-mobile/detail/${widget.id}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _detailPerjanjianSewa = data['headTagihanDetail'];
          _tagihanDetail = data['tagihanDetail'];
          _isChecked = List.generate(_tagihanDetail?.length ?? 0, (index) => false);
        });
      } else {
        print('Failed to fetch permohonan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching permohonan data: $e');
    }
  }

  Future<void> _postTagihan() async {
    try {
      final selectedIds = <int>[];
      for (int i = 0; i < _isChecked.length; i++) {
        final detail = _tagihanDetail?[i];
        if (detail == null) {
          print('Error: _tagihanDetail at index $i is null');
          continue;
        }
        final idTagihan = detail['idTagihanSewa'];
        print('Index $i: idTagihan = $idTagihan, Checked = ${_isChecked[i]}');

        if (_isChecked[i] && idTagihan != null) {
          selectedIds.add(idTagihan);
        }
      }


      print('Selected IDs: $selectedIds'); // Debugging selected IDs

      if (selectedIds.isEmpty) {
        print('No selected IDs, showing checkbox dialog');
        _showCheckboxDialog();
        return;
      }
      print('widget.id: ${widget.id}');
      print('selectedIds: $selectedIds');


      final idPerjanjian = _detailPerjanjianSewa?['idPerjanjianSewa'];
      if (idPerjanjian == null) {
        print('Error: idPerjanjian is null');
        return;
      }

      print('idPerjanjian: $idPerjanjian'); // Debugging idPerjanjian

      final uri = Uri.parse('http://tapatupa.manoume.com/api/tagihan-mobile/checkout')
          .replace(queryParameters: {
        'idPerjanjian': idPerjanjian.toString(),
        'DibuatOleh': '2', // Ubah sesuai kebutuhan
        'Status': '13',    // Ubah sesuai kebutuhan
      }).toString() +
          selectedIds.map((id) => '&idTagihan[]=$id').join();

      print('Final URL: $uri'); // Debugging final URL yang dikirim

      final response = await http.post(Uri.parse(uri));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.statusCode == 200) {
          final responseBody = response.body; // Dapatkan respons body
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PembayaranPage(responseBody: responseBody),
            ),
          );
        } else {
          _showErrorDialog(response.body);
        }
      } else {
        _showErrorDialog(response.body);
      }
    } catch (e) {
      print('Error posting data: $e');
      _showErrorDialog('Terjadi kesalahan saat mengirim data.');
    }
  }



  String formatRupiah(num? value) {
    if (value == null) return 'Loading...';
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  num calculateTotalSelected() {
    if (_tagihanDetail == null) return 0;
    num total = 0;
    for (int i = 0; i < _tagihanDetail!.length; i++) {
      if (_isChecked[i]) {
        total += _tagihanDetail![i]['jumlahTagihan'] as num;
      }
    }
    return total;
  }

  void _showCheckboxDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan'),
          content: Text('Anda harus mencentang checkbox pembayaran terlebih dahulu.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Gagal'),
        content: Text('Pembayaran gagal: $errorMessage'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Pastikan background tetap putih
      body: Stack(
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
                            Colors.black.withOpacity(0.5), // Tambahkan overlay hitam
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
                                'assets/miranda.JPG', // Ganti dengan gambar profil
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
                                'Detail Sewa',
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
                    children: [
                      Transform.translate(
                        offset: Offset(0, -10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
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
                                      'Nomor Perjanjian Sewa: ${_detailPerjanjianSewa?['nomorSuratPerjanjian'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(color: Colors.grey[300], thickness: 1),
                                    SizedBox(height: 10),
                                    Text(
                                      'Tanggal Disahkan: \n${_detailPerjanjianSewa?['tanggalDisahkan'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Jangka Waktu: \n${_detailPerjanjianSewa?['durasiSewa'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Pembayaran: \n${formatRupiah(_detailPerjanjianSewa?['jumlahPembayaran'] as num?)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Nama Wajib Retribusi: \n${_detailPerjanjianSewa?['namaWajibRetribusi'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Objek Retribusi: \n${_detailPerjanjianSewa?['kodeObjekRetribusi'] ?? 'Loading...'} - ${_detailPerjanjianSewa?['objekRetribusi'] ?? 'Loading...'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text("Tagihan",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // List Tagihan dengan Checkbox
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _tagihanDetail?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final tagihan = _tagihanDetail![index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: _isChecked[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isChecked[index] = value ?? false;
                                          });
                                        },
                                      ),
                                      title: Text('Pembayaran Ke-${index + 1}'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Nomor Tagihan: ${tagihan['nomorTagihan']}'),
                                          Text('Tanggal Jatuh Tempo: ${tagihan['tanggalJatuhTempo']}'),
                                        ],
                                      ),
                                      trailing: Text(
                                        formatRupiah(tagihan['jumlahTagihan']),
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              // Total Pembayaran di atas
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total: ${formatRupiah(calculateTotalSelected())}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10), // Memberikan jarak antara Total dan tombol Bayar
                              // Tombol Bayar di bawah
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Logika pembayaran

                                      if (_isChecked.contains(true)) {
                                        print('Membayar total: ${calculateTotalSelected()}');
                                        _postTagihan();
                                      } else {
                                        // Jika tidak ada checkbox yang dicentang, tampilkan pop-up
                                        _showCheckboxDialog();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Permohonan'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Tagihan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Pembayaran'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0, // Tetapkan index sesuai kebutuhan
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Navigasikan ke halaman lain jika diperlukan
        },
      ),
    );
  }
}
