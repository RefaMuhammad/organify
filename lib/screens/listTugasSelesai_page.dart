import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/controllers/catatan.dart'; // Import CatatanController
import 'package:organify/models/catatan.dart'; // Import model Catatan
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth untuk mendapatkan UID
import 'package:intl/intl.dart';

class TugasSelesaiPage extends StatefulWidget {
  @override
  _TugasSelesaiPageState createState() => _TugasSelesaiPageState();
}

class _TugasSelesaiPageState extends State<TugasSelesaiPage> {
  final CatatanController _catatanController = CatatanController();
  List<Catatan> _tugasSelesaiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTugasSelesai();
  }

  // Fungsi untuk mengambil tugas selesai dari database
  Future<void> _fetchTugasSelesai() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final List<Catatan> catatans = await _catatanController.getCatatans(user.uid);
        setState(() {
          _tugasSelesaiList = catatans.where((catatan) => catatan.status == true).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching tugas selesai: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk mengelompokkan tugas selesai berdasarkan tanggal
  Map<String, List<Catatan>> _groupTugasByTanggal(List<Catatan> tugasSelesaiList) {
    Map<String, List<Catatan>> groupedTugas = {};

    for (var tugas in tugasSelesaiList) {
      String tanggal = DateFormat('dd/MM/yyyy').format(DateTime.parse(tugas.tanggalDeadline));
      if (!groupedTugas.containsKey(tanggal)) {
        groupedTugas[tanggal] = [];
      }
      groupedTugas[tanggal]!.add(tugas);
    }

    return groupedTugas;
  }

  // Fungsi untuk menghapus semua tugas selesai
  Future<void> _deleteAllCompletedTasks() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _catatanController.deleteAllCompletedTasks(user.uid);
        // Setelah penghapusan, perbarui daftar tugas selesai
        await _fetchTugasSelesai();
      }
    } catch (e) {
      print('Error deleting all completed tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Catatan>> groupedTugas = _groupTugasByTanggal(_tugasSelesaiList);

    return Scaffold(
      backgroundColor: Color(0xFFF1F0E8), // Background color #F1F0E8
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F0E8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF222831)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Ikon delete di sisi end
          IconButton(
            icon: Icon(Icons.delete_outline, color: Color(0xFF222831)),
            onPressed: () {
              // Aksi ketika ikon delete ditekan
              _deleteAllCompletedTasks();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "Tugas Selesai",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E6167),
            ),
          ),
          SizedBox(height: 15),
          // Loop untuk menampilkan setiap tanggal dan tugasnya
          for (var tanggal in groupedTugas.keys)
            _buildSection(
              title: tanggal,
              tasks: groupedTugas[tanggal]!,
            ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun section dengan title dan list tugas
  Widget _buildSection({
    required String title,
    required List<Catatan> tasks,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section (tanggal)
        Row(
          children: [
            Opacity(
              opacity: 0.65, // Opasitas 50%
              child: Icon(Icons.radio_button_checked),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Jarak horizontal
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4E6167),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // List tugas
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final tugas = tasks[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              color: Color(0xFFE4E4E0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Ikon check_circle di sisi kiri
                    Icon(
                      Icons.check_circle,
                      color: Color(0x80222831), // Ubah warna ikon
                      size: 24, // Ubah ukuran ikon
                    ),
                    // Jarak antara ikon check_circle dan teks
                    SizedBox(width: 10),
                    // Kolom teks
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tugas.namaList,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Color(0x80222831),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            tugas.kategori,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Color(0x80222831),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16), // Jarak antar section
      ],
    );
  }
}