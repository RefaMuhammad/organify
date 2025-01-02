import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:organify/models/catatan.dart'; // Import model

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

  // Method untuk memfilter catatan berdasarkan tanggalDeadline
  Future<Map<String, List<Catatan>>> getFilteredCatatans(String uid) async {
    List<Catatan> catatans = await getCatatans(uid);
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(Duration(days: 1));

    List<Catatan> sebelumnya = [];
    List<Catatan> hariIni = [];
    List<Catatan> yangAkanDatang = [];

    for (var catatan in catatans) {
      DateTime deadline = DateTime.parse(catatan.tanggalDeadline);
      if (deadline.isBefore(todayStart)) {
        sebelumnya.add(catatan);
      } else if (deadline.isAfter(todayStart) && deadline.isBefore(todayEnd)) {
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
}