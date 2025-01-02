import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/akun_page.dart';
import 'package:organify/screens/grafik_batang.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_navbar.dart';
import 'sign_page.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final bool isLoggedIn;

  ProfilePage({required this.isLoggedIn});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isLoggedIn;
  late String fullname = '';
  int tugasSelesai = 0;
  int tugasTertunda = 0;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn;
    _getFullName();
    fetchAndCountTasks();
  }

  Future<void> fetchAndCountTasks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        Map<String, int> counts = await apiService.countTasks(uid);
        setState(() {
          tugasSelesai = counts['tugasSelesai'] ?? 0;
          tugasTertunda = counts['tugasTertunda'] ?? 0;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignPage(
            isLoggedIn: isLoggedIn,
            onLogin: () {
              setState(() {
                isLoggedIn = true;
              });
            },
          ),
        ),
      );
    } else {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              GestureDetector(
                onTap: () {
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
              GestureDetector(
                onTap: () {
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Tugas',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222831),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(tugasSelesai.toString(), 'Tugas Selesai'),
              const SizedBox(width: 16),
              _buildSummaryCard(tugasTertunda.toString(), 'Tugas Tertunda'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: () {
                        print('Panah kiri diklik');
                      },
                    ),
                    Text(
                      '16/12 - 22/12',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222831),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        print('Panah kanan diklik');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GrafikBatang(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Tugas dalam 7 Hari Ke Depan'),
                SizedBox(height: 10),
                _buildTaskList(),
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
                onTap: handleLogin,
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
              _buildSummaryCard('0', 'Tugas Selesai'),
              const SizedBox(width: 16),
              _buildSummaryCard('0', 'Tugas Tertunda'),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: handleLogin,
              child: Text(
                "Login untuk fitur yang lebih lengkap",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  decoration: TextDecoration.underline,
                  color: Color(0xFF222831),
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('User belum login'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: apiService.fetchCatatan7HariKeDepan(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada tugas dalam 7 hari ke depan'));
        } else {
          List<Map<String, dynamic>> catatanList = snapshot.data!;
          return Column(
            children: catatanList.map((catatan) {
              return _buildTaskItem(
                catatan['namaList'],
                _formatDate(catatan['tanggalDeadline']),
              );
            }).toList(),
          );
        }
      },
    );
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day}-${parsedDate.month}';
  }

  Widget _buildTaskItem(String task, String date) {
    return ListTile(
      leading: Image.asset(
        'assets/button_kalender.png',
        width: 24,
        height: 24,
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