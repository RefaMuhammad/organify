import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn; // Inisialisasi status login
  }

  void handleLogin() {
    if (!isLoggedIn) {
      // Jika belum login, pindahkan ke halaman SignPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignPage(
            isLoggedIn: isLoggedIn,
            onLogin: () {
              setState(() {
                isLoggedIn = true; // Perbarui status login
              });
            },
          ),
        ),
      );
    } else {
      // Jika sudah login, tampilkan widget logged-in
      setState(() {
        isLoggedIn = true;
      });
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_image.png'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Septian Hadi Nugroho',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ringkasan Tugas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard('2', 'Tugas Selesai'),
              _buildSummaryCard('4', 'Tugas Tertunda'),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Grafik Tugas Selesai'),
          Container(
            height: 150,
            color: Colors.grey[300],
            child: const Center(child: Text('Grafik Placeholder')),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Tugas dalam 7 Hari Ke Depan'),
          _buildTaskList(),
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
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      leading: const Icon(Icons.calendar_today, color: Colors.grey),
      title: Text(task),
      trailing: Text(date),
    );
  }
}
