import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadBuktiPage extends StatefulWidget {
  @override
  _UploadBuktiPageState createState() => _UploadBuktiPageState();
}

class _UploadBuktiPageState extends State<UploadBuktiPage> {
  final TextEditingController _namaBankController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _jumlahDanaController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  File? _image;

  // Fungsi untuk memilih gambar dari gallery atau kamera
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Bukti Bayar', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black38,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Bank
            _buildTextField(
              label: 'Nama Bank Asal',
              controller: _namaBankController,
              hintText: 'Masukkan Nama Bank',
            ),
            SizedBox(height: 16),

            // Nama Pemilik Rekening
            _buildTextField(
              label: 'Nama Pemilik Rekening',
              controller: _namaPemilikController,
              hintText: 'Masukkan Nama Pemilik Rekening',
            ),
            SizedBox(height: 16),

            // Jumlah Dana
            _buildTextField(
              label: 'Jumlah Dana',
              controller: _jumlahDanaController,
              hintText: 'Masukkan Jumlah Dana',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Keterangan
            _buildTextField(
              label: 'Keterangan',
              controller: _keteranganController,
              hintText: 'Masukkan Keterangan',
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Upload Bukti Bayar
            _buildImagePickerSection(),
            SizedBox(height: 16),

            // Menampilkan gambar jika ada
            if (_image != null) ...[
              Text('Bukti Bayar:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Image.file(
                _image!,
                width: double.infinity,
                height: 550,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
            ],

            // Tombol Kirim
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Proses pengiriman data (misalnya upload ke server)
                  // Di sini Anda bisa menambahkan logika pengiriman data
                },
                child: Text('Kirim'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Bukti Bayar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pilih dari Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Ambil dengan Kamera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
