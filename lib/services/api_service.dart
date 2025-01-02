import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/catatan.dart'; // Impor model Catatan
import '../models/kategori.dart'; // Impor model Kategori

class ApiService {
  static const String baseUrl = 'https://organify-api-crud-38856081727.asia-southeast2.run.app';

  // Fungsi untuk mengambil data catatan dan menghitung jumlah tugas
  Future<Map<String, int>> countTasks(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid'));

    if (response.statusCode == 200) {
      // Cetak respons JSON ke konsol
      print('API Response: ${response.body}');

      // Parse JSON
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];

      // Konversi ke list Catatan
      List<Catatan> catatanList = data.map((json) => Catatan.fromJson(json)).toList();

      // Hitung jumlah tugas selesai dan tertunda
      int tugasSelesai = catatanList.where((catatan) => catatan.status == true).length;
      int tugasTertunda = catatanList.where((catatan) => catatan.status == false).length;

      // Kembalikan hasil dalam bentuk Map
      return {
        'tugasSelesai': tugasSelesai,
        'tugasTertunda': tugasTertunda,
      };
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCatatan7HariKeDepan(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];

      DateTime now = DateTime.now();
      DateTime sevenDaysLater = now.add(Duration(days: 7));

      // Filter tugas yang deadline-nya dalam 7 hari ke depan
      List<Map<String, dynamic>> filteredData = data.where((catatan) {
        DateTime deadline = DateTime.parse(catatan['tanggalDeadline']);
        return deadline.isAfter(now) && deadline.isBefore(sevenDaysLater);
      }).map((catatan) => catatan as Map<String, dynamic>).toList(); // Konversi ke List<Map<String, dynamic>>

      return filteredData;
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  // Fungsi untuk mengambil data kategori
  Future<List<Kategori>> fetchKategori(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/kategori?uid=$uid'));

    if (response.statusCode == 200) {
      // Parse JSON
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];

      // Konversi ke list Kategori
      return data.map((json) => Kategori.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data kategori');
    }
  }

  // Fungsi untuk membuat kategori baru
  Future<void> createKategori(String uid, String kategori) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kategori'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "uid": uid,
        "kategori": kategori,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal membuat kategori');
    }
  }

  // Fungsi untuk membuat catatan baru
  Future<void> createCatatan(
      String uid,
      String kategori,
      String namaList,
      String tanggalDeadline,
      bool status,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/catatan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "uid": uid,
        "kategori": kategori,
        "namaList": namaList,
        "tanggalDeadline": tanggalDeadline,
        "status": status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal membuat catatan');
    }
  }

  Future<List<Catatan>> fetchCatatan(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];
      return data.map((json) => Catatan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data catatan');
    }
  }

  // Fungsi untuk mengambil satu catatan berdasarkan ID
  Future<Catatan> getCatatanById(String uid, String id) async {
    final response = await http.get(Uri.parse('$baseUrl/catatan/$uid/$id'));

    if (response.statusCode == 200) {
      // Parse JSON
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Catatan.fromJson(jsonData['data']);
    } else {
      throw Exception('Gagal memuat catatan');
    }
  }

  // Fungsi untuk memperbarui catatan
  Future<void> updateCatatan(
      String uid,
      String id,
      String kategori,
      String namaList,
      String tanggalDeadline,
      bool status,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/catatan/$uid/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "kategori": kategori,
        "namaList": namaList,
        "tanggalDeadline": tanggalDeadline,
        "status": status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui catatan');
    }
  }

  // Fungsi untuk menghapus catatan
  Future<void> deleteCatatan(String uid, String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/catatan/$uid/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus catatan');
    }
  }

  Future<String> getTodoItem(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/todo-item/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData['message']; // Sesuaikan dengan struktur respons API
    } else {
      throw Exception('Gagal memuat TodoItem');
    }
  }

  Future<void> tambahTodoItem(String id, String judul, String catatan) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todo-item/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "judul": judul,
        "catatan": catatan,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan TodoItem');
    }
  }
}