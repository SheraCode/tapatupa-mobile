import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail_objek_retribusi.dart';

class RetributionListPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchRetributionData() async {
    final response = await http.get(Uri.parse('http://tapatupa.manoume.com/api/objek-retribusi-mobile'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['objekRetribusi']);
    } else {
      throw Exception('Failed to load retribution data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.red.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              color: Colors.red.withOpacity(0.8),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Berikut Daftar Objek Retribusi Sampah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'di Kabupaten Tapanuli Utara',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchRetributionData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  final retributionData = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                      border: TableBorder.all(color: Colors.black38),
                      children: [
                        _buildTableRow(context, 'Objek Retribusi', 'Kecamatan', isHeader: true),
                        ...retributionData.map((data) {
                          final objekRetribusiText = '${data['kodeObjekRetribusi'] ?? '-'} \n ${data['objekRetribusi'] ?? '-'}';
                          return _buildTableRow(
                            context,
                            objekRetribusiText,
                            data['kecamatan'] ?? '-',
                            id: data['idObjekRetribusi'],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, String title, String jenis, {int? id, bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.white : Colors.red.withOpacity(0.3),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jenis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              if (!isHeader)
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormScreen(idObjekRetribusi: id.toString()),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
