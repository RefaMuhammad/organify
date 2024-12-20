import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  final bool isLoggedIn; // Status login

  ProfilePage({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0E8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding untuk kanan dan kiri
        child: isLoggedIn ? _buildLoggedInView() : _buildNotLoggedInView(),
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 1, // Index halaman Profile
        onItemTapped: (int index) {
          // Aksi ketika item di bottom navbar dipilih
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home'); // Navigasi ke Home
          } else if (index == 1) {
            // Tetap di halaman ini
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings'); // Navigasi ke Settings
          }
        },
      ),
    );
  }

  // Tampilan untuk pengguna yang sudah login
  Widget _buildLoggedInView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto profil dan nama
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_image.png'), // Ganti sesuai gambar
          ),
          SizedBox(height: 10),
          Text(
            'Septian Hadi Nugroho',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Ringkasan tugas
          Text('Ringkasan Tugas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard('2', 'Tugas Selesai'),
              _buildSummaryCard('4', 'Tugas Tertunda'),
            ],
          ),

          SizedBox(height: 20),

          // Grafik tugas selesai
          _buildSectionTitle('Grafik Tugas Selesai'),
          Container(
            height: 150,
            color: Colors.grey[300], // Placeholder untuk grafik
            child: Center(child: Text('Grafik Placeholder')),
          ),

          SizedBox(height: 20),

          // Tugas dalam 7 hari ke depan
          _buildSectionTitle('Tugas dalam 7 Hari Ke Depan'),
          _buildTaskList(),
        ],
      ),
    );
  }

  // Tampilan untuk pengguna yang belum login
  Widget _buildNotLoggedInView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // Tambahkan aksi klik di sini, misalnya untuk login
                },
                child: ClipOval(
                  child: Image.asset(
                    'assets/default_pp.png', // Path gambar Anda
                    width: 120,  // Ukuran gambar
                    height: 120, // Ukuran gambar
                    fit: BoxFit.cover, // Memastikan gambar terpotong secara proporsional
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Klik untuk login',
                style: GoogleFonts.poppins(
                    color: Color(0xFF222831),
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
          // Ringkasan tugas
          Text('Ringkasan Tugas', style: GoogleFonts.poppins(
              color: Color(0xFF222831),
              fontSize: 16,
              fontWeight: FontWeight.w600
          )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard('2', 'Tugas Selesai'),
              SizedBox(width: 16),
              _buildSummaryCard('4', 'Tugas Tertunda'),
            ],
          ),

          SizedBox(height: 10),

          // Grafik tugas selesai
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Grafik Tugas Selesai', style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF222831)
            )),
          ),

          SizedBox(height: 10),

          // Tugas dalam 7 hari ke depan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Tugas dalam 7 hari ke depan', style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF222831)
            )),
          ),
          SizedBox(height: 10),
          Center(
            child: Text('Login untuk fitur yang lebih lengkap', style: GoogleFonts.poppins(
                color: Color(0xFF222831),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
            ),
            ),
          ),
        ],
      ),
    );
  }

  // Kartu ringkasan tugas
  Widget _buildSummaryCard(String count, String label) {
    return Expanded(
      child: Container(
        width: double.infinity, // Memastikan lebar penuh
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(count, style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222831)
            )),
            SizedBox(height: 15),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF222831)
            )),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  // Daftar tugas dalam 7 hari ke depan
  Widget _buildTaskList() {
    return Column(
      children: [
        _buildTaskItem('Tugas Prak. MBD', '20-12'),
        _buildTaskItem('Tugas Proyek IMK', '20-12'),
        _buildTaskItem('Tugas PAM', '21-12'),
        _buildTaskItem('Tugas PAW', '22-12'),
      ],
    );
  }

  Widget _buildTaskItem(String task, String date) {
    return ListTile(
      leading: Icon(Icons.calendar_today, color: Colors.grey),
      title: Text(task),
      trailing: Text(date),
    );
  }

  // Judul bagian
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
