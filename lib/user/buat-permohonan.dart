import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Pastikan mengimpor AwesomeSnackbarContent


class FormulirPermohonan extends StatefulWidget {
  @override
  _FormulirPermohonanState createState() => _FormulirPermohonanState();
}

class _FormulirPermohonanState extends State<FormulirPermohonan> {
  String? wajibRetribusiSebelumnya;
  bool showWajibRetribusiSebelumnya = false;

  List<Map<String, dynamic>> documents = [];
  List<Map<String, dynamic>> jenisPermohonanOptions = [];
  List<Map<String, dynamic>> objekRetribusiOptions = [];
  List<Map<String, dynamic>> objekWajibRetribusiOptions = [];
  List<Map<String, dynamic>> perioditasOptions = [];
  List<Map<String, dynamic>> peruntukanSewaOptions = [];
  List<Map<String, dynamic>> satuanOptions = [];
  List<Map<String, dynamic>> dokumenKelengkapanOptions = [];

  final TextEditingController catatanController = TextEditingController();
  final TextEditingController lamaSewaController = TextEditingController();

  String? selectedJenisPermohonan;
  String? selectedObjekRetribusi;
  String? selectedPerioditas;
  String? selectedPeruntukanSewa;
  String? selectedWajibRetribusi;
  String? selectedSatuan;
  String nomorPermohonan = Random().nextInt(999999999).toString();
  String wajibRetribusi = "1";
  String? selectedDokumenKelengkapan; // Untuk menyimpan idDokumenKelengkapan yang dipilih


  @override
  void initState() {
    super.initState();
    fetchJenisPermohonan();
    fetchObjekRetribusi();
    fetchPerioditas();
    fetchPeruntukanSewa();
    fetchWajibRetribusi();
    fetchSatuan();
    fetchDokumenKelengkapan();
    _loadUserData();
  }

  String _namaLengkap = '';
  String _fotoUser = '';
  int _roleId = 0;
  int _idPersonal = 0;


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

