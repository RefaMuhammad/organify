import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/models/catatan.dart';
import 'package:organify/screens/akun_page.dart';
import 'package:organify/screens/grafik_batang.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_navbar.dart';
import 'sign_page.dart';
import 'package:organify/controllers/catatan.dart';
import 'package:intl/intl.dart'; // Import package intl untuk DateFormat

class ProfilePage extends StatefulWidget {
  final bool isLoggedIn;

  ProfilePage({required this.isLoggedIn});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isLoggedIn;
  late String fullname = '';
  late String uid = '';
  int completedTasks = 0;
  int pendingTasks = 0;
  List<Catatan> tasksWithin7Days = [];
  final CatatanController _catatanController = CatatanController();
  late DateTime nearestMonday;
  late List<DateTime> weekDates;

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn;
    _getUserData();
    if (isLoggedIn) {
      _fetchTaskSummary();
    }
    // Hitung tanggal Senin terdekat dan daftar tanggal selama seminggu
    DateTime now = DateTime.now();
    nearestMonday = getNearestMonday(now);
    weekDates = getWeekDates(nearestMonday);
    fetchTasksWithin7Days();
  }

  // Fungsi untuk mendapatkan tanggal Senin terdekat
  DateTime getNearestMonday(DateTime now) {
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday > 0) {
      daysUntilMonday -= 7;
    }
    return now.add(Duration(days: daysUntilMonday));
  }

  // Fungsi untuk mendapatkan daftar tanggal selama seminggu
  List<DateTime> getWeekDates(DateTime startDate) {
    List<DateTime> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(startDate.add(Duration(days: i)));
    }
    return weekDates;
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      print('UID: $uid');
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

  Future<void> _fetchTaskSummary() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        Map<String, int> summary = await _catatanController.getTaskSummary(uid);
        setState(() {
          completedTasks = summary['completedTasks'] ?? 0;
          pendingTasks = summary['pendingTasks'] ?? 0;
        });
      } catch (e) {
        print('Error fetching task summary: $e');
      }
    }
  }

  // Fungsi untuk mengambil tugas dalam 7 hari ke depan
  Future<void> fetchTasksWithin7Days() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final tasks = await _catatanController.getTasksWithin7Days(user.uid);
        setState(() {
          tasksWithin7Days = tasks;
        });
      } catch (e) {
        print('Error fetching tasks within 7 days: $e');
      }
    }
  }

  void handleLogin() {
    if (!isLoggedIn) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),

                  ],
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
                Text(uid),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(completedTasks.toString(), 'Tugas Selesai'),
              const SizedBox(width: 16),
              _buildSummaryCard(pendingTasks.toString(), 'Tugas Tertunda'),
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
                        // Navigasi ke minggu sebelumnya
                        setState(() {
                          nearestMonday = nearestMonday.subtract(Duration(days: 7));
                          weekDates = getWeekDates(nearestMonday);
                          print('nearestMonday: $nearestMonday');
                        });
                      },
                    ),
                    Text(
                      '${weekDates.first.day}/${weekDates.first.month} - ${weekDates.last.day}/${weekDates.last.month}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222831),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        // Navigasi ke minggu berikutnya
                        setState(() {
                          nearestMonday = nearestMonday.add(Duration(days: 7));
                          weekDates = getWeekDates(nearestMonday);
                          print('nearestMonday: $nearestMonday');
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GrafikBatang(
                  uid: uid, // Kirim UID pengguna
                  tanggalAwal: "${nearestMonday.toLocal()}".split(' ')[0], // Format tanggal ke YYYY-MM-DD
                ), // Kirim tanggal Senin ke GrafikBatang
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weekDates.map((date) {
                    return Text(
                      _getDayName(date.weekday),
                      style: TextStyle(fontSize: 12),
                    );
                  }).toList(),
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
            width: double.infinity,
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

  // Modifikasi _buildTaskList untuk menampilkan tugas dari database
  Widget _buildTaskList() {
    return Column(
      children: tasksWithin7Days.map((catatan) {
        return _buildTaskItem(
          catatan.namaList,
          DateFormat('dd-MM').format(DateTime.parse(catatan.tanggalDeadline)),
        );
      }).toList(),
    );
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

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return '';
    }
  }
}