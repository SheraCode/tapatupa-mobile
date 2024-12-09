import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapatupa/user/RetributionListPage.dart';

class FormScreen extends StatefulWidget {
  final String idObjekRetribusi;

  FormScreen({required this.idObjekRetribusi});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    loadRetributionData(widget.idObjekRetribusi);
  }

  Future<void> loadRetributionData(String id) async {
    final response = await http.get(
      Uri.parse('http://tapatupa.manoume.com/api/objek-retribusi-mobile/detail/$id'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        data = responseData['objekRetribusi'] ?? {};

        // Hapus kunci yang tidak ingin ditampilkan
        data.remove('idObjekRetribusi');
        data.remove('idLokasiObjekRetribusi');
        data.remove('idJenisObjekRetribusi');
        data.remove('prov_id');
        data.remove('city_id');
        data.remove('dis_id');
        data.remove('subdis_id');
      });
    } else {
      throw Exception('Failed to load retribution data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Detail Objek Retribusi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RetributionListPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text(
                'Detail Objek Retribusi di Kabupaten Tapanuli Utara',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.keys.map((key) {
                  return _buildTextData(key, data[key] != null ? data[key].toString() : '-');
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}