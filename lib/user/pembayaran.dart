import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tapatupa/user/upload-bukti-bayar.dart'; // Untuk format tanggal dan waktu

class PembayaranPage extends StatefulWidget {
  final String responseBody;

  PembayaranPage({required this.responseBody}) {
    print(responseBody);
  }

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late DateTime _waktuSekarang;
  late DateTime _waktuJatuhTempo;
  late String _formattedWaktuJatuhTempo;
  late String _formattedTotalBayar;
  late String _kodeBilling;
  late Timer _timer;
  late int _totalBayar;
  late String _formattedSisaWaktu;

  late String _nomorTagihan;
  late DateTime _tanggalJatuhTempo;
  late String _formattedTanggalJatuhTempo;
  late int _jumlahTagihan;

  @override
  void initState() {
    super.initState();

    // Parsing JSON dari responseBody
    Map<String, dynamic> data = jsonDecode(widget.responseBody);
    var headPembayaran = data['headPembayaran'];
    _totalBayar = headPembayaran['totalBayar'];
    _kodeBilling = headPembayaran['kodeBilling'];

    // Format totalBayar ke format yang lebih mudah dibaca
    _formattedTotalBayar = 'Rp${_totalBayar.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';

    // Mengambil data dari detailPembayaran
    var detailPembayaran = data['detailPembayaran'][0];
    _nomorTagihan = detailPembayaran['nomorTagihan'];
    _jumlahTagihan = detailPembayaran['jumlahTagihan'];
    _tanggalJatuhTempo = DateTime.parse(detailPembayaran['tanggalJatuhTempo']);
    _formattedTanggalJatuhTempo = DateFormat('dd MMM yyyy').format(_tanggalJatuhTempo);

    // Menghitung waktu jatuh tempo (7 hari dari sekarang)
    _waktuSekarang = DateTime.now();
    _waktuJatuhTempo = _waktuSekarang.add(Duration(days: 7));
    _formattedWaktuJatuhTempo = DateFormat('dd MMM yyyy, HH:mm').format(_waktuJatuhTempo);

    // Inisialisasi awal _formattedSisaWaktu
    Duration initialRemainingTime = _waktuJatuhTempo.difference(_waktuSekarang);
    _formattedSisaWaktu = initialRemainingTime.isNegative
        ? 'Waktu telah habis'
        : _formatDuration(initialRemainingTime);

    // Mulai timer untuk menghitung waktu yang berjalan
    _startCountdown();
  }


  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        Duration remainingTime = _waktuJatuhTempo.difference(DateTime.now());

        if (remainingTime.isNegative) {
          _formattedSisaWaktu = 'Waktu telah habis';
        } else {
          _formattedSisaWaktu = _formatDuration(remainingTime);
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String days = duration.inDays.toString().padLeft(2, '0');
    String hours = (duration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$days hari $hours jam $minutes menit $seconds detik';
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
          },
        ),
        title: Text('Pembayaran', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _formattedTotalBayar,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bayar Dalam',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _formattedSisaWaktu,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Jatuh tempo $_formattedWaktuJatuhTempo',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              Divider(height: 32, thickness: 1),
              Row(
                children: [
                  Image.asset('assets/img.png', width: 40, height: 40),
                  SizedBox(width: 8),
                  Text(
                    'TAPATUPA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'No. Billing',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1256.2.23.1.$_kodeBilling',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Salin kode billing ke clipboard
                      Clipboard.setData(ClipboardData(text: _kodeBilling));

                      // Tampilkan SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Kode Billing disalin ke clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'Salin',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Silahkan menunggu proses verifikasi yang akan di lakukan oleh petugas untuk memastikan proses pembayaran telah selesai',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
              SizedBox(height: 8),
              Text(
                'Penting: Pastikan kamu mentransfer ke kode Billing di atas',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),

              Divider(height: 32, thickness: 1),
              Text(
                'Petunjuk Transfer Kode Billing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('1. Pilih Transfer > Virtual Account Billing.'),
              SizedBox(height: 8),
              Text(
                '2. Pilih Rekening Debit > Masukkan nomor Virtual Account $_kodeBilling pada menu Input Baru.',
              ),
              SizedBox(height: 8),
              Text(
                '3. Tagihan yang harus dibayar akan muncul pada layar konfirmasi.',
              ),
              SizedBox(height: 8),
              Text(
                '4. Periksa informasi yang tertera di layar. Pastikan nama penerima adalah TAPATUPA. Jika sudah sesuai, masukkan password transaksi dan pilih Lanjut.',
              ),
              SizedBox(height: 16),
              Text(
                'Catatan: Pastikan melakukan transfer ke nomor Billing yang tertera di atas. Kamu dapat menggunakan bank apapun yang kamu pilih, seperti BCA, Mandiri, BNI, atau lainnya. Pastikan transfer dilakukan ke nomor Billing yang sesuai.',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Divider(height: 32, thickness: 1),

              // Menampilkan Detail Pembayaran
              Text(
                'Detail Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No. Tagihan',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _nomorTagihan,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jumlah Tagihan',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Rp${_jumlahTagihan.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jatuh Tempo',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _formattedTanggalJatuhTempo,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadBuktiPage(responseBodys: widget.responseBody)),
                  );
                },
                child: Text('Upload Bukti Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