  Future<void> fetchJenisPermohonan() async {
    try {
      final response = await http.get(
          Uri.parse('http://tapatupa.manoume.com/api/combo-jenis-permohonan'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          jenisPermohonanOptions =
          List<Map<String, dynamic>>.from(data['jenisPermohonan']);
        });
      } else {
        print('Failed to load jenis permohonan');
      }
    } catch (e) {
      print('Error fetching jenis permohonan: $e');
    }
  }

  Future<void> fetchDokumenKelengkapan() async {
    try {
      final response = await http.get(Uri.parse(
          'http://tapatupa.manoume.com/api/combo-dokumen-kelengkapan'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dokumenKelengkapanOptions =
          List<Map<String, dynamic>>.from(data['dokumen']);
          print(dokumenKelengkapanOptions);
        });
      } else {
        print('Failed to load dokumen kelengkapan');
      }
    } catch (e) {
      print('Error fetching dokumen kelengkapan: $e');
    }
  }


  Future<void> submitPermohonan() async {
    var uri = Uri.parse(
        'http://tapatupa.manoume.com/api/permohonan-mobile/simpan');
    var request = http.MultipartRequest('POST', uri);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idPersonal = prefs.getInt('idPersonal') ?? 0;

    SharedPreferences prefs_id = await SharedPreferences.getInstance();
    int idUser = prefs_id.getInt('id') ?? 0;


    // Adding form fields
    request.fields['jenisPermohonan'] = selectedJenisPermohonan ?? '';
    request.fields['nomorPermohonan'] = nomorPermohonan;
    request.fields['wajibRetribusi'] = idPersonal.toString();
    request.fields['dibuatOleh'] = idUser.toString();
    request.fields['objekRetribusi'] = selectedObjekRetribusi ?? '';
    request.fields['perioditas'] = selectedPerioditas ?? '';
    request.fields['peruntukanSewa'] = selectedPeruntukanSewa ?? '';
    // request.fields['lamaSewa'] = '5'; // Example, make this dynamic if needed
    request.fields['lamaSewa'] = lamaSewaController.text.isNotEmpty
        ? lamaSewaController.text
        : '0'; // Default 0 jika input kosong
    request.fields['satuan'] = selectedSatuan ?? '';
    request.fields['catatan'] =
    catatanController.text.isEmpty ? '-' : catatanController.text;

    // Mengirimkan wajibRetribusi jika ada pilihan di dropdown
    if (selectedWajibRetribusi != null && selectedWajibRetribusi!.isNotEmpty) {
      request.fields['WajibRetribusiSebelumnya'] = selectedWajibRetribusi!;
    }

    // Adding documents as array
    for (var i = 0; i < documents.length; i++) {
      request.fields['jenisDokumen[$i]'] = documents[i]['name'];
      request.fields['keteranganDokumen[$i]'] = documents[i]['description'];
      if (documents[i]['filePath'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'fileDokumen[$i]',
          documents[i]['filePath'],
        ));
      }
    }

    try {
      print('Sending request to: $uri');
      print('Request body: ${request.fields}');
      var response = await request.send();
      print('Response status code: ${response.statusCode}');
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        print('Permohonan submitted successfully');
        _showSnackbar(
            'Berhasil', 'Permohonan Anda telah terkirim', ContentType.success);
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      } else {
        print('Failed to submit permohonan: ${response.statusCode}');
        _showSnackbar('Gagal', 'Terjadi kesalahan saat mengirim permohonan',
            ContentType.failure);
      }
    } catch (e) {
      print('Error submitting permohonan: $e');
      _showSnackbar('Gagal', 'Terjadi kesalahan saat mengirim permohonan',
          ContentType.failure);
    }
  }


  void _showSnackbar(String title, String message, ContentType contentType) {
    var snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .size
          .height - 200),
      // Menempatkan snackbar di atas layar
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


  Future<void> fetchSatuan() async {
    try {
      final response = await http.get(
          Uri.parse('http://tapatupa.manoume.com/api/combo-satuan'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          satuanOptions = List<Map<String, dynamic>>.from(data['satuan']);
        });
      } else {
        print('Failed to load jenis permohonan');
      }
    } catch (e) {
      print('Error fetching jenis permohonan: $e');
    }
  }

  Future<void> fetchPeruntukanSewa() async {
    try {
      final response = await http.get(
          Uri.parse('http://tapatupa.manoume.com/api/combo-peruntukan-sewa'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          peruntukanSewaOptions =
          List<Map<String, dynamic>>.from(data['peruntukanSewa']);
        });
      } else {
        print('Failed to load jenis permohonan');
      }
    } catch (e) {
      print('Error fetching jenis permohonan: $e');
    }
  }

  Future<void> fetchPerioditas() async {
    try {
      final response = await http.get(
          Uri.parse('http://tapatupa.manoume.com/api/combo-perioditas'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          perioditasOptions =
          List<Map<String, dynamic>>.from(data['jangkaWaktu']);
        });
      } else {
        print('Failed to load perioditas');
      }
    } catch (e) {
      print('Error fetching perioditas: $e');
    }
  }


  Future<void> fetchObjekRetribusi() async {
    try {
      final response = await http.get(
          Uri.parse('http://tapatupa.manoume.com/api/combo-objek-retribusi'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          objekRetribusiOptions =
          List<Map<String, dynamic>>.from(data['objekRetribusi']);
        });
      } else {
        print('Failed to load objek retribusi');
      }
    } catch (e) {
      print('Error fetching objek retribusi: $e');
    }
  }

  Future<void> fetchWajibRetribusi() async {
    try {
      final response = await http.get(
          Uri.parse('http://tapatupa.manoume.com/api/combo-wajib-retribusi'));

      // Cetak status kode dan isi respons ke konsol
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log struktur data untuk memastikan isinya benar
        print('Decoded Data: $data');

        if (data['wajibRetribusi'] != null && data['wajibRetribusi'] is List) {
          setState(() {
            objekWajibRetribusiOptions =
            List<Map<String, dynamic>>.from(data['wajibRetribusi']);
          });
          print('Options Loaded: $objekWajibRetribusiOptions');
        } else {
          print('Data wajibRetribusi tidak ditemukan atau bukan list');
        }
      } else {
        print('Failed to load objek retribusi. Status Code: ${response
            .statusCode}');
      }
    } catch (e) {
      print('Error fetching objek retribusi: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Permohonan'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Formulir Permohonan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _buildJenisPermohonanDropdown(),
              SizedBox(height: 16),
              _buildWajibRetribusiDropdown(),
              SizedBox(height: 16),
              _buildObjekRetribusiDropdown(),
              SizedBox(height: 16),
              _buildJenisPeruntukanSewaDropdown(),
              SizedBox(height: 16),
              _buildPerioditasDropdown(),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Lama Sewa',
                isNumeric: true,
                controller: lamaSewaController,
              ),
              SizedBox(height: 16),
              _buildSatuanDropdown(),
              SizedBox(height: 16),
              TextField(
                controller: catatanController,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addDocumentField,
                icon: Icon(Icons.add),
                label: Text('Tambah Dokumen Kelengkapan'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              SizedBox(height: 20),
              Column(children: documents.map((doc) => _buildDocumentField(doc))
                  .toList()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitPermohonan,
                child: Text('Kirim Permohonan'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool isNumeric = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }


  Widget _buildJenisPermohonanDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Jenis Permohonan',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedJenisPermohonan,
      items: jenisPermohonanOptions.map((item) {
        return DropdownMenuItem<String>(
          value: item['idJenisPermohonan'].toString(),
          child: Text(item['jenisPermohonan']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedJenisPermohonan = value;
          showWajibRetribusiSebelumnya =
          (value == "4"); // Tampilkan jika id = 4
        });
      },
    );
  }

  Widget _buildWajibRetribusiSebelumnyaField() {
    return Visibility(
      visible: showWajibRetribusiSebelumnya,
      child: TextField(
        onChanged: (value) {
          wajibRetribusiSebelumnya = value;
        },
        decoration: InputDecoration(
          labelText: 'Wajib Retribusi Sebelumnya',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildPerioditasDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Perioditas',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedPerioditas,
      items: perioditasOptions.map((item) {
        return DropdownMenuItem<String>(
          value: item['idjenisJangkaWaktu'].toString(),
          child: Text(item['jenisJangkaWaktu']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedPerioditas = value;
          print(selectedPerioditas);
        });
      },
    );
  }

  Widget _buildJenisPeruntukanSewaDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Jenis Peruntukan Sewa',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedPeruntukanSewa,
      items: peruntukanSewaOptions.map((item) {
        return DropdownMenuItem<String>(
          value: item['idperuntukanSewa'].toString(),
          child: Text(item['peruntukanSewa']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedPeruntukanSewa = value;
          print(selectedPeruntukanSewa);
        });
      },
    );
  }

  Widget _buildSatuanDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Satuan',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedSatuan,
      items: satuanOptions.map((item) {
        return DropdownMenuItem<String>(
          value: item['idSatuan'].toString(),
          child: Text(item['namaSatuan']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedSatuan = value;
          print(selectedSatuan);
        });
      },
    );
  }

  Widget _buildObjekRetribusiDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Objek Retribusi',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedObjekRetribusi,
      items: objekRetribusiOptions.map((item) {
        return DropdownMenuItem<String>(
          value: item['idObjekRetribusi'].toString(),
          child: Text(
              '${item['objekRetribusi']} - ${item['kodeObjekRetribusi']}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedObjekRetribusi = value;
          print(selectedObjekRetribusi);
        });
      },
    );
  }

  Widget _buildWajibRetribusiDropdown() {
    return Visibility(
      visible: showWajibRetribusiSebelumnya, // Atur visibilitas dropdown
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Nama Wajib Retribusi',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        ),
        isExpanded: true,
        // Menghindari overflow
        value: selectedWajibRetribusi,
        items: objekWajibRetribusiOptions.map((item) {
          return DropdownMenuItem<String>(
            value: item['idWajibRetribusi'].toString(),
            child: Text('${item['namaWajibRetribusi']}'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedWajibRetribusi = value;
            print(selectedWajibRetribusi);
          });
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: value,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }


  void _addDocumentField() {
    setState(() {
      documents.add({
        'name': '',
        'description': '',
        'filePath': '',
      });
    });
  }

  Widget _buildDocumentField(Map<String, dynamic> doc) {
    int index = documents.indexOf(doc);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Dokumen ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) => setState(() => doc['name'] = value),
            decoration: InputDecoration(
              labelText: 'Nama Dokumen Kelengkapan',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) => setState(() => doc['description'] = value),
            decoration: InputDecoration(
              labelText: 'Keterangan',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                String? filePath = result.files.single.path;
                setState(() {
                  doc['filePath'] = filePath;
                });
              }
            },
            icon: Icon(Icons.upload_file),
            label: Text(doc['filePath'] != null ? 'Dokumen Terunggah' : 'Upload Dokumen'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}


  // Widget _buildDocumentField(Map<String, dynamic> doc) {
  //   int index = documents.indexOf(doc);
  //
  //   // Fetch dokumen options
  //   Future<List<Map<String, dynamic>>> fetchDokumenKelengkapan() async {
  //     try {
  //       final response = await http.get(Uri.parse(
  //           'http://tapatupa.manoume.com/api/combo-dokumen-kelengkapan'));
  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         return List<Map<String, dynamic>>.from(data['dokumen']);
  //       } else {
  //         print('Failed to load dokumen kelengkapan');
  //         return [];
  //       }
  //     } catch (e) {
  //       print('Error fetching dokumen kelengkapan: $e');
  //       return [];
  //     }
  //   }
  //
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Text(
  //           'Dokumen ${index + 1}',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //         SizedBox(height: 8),
  //         FutureBuilder<List<Map<String, dynamic>>>(
  //           future: fetchDokumenKelengkapan(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return Center(child: CircularProgressIndicator());
  //             } else if (snapshot.hasError || !snapshot.hasData ||
  //                 snapshot.data!.isEmpty) {
  //               return Text('Gagal memuat opsi dokumen kelengkapan');
  //             } else {
  //               return DropdownButtonFormField<String>(
  //                 value: doc['idDokumenKelengkapan']?.toString(),
  //                 onChanged: (value) =>
  //                     setState(() => doc['name'] = value),
  //                 items: snapshot.data!.map((option) {
  //                   return DropdownMenuItem<String>(
  //                     value: option['idDokumenKelengkapan'].toString(),
  //                     child: Text(option['dokumenKelengkapan']),
  //                   );
  //                 }).toList(),
  //                 decoration: InputDecoration(
  //                   labelText: 'Nama Dokumen Kelengkapan',
  //                   border: OutlineInputBorder(),
  //                   contentPadding: EdgeInsets.symmetric(
  //                       horizontal: 16, vertical: 12),
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //         SizedBox(height: 8),
  //         TextField(
  //           onChanged: (value) => setState(() => doc['description'] = value),
  //           decoration: InputDecoration(
  //             labelText: 'Keterangan',
  //             border: OutlineInputBorder(),
  //             contentPadding: EdgeInsets.symmetric(
  //                 horizontal: 16, vertical: 12),
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         ElevatedButton.icon(
  //           onPressed: () async {
  //             FilePickerResult? result = await FilePicker.platform.pickFiles();
  //             if (result != null) {
  //               String? filePath = result.files.single.path;
  //               setState(() {
  //                 doc['filePath'] = filePath;
  //               });
  //             }
  //           },
  //           icon: Icon(Icons.upload_file),
  //           label: Text(doc['filePath'] != null
  //               ? 'Dokumen Terunggah'
  //               : 'Upload Dokumen'),
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //

