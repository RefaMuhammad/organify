import 'dart:convert';
import 'package:http/http.dart' as http;

class GrafikController {
  final String baseUrl = 'https://organify-api-crud-38856081727.asia-southeast2.run.app';

  // Method untuk mengambil data grafik tugas selesai dalam 7 hari
  Future<List<int>> getGrafikTugasSelesai(String uid, String tanggalAwal) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/grafik?uid=$uid&tanggalAwal=$tanggalAwal'),
      );

      print('API Response: ${response.statusCode}'); // Debugging
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print('API Response Body: $responseBody'); // Debugging

        // Asumsikan API mengembalikan data dalam bentuk list tugas per hari
        List<int> tugasPerHari = List<int>.from(responseBody['tugasPerHari']);
        return tugasPerHari;
      } else {
        throw Exception('Failed to load grafik data');
      }
    } catch (e) {
      print('Error fetching grafik data: $e'); // Debugging
      throw e;
    }
  }
}