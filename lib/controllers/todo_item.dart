import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:organify/models/todo_item.dart'; // Import model TodoItem

class TodoItemController {
  final String baseUrl = 'https://organify-api-crud-38856081727.asia-southeast2.run.app';

  // Method untuk menambahkan todo item ke catatan
  Future<void> tambahTodoItem({
    required String uid,
    required String idCatatan,
    required String judul,
    required String isi,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/catatan/$uid/$idCatatan/todoItem'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul': judul,
          'isi': isi,
        }),
      );

      if (response.statusCode == 201) {
        print('Todo item berhasil ditambahkan');
        print('Response: ${response.body}');
      } else {
        print('Gagal menambahkan todo item: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Gagal menambahkan todo item: ${response.body}');
      }
    } catch (e) {
      print('Error adding todo item: $e');
      throw e;
    }
  }

  // Method untuk mengambil todo item berdasarkan ID catatan
  Future<TodoItem?> getTodoItem(String uid, String idCatatan) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/catatan/$uid/$idCatatan/todoItem'),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success' && responseBody['data'] != null) {
          final Map<String, dynamic> todoItemData = responseBody['data'];
          return TodoItem.fromJson(todoItemData); // Konversi data ke TodoItem
        } else {
          print('Data todoItem tidak ditemukan di respons API');
          return null;
        }
      } else {
        throw Exception('Gagal mengambil todo item: ${response.body}');
      }
    } catch (e) {
      print('Error fetching todo item: $e');
      return null;
    }
  }

  // Method untuk mengupdate todo item
  Future<void> updateTodoItem({
    required String uid,
    required String idCatatan,
    required String judul,
    required String isi,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/catatan/$uid/$idCatatan/todoItem'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul': judul,
          'isi': isi,
        }),
      );

      if (response.statusCode == 200) {
        print('Todo item berhasil diupdate');
        print('Response: ${response.body}');
      } else {
        throw Exception('Gagal mengupdate todo item: ${response.body}');
      }
    } catch (e) {
      print('Error updating todo item: $e');
      throw e;
    }
  }
}