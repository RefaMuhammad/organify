import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/category_button.dart';
import 'package:organify/screens/edit_catatan.dart'; // Sesuaikan dengan path file Anda
import '../services/api_service.dart'; // Impor ApiService

class EditTaskPage extends StatefulWidget {
  final String id; // ID catatan
  final String taskName;
  final String deadline;

  const EditTaskPage({
    Key? key,
    required this.id,
    required this.taskName,
    required this.deadline,
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  String? _judul; // Variabel untuk menyimpan judul
  String? _catatan; // Variabel untuk menyimpan catatan
  String _selectedCategory = 'kategori'; // Variabel untuk menyimpan kategori yang dipilih
  final ApiService apiService = ApiService(); // Buat instance ApiService

  @override
  void initState() {
    super.initState();
    _loadTodoItem(); // Memuat catatan saat halaman dibuka
  }

  // Fungsi untuk memuat catatan
  Future<void> _loadTodoItem() async {
    try {
      final message = await apiService.getTodoItem(widget.id);
      setState(() {
        _catatan = message; // Simpan catatan ke state
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat catatan: $e')),
      );
    }
  }

  // Fungsi untuk menyimpan perubahan
  Future<void> _simpanPerubahan() async {
    if (_judul != null && _judul!.isNotEmpty && _catatan != null && _catatan!.isNotEmpty) {
      try {
        await apiService.tambahTodoItem(widget.id, _judul!, _catatan!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catatan berhasil disimpan')),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menyimpan
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan catatan: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul dan catatan tidak boleh kosong')),
      );
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
                    onCategorySelected: (String category) {
                      setState(() {
                        _selectedCategory = category; // Update nilai _selectedCategory
                      });
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3C8CF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.deadline,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF222831),
                      fontWeight: FontWeight.w400,
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
                    // Navigasi ke halaman edit catatan dan tunggu hasilnya
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCatatanPage()),
                    );

                    // Debugging: Cetak hasil yang dikembalikan
                    print('Hasil dari EditCatatanPage: $result');

                    // Jika ada hasil (catatan), simpan dan perbarui tampilan
                    if (result != null) {
                      setState(() {
                        _judul = result['judul']; // Simpan nilai judul
                        _catatan = result['catatan']; // Simpan nilai catatan
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
            Text(widget.id),
            // Tampilkan judul jika ada
            if (_judul != null && _judul!.isNotEmpty)
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
            // Tampilkan catatan jika ada
            if (_catatan != null && _catatan!.isNotEmpty)
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
                  onPressed: _simpanPerubahan, // Simpan perubahan
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
      ),
    );
  }
}