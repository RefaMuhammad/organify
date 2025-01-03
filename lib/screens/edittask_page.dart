import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/controllers/catatan.dart';
import 'package:organify/screens/calendar_popup.dart';
import 'package:organify/screens/category_button.dart';
import 'package:organify/screens/edit_catatan.dart';
import 'package:organify/screens/home.dart';
import 'package:organify/models/todo_item.dart'; // Import model TodoItem
import 'package:intl/intl.dart'; // Untuk format tanggal

class EditTaskPage extends StatefulWidget {
  final String taskName; // Nama tugas
  final String deadline; // Deadline tugas
  final String uid; // UID pengguna
  final String idCatatan; // ID catatan

  const EditTaskPage({
    super.key,
    required this.taskName,
    required this.deadline,
    required this.uid,
    required this.idCatatan,
  });

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  String? _judul;
  String? _catatan;
  String? _kategoriTugas;
  String? selectedTanggalDeadline; // Declare the variable here
  TodoItem? _todoItem; // Tambahkan state untuk todoItem
  final CatatanController _catatanController = CatatanController();

  @override
  void initState() {
    super.initState();
    _fetchKategoriTugas();
    _fetchTodoItem(); // Panggil method untuk mengambil todoItem
    selectedTanggalDeadline = widget.deadline; // Initialize with the passed deadline
  }

  Future<void> _fetchKategoriTugas() async {
    try {
      final kategori = await _catatanController.getKategoriTugas(widget.uid, widget.idCatatan);
      setState(() {
        _kategoriTugas = kategori;
      });
    } catch (e) {
      print('Error fetching kategori tugas: $e');
    }
  }

  // Method untuk mengambil todoItem
  Future<void> _fetchTodoItem() async {
    try {
      final todoItem = await _catatanController.getTodoItem(widget.uid, widget.idCatatan);
      setState(() {
        _todoItem = todoItem;
        if (todoItem != null) {
          _judul = todoItem.judul; // Ambil judul dari todoItem
          _catatan = todoItem.isi; // Ambil isi dari todoItem
        }
      });
    } catch (e) {
      print('Error fetching todo item: $e');
    }
  }

  // Fungsi untuk menghapus catatan
  Future<void> _hapusCatatan() async {
    try {
      await _catatanController.deleteCatatan(widget.uid, widget.idCatatan);
      // Navigasi ke halaman home setelah menghapus
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(isLoggedIn: true, onLogin: () {})),
      );
    } catch (e) {
      print('Error deleting catatan: $e');
      // Tampilkan pesan error jika diperlukan
    }
  }

  // Fungsi untuk mengupdate status catatan menjadi selesai
  Future<void> _selesaikanCatatan() async {
    try {
      // Panggil metode updateCatatan dengan parameter yang diperlukan
      await _catatanController.updateCatatan(
        uid: widget.uid,
        idCatatan: widget.idCatatan,
        kategori: _kategoriTugas, // Kategori yang dipilih
        tanggalDeadline: selectedTanggalDeadline, // Tanggal deadline yang dipilih
      );

      // Navigasi ke halaman home setelah mengupdate
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(isLoggedIn: true, onLogin: () {})),
      );
    } catch (e) {
      print('Error updating catatan: $e');
      // Tampilkan pesan error jika diperlukan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F0E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3C8CF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CategoryButton(
                    isEditPage: true,
                    initialCategory: _kategoriTugas,
                    onCategorySelected: (kategori) {
                      print('Kategori yang dipilih: $kategori');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.taskName,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(
              thickness: 1,
              color: Color(0xFFB8B7B7),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF222831),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tenggat Waktu',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF222831),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CalendarPopup(
                          onDateSelected: (tanggal) {
                            print('Tanggal yang dipilih: $tanggal'); // Debugging
                            setState(() {
                              selectedTanggalDeadline = tanggal.toIso8601String();
                            });
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3C8CF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      selectedTanggalDeadline ?? widget.deadline, // Use selectedTanggalDeadline if available
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF222831),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
              thickness: 1,
              color: Color(0xFFB8B7B7),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.note_alt,
                      color: Color(0xFF222831),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          'Catatan',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF222831),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCatatanPage(
                        uid: widget.uid, // Gunakan widget.uid
                        idCatatan: widget.idCatatan, // Tambahkan idCatatan
                      )),
                    );

                    if (result != null) {
                      setState(() {
                        _judul = result['judul'];
                        _catatan = result['catatan'];
                      });
                    }
                  },
                  child: Text(
                    'Tambah',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF222831),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (_judul != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _judul!,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF222831),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (_catatan != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _catatan!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF222831),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            const Divider(
              thickness: 1,
              color: Color(0xFFB8B7B7),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _hapusCatatan, // Panggil fungsi hapus catatan
                  child: Text(
                    'HAPUS',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                      child: Text(
                        'BATAL',
                        style: GoogleFonts.poppins(
                          color: const Color(0x694E6167),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _selesaikanCatatan, // Panggil fungsi selesaikan catatan
                      child: Text(
                        'SELESAI',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF4E6167),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}