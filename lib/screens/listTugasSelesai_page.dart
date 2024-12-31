import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TugasSelesaiPage extends StatelessWidget {
  // Data dummy untuk tugas selesai
  final List<Map<String, dynamic>> tugasSelesaiList = [
    {
      'tanggal': '17/12/2024',
      'tugas': [
        {'nama': 'Tugas Praktikum MPPL'},
        {'nama': 'Tugas Analisis Algoritma'},
      ],
    },
    {
      'tanggal': '18/12/2024',
      'tugas': [
        {'nama': 'Tugas Flutter'},
        {'nama': 'Tugas Laravel'},
      ],
    },
    {
      'tanggal': '19/12/2024',
      'tugas': [
        {'nama': 'Tugas Desain UI/UX'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              print('Ikon delete ditekan');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text("Tugas Selesai", style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E6167)
          )),
          SizedBox(height: 15),
          // Loop untuk menampilkan setiap tanggal dan tugasnya
          for (var tugasSelesai in tugasSelesaiList)
            _buildSection(
              title: tugasSelesai['tanggal'],
              tasks: tugasSelesai['tugas'],
            ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun section dengan title dan list tugas
  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> tasks,
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
                            tugas['nama'],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Color(0x80222831),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            "17-2",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Color(0x80222831),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Jarak antara teks dan ikon flag
                    SizedBox(width: 10),
                    // Ikon flag di sisi kanan
                    Icon(
                      Icons.flag,
                      color: Color(0x80222831), // Ubah warna ikon
                      size: 24, // Ubah ukuran ikon
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