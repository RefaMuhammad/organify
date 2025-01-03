import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/controllers/todo_item.dart'; // Import controller
import 'package:organify/models/todo_item.dart'; // Import model TodoItem
import 'package:intl/intl.dart'; // Untuk format tanggal

class EditCatatanPage extends StatefulWidget {
  final String uid;
  final String idCatatan;

  const EditCatatanPage({
    Key? key,
    required this.uid,
    required this.idCatatan,
  }) : super(key: key);

  @override
  _EditCatatanPageState createState() => _EditCatatanPageState();
}

class _EditCatatanPageState extends State<EditCatatanPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TodoItemController _todoItemController = TodoItemController();
  TodoItem? _todoItem;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodoItem();
  }

  // Method untuk mengambil todo item dari database
  Future<void> _fetchTodoItem() async {
    try {
      print('UID: ${widget.uid}');
      print('ID Catatan: ${widget.idCatatan}');

      final todoItem = await _todoItemController.getTodoItem(widget.uid, widget.idCatatan);
      if (todoItem == null) {
        print('TodoItem tidak ditemukan, membuat todoItem baru...');
        // Buat todoItem baru jika tidak ditemukan
        await _todoItemController.tambahTodoItem(
          uid: widget.uid,
          idCatatan: widget.idCatatan,
          judul: 'Judul Default',
          isi: 'Isi Default',
        );
        // Ambil kembali todoItem setelah dibuat
        final newTodoItem = await _todoItemController.getTodoItem(widget.uid, widget.idCatatan);
        setState(() {
          _todoItem = newTodoItem;
          _judulController.text = newTodoItem?.judul ?? 'Judul Default';
          _catatanController.text = newTodoItem?.isi ?? 'Isi Default';
          _isLoading = false;
        });
      } else {
        setState(() {
          _todoItem = todoItem;
          _judulController.text = todoItem.judul;
          _catatanController.text = todoItem.isi;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching todo item: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method untuk menyimpan perubahan todo item
  Future<void> _saveChanges() async {
    final judul = _judulController.text;
    final isi = _catatanController.text;

    if (judul.isEmpty || isi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul dan catatan tidak boleh kosong')),
      );
      return;
    }

    try {
      // Cek apakah todoItem sudah ada
      if (_todoItem == null) {
        // Jika tidak ada, buat todoItem baru
        await _todoItemController.tambahTodoItem(
          uid: widget.uid,
          idCatatan: widget.idCatatan,
          judul: judul,
          isi: isi,
        );
      } else {
        // Jika sudah ada, update todoItem
        await _todoItemController.updateTodoItem(
          uid: widget.uid,
          idCatatan: widget.idCatatan,
          judul: judul,
          isi: isi,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perubahan berhasil disimpan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan perubahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0E8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F0E8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _judulController,
              maxLines: 1,
              maxLength: 60,
              decoration: InputDecoration(
                hintText: 'Judul',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222831),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Terakhir diperbarui: ${_todoItem != null ? DateFormat('dd/MM/yyyy HH:mm').format(_todoItem!.terakhirDiperbarui) : 'Tidak ada data'}',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Color(0x89222831),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _catatanController,
              maxLines: 5,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Tambah Catatan',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF222831),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}