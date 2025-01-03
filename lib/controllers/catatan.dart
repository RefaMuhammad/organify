import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:organify/models/catatan.dart';
import 'package:organify/models/todo_item.dart'; // Import model

class CatatanController {
  final String baseUrl = 'https://organify-api-crud-38856081727.asia-southeast2.run.app';

  // Method untuk mengambil semua catatan berdasarkan UID
  Future<List<Catatan>> getCatatans(String uid) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid'));
      print('API Response: ${response.statusCode}'); // Debugging
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print('API Response Body: $responseBody'); // Debugging
        List<dynamic> data = responseBody['data']; // Akses key 'data'
        return data.map((json) => Catatan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load catatans');
      }
    } catch (e) {
      print('Error fetching catatans: $e'); // Debugging
      throw e;
    }
  }

  // Method untuk mengambil todoItem dari catatan tertentu
  Future<TodoItem?> getTodoItem(String uid, String idCatatan) async {
    try {
      final catatans = await getCatatans(uid);
      final catatan = catatans.firstWhere((catatan) => catatan.id == idCatatan);
      return catatan.todoItem; // Ambil todoItem dari catatan
    } catch (e) {
      print('Error fetching todoItem: $e');
      return null;
    }
  }

  // Method untuk menghapus catatan
  Future<void> deleteCatatan(String uid, String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/catatan/$uid/$id'),
      );

      if (response.statusCode == 200) {
        print('Catatan berhasil dihapus'); // Debugging
      } else {
        throw Exception('Gagal menghapus catatan: ${response.body}');
      }
    } catch (e) {
      print('Error deleting catatan: $e'); // Debugging
      throw e;
    }
  }

  // Method untuk mengupdate status catatan
  Future<void> updateStatusCatatan(String uid, String id, bool status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/catatan/$uid/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        print('Status catatan berhasil diupdate'); // Debugging
      } else {
        throw Exception('Gagal mengupdate status catatan: ${response.body}');
      }
    } catch (e) {
      print('Error updating status catatan: $e'); // Debugging
      throw e;
    }
  }

  // Method untuk memfilter catatan berdasarkan tanggalDeadline
  Future<Map<String, List<Catatan>>> getFilteredCatatans(String uid) async {
    // Ambil semua catatan
    List<Catatan> catatans = await getCatatans(uid);

    // Filter catatan yang statusnya false (belum selesai)
    List<Catatan> unfinishedCatatans = catatans.where((catatan) => catatan.status == false).toList();

    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day); // Mulai hari ini (00:00:00)
    DateTime todayEnd = todayStart.add(Duration(days: 1)); // Akhir hari ini (23:59:59)

    List<Catatan> sebelumnya = [];
    List<Catatan> hariIni = [];
    List<Catatan> yangAkanDatang = [];

    // Kelompokkan catatan yang belum selesai berdasarkan tanggal deadline
    for (var catatan in unfinishedCatatans) {
      DateTime deadline = DateTime.parse(catatan.tanggalDeadline);
      if (deadline.isBefore(todayStart)) {
        sebelumnya.add(catatan);
      } else if (deadline.isAtSameMomentAs(todayStart) ||
          (deadline.isAfter(todayStart) && deadline.isBefore(todayEnd))) {
        hariIni.add(catatan);
      } else if (deadline.isAfter(todayEnd)) {
        yangAkanDatang.add(catatan);
      }
    }

    return {
      'sebelumnya': sebelumnya,
      'hariIni': hariIni,
      'yangAkanDatang': yangAkanDatang,
    };
  }

  // Method untuk menghitung tugas selesai dan tertunda
  Future<Map<String, int>> getTaskSummary(String uid) async {
    List<Catatan> catatans = await getCatatans(uid);
    print('Total Catatans: ${catatans.length}'); // Debugging
    print('Catatans: $catatans'); // Debugging

    int completedTasks = catatans.where((catatan) => catatan.status == true).length;
    int pendingTasks = catatans.where((catatan) => catatan.status == false).length;

    print('Completed Tasks: $completedTasks'); // Debugging
    print('Pending Tasks: $pendingTasks'); // Debugging

    return {
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
    };
  }

  Future<List<Catatan>> getTasksWithin7Days(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];

      // Konversi data ke List<Catatan>
      List<Catatan> catatans = data.map((json) => Catatan.fromJson(json)).toList();

      // Filter tugas yang memiliki tanggalDeadline dalam 7 hari ke depan
      DateTime now = DateTime.now();
      DateTime sevenDaysLater = now.add(Duration(days: 7));

      return catatans.where((catatan) {
        DateTime deadline = DateTime.parse(catatan.tanggalDeadline);
        return deadline.isAfter(now) && deadline.isBefore(sevenDaysLater);
      }).toList();
    } else {
      throw Exception('Failed to load catatans');
    }
  }

  Future<int> getJumlahTugasSelesaiPadaHari(String uid, DateTime tanggal) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid'));
      print('API Response: ${response.statusCode}'); // Debugging
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print('API Response Body: $responseBody'); // Debugging
        List<dynamic> data = responseBody['data']; // Akses key 'data'

        // Filter tugas yang selesai (status: true) dan memiliki tanggalDeadline sesuai
        int jumlahTugasSelesai = data.where((catatan) {
          bool status = catatan['status'] ?? false;
          DateTime deadline = DateTime.parse(catatan['tanggalDeadline']);
          return status && deadline.year == tanggal.year && deadline.month == tanggal.month && deadline.day == tanggal.day;
        }).length;

        return jumlahTugasSelesai;
      } else {
        throw Exception('Failed to load catatans');
      }
    } catch (e) {
      print('Error fetching catatans: $e'); // Debugging
      throw e;
    }
  }

  Future<void> createCatatan({
    required String uid,
    required String kategori,
    required String namaList,
    required String tanggalDeadline,
    bool status = false, // Default status false (belum selesai)
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/catatan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uid': uid,
          'kategori': kategori,
          'namaList': namaList,
          'tanggalDeadline': tanggalDeadline,
          'status': status,
        }),
      );

      if (response.statusCode == 201) {
        print('Catatan berhasil dibuat'); // Debugging
      } else {
        throw Exception('Gagal membuat catatan: ${response.body}');
      }
    } catch (e) {
      print('Error creating catatan: $e'); // Debugging
      throw e;
    }
  }

  // Fungsi untuk mencari kategori tugas berdasarkan uid dan idCatatan
  Future<String?> getKategoriTugas(String uid, String idCatatan) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/catatan?uid=$uid&id=$idCatatan'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> data = responseBody['data'];
        if (data.isNotEmpty) {
          final catatan = Catatan.fromJson(data.first);
          return catatan.kategori; // Kembalikan kategori tugas
        }
      }
      return null; // Jika tidak ditemukan
    } catch (e) {
      print('Error fetching kategori tugas: $e');
      throw e;
    }
  }

  Future<void> updateCatatan({
    required String uid,
    required String idCatatan,
    String? kategori,
    String? namaList,
    String? tanggalDeadline,
    bool? status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/catatan/$uid/$idCatatan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          if (kategori != null) 'kategori': kategori,
          if (namaList != null) 'namaList': namaList,
          if (tanggalDeadline != null) 'tanggalDeadline': tanggalDeadline,
          if (status != null) 'status': status,
        }),
      );

      if (response.statusCode == 200) {
        print('Catatan berhasil diupdate'); // Debugging
      } else {
        throw Exception('Gagal mengupdate catatan: ${response.body}');
      }
    } catch (e) {
      print('Error updating catatan: $e'); // Debugging
      throw e;
    }
  }
}