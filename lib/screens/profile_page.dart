import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/akun_page.dart';
import 'package:organify/screens/grafik_batang.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_navbar.dart';
import 'sign_page.dart';

class ProfilePage extends StatefulWidget {
  final bool isLoggedIn;

  ProfilePage({required this.isLoggedIn});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isLoggedIn;
  late String fullname = '';

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn; // Inisialisasi status login
    _getFullName();
  }

  Future<void> _getFullName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('login')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          fullname = snapshot['fullname'] ?? 'No name available';
        });
      }
    }
  }

  void handleLogin() {
    if (!isLoggedIn) {
      // Jika belum login, pindahkan ke halaman SignPage
      Navigator.pushReplacementNamed(context, '/signpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0E8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: isLoggedIn ? _buildLoggedInView() : _buildNotLoggedInView(context),
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 1,
        onItemTapped: (int index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            // Tetap di halaman ini
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        isLoggedIn: isLoggedIn,
      ),
    );
  }

  Widget _buildLoggedInView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              // Gambar (CircleAvatar) yang bisa diklik
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman akun
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/button_plus.png'),
                ),
              ),
              const SizedBox(width: 15),
              // Teks yang bisa diklik
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman akun
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                },
                child: Text(
                  fullname.isNotEmpty ? fullname : 'Loading...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222831),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(16), // Padding di sekitar teks
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Mengatur alignment column ke start
              children: [
                Text(
                  'Ringkasan Tugas',
                  textAlign: TextAlign.start, // Mengatur alignment teks ke start (kiri)
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222831),
                  ),
                ),
                // Widget lainnya
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard('2', 'Tugas Selesai'),
              const SizedBox(width: 16),
              _buildSummaryCard('4', 'Tugas Tertunda'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16), // Padding di sekitar container
            decoration: BoxDecoration(
              color: Colors.grey[300], // Warna latar belakang container
              borderRadius: BorderRadius.circular(10), // Ujung container melengkung
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Mengatur alignment column ke start
              children: [
                // Teks "Grafik Tugas Selesai"
                Row(
                  children: [
                    // Teks "Grafik Tugas Selesai"
                    Expanded(
                      child: Text(
                        'Grafik Tugas Selesai',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222831),
                        ),
                      ),
                    ),
                    // Panah Kiri (Arrow Left)
                    IconButton(
                      icon: Icon(Icons.arrow_left), // Ikon panah kiri
                      onPressed: () {
                        // Aksi ketika panah kiri diklik
                        print('Panah kiri diklik');
                      },
                    ),
                    // Tanggal (16/12 - 22/12)
                    Text(
                      '16/12 - 22/12',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222831),
                      ),
                    ),
                    // Panah Kanan (Arrow Right)
                    IconButton(
                      icon: Icon(Icons.arrow_right), // Ikon panah kanan
                      onPressed: () {
                        // Aksi ketika panah kanan diklik
                        print('Panah kanan diklik');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10), // Jarak antara tanggal dan grafik
                // Grafik Batang
                GrafikBatang(), // Memanggil grafik batang dari file terpisah
                SizedBox(height: 10), // Jarak antara grafik dan hari
                // Daftar Hari
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menyebarkan hari secara merata
                  children: [
                    Text('Senin', style: TextStyle(fontSize: 12)),
                    Text('Selasa', style: TextStyle(fontSize: 12)),
                    Text('Rabu', style: TextStyle(fontSize: 12)),
                    Text('Kamis', style: TextStyle(fontSize: 12)),
                    Text('Jumat', style: TextStyle(fontSize: 12)),
                    Text('Sabtu', style: TextStyle(fontSize: 12)),
                    Text('Minggu', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300], // Warna latar belakang abu-abu
              borderRadius: BorderRadius.circular(12), // Ujung container melengkung
            ),
            padding: const EdgeInsets.all(16), // Padding di dalam container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Mengatur alignment column ke start
              children: [
                _buildSectionTitle('Tugas dalam 7 Hari Ke Depan'), // Judul section
                SizedBox(height: 10), // Jarak antara judul dan daftar tugas
                _buildTaskList(), // Daftar tugas
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              InkWell(
                onTap: handleLogin, // Panggil handleLogin saat di-tap
                child: ClipOval(
                  child: Image.asset(
                    'assets/default_pp.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Klik untuk login',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF222831),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Ringkasan Tugas',
            style: GoogleFonts.poppins(
              color: const Color(0xFF222831),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard('2', 'Tugas Selesai'),
              const SizedBox(width: 16),
              _buildSummaryCard('4', 'Tugas Tertunda'),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16), // Padding di dalam container
            decoration: BoxDecoration(
              color: Colors.grey[300], // Warna latar belakang container
              borderRadius: BorderRadius.circular(10), // Ujung container melengkung
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan teks dan tombol di ujung yang berlawanan
              children: [
                Text(
                  'Grafik Tugas Selesai',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222831),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16), // Padding di dalam container
            decoration: BoxDecoration(
              color: Colors.grey[300], // Warna latar belakang container
              borderRadius: BorderRadius.circular(10), // Ujung container melengkung
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan teks dan tombol di ujung yang berlawanan
              children: [
                Text(
                  'Tugas dalam 7 Hari ke Depan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222831),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Lebar container mengisi layar
            padding: const EdgeInsets.all(16), // Padding di sekitar teks
            child: GestureDetector(
              onTap: handleLogin, // Panggil fungsi handleLogin ketika teks diklik
              child: Text(
                "Login untuk fitur yang lebih lengkap",
                textAlign: TextAlign.center, // Mengatur alignment teks ke tengah
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  decoration: TextDecoration.underline, // Menambahkan garis bawah
                  color: Color(0xFF222831), // Warna teks (opsional)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String count, String label) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Text(
              count,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222831),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF222831),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF222831)
      ),
    );
  }

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
      leading: Image.asset(
        'assets/button_kalender.png', // Path ke gambar
        width: 24, // Lebar gambar
        height: 24, // Tinggi gambar
      ),
      title: Text(task, style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF222831)
      )),
      trailing: Text(date, style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 8,
        color: Color(0xFF000000)
      )),
    );
  }
}