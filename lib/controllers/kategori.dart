import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:organify/models/kategori.dart'; // Import model Kategori

class KategoriController {
  final String baseUrl = 'https://organify-api-crud-38856081727.asia-southeast2.run.app';

  // Method untuk mengambil semua kategori berdasarkan UID
  Future<List<Kategori>> getKategori(String uid) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kategori?uid=$uid'));
      print('API Response: ${response.statusCode}'); // Debugging
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print('API Response Body: $responseBody'); // Debugging
        List<dynamic> data = responseBody['data']; // Akses key 'data'

        // Pastikan data tidak null sebelum diproses
        if (data != null) {
          // Tambahkan uid ke setiap kategori
          return data.map((json) {
            json['uid'] = uid; // Tambahkan uid ke JSON
            return Kategori.fromJson(json);
          }).toList();
        } else {
          throw Exception('Data is null');
        }
      } else {
        throw Exception('Failed to load kategori');
      }
    } catch (e) {
      print('Error fetching kategori: $e'); // Debugging
      throw e;
    }
  }

  // Method untuk membuat kategori baru
  Future<void> createKategori(String uid, String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kategori'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uid': uid,
          'kategori': nama,
        }),
      );
      print('API Response: ${response.statusCode}'); // Debugging
      if (response.statusCode == 201) {
        print('Kategori berhasil dibuat');
      } else {
        throw Exception('Failed to create kategori');
      }
    } catch (e) {
      print('Error creating kategori: $e'); // Debugging
      throw e;
    }
  }
}