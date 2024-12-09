import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapatupa/user/RetributionListPage.dart';
import 'package:tapatupa/user/tarif-objek.dart';

class DetailTarif extends StatefulWidget {
  final String idObjekRetribusi;

  DetailTarif({required this.idObjekRetribusi});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<DetailTarif> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    loadRetributionData(widget.idObjekRetribusi);
  }

  Future<void> loadRetributionData(String id) async {
    final response = await http.get(
      Uri.parse('http://tapatupa.manoume.com/api/objek-retribusi-mobile/detail-tarif/$id'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final filteredData = Map<String, dynamic>.from(responseData['tarifObjekRetribusi']);

      // Remove the specified keys
      final keysToRemove = [
        'idTarifObjekRetribusi',
        'idObjekRetribusi',
        'idLokasiObjekRetribusi',
        'idJenisObjekRetribusi',
        'subdis_id',
        'fileName',
        'idJenisJangkawaktu'
      ];
      keysToRemove.forEach(filteredData.remove);

      setState(() {
        data = filteredData;
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
          'Detail Tarif Objek Retribusi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TarifObjekListPage()),
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
                'Detail Tarif Objek Retribusi di Kabupaten Tapanuli Utara',
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
                  return _buildTextData(key, data[key]?.toString() ?? '-');
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
