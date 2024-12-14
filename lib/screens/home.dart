import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State untuk masing-masing bagian
  bool _isPreviousExpanded = false;
  bool _isTodayExpanded = false;
  bool _isUpcomingExpanded = false;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0E8),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian "Sebelumnya"
            _buildSection(
              title: 'Sebelumnya',
              isExpanded: _isPreviousExpanded,
              onTap: () {
                setState(() {
                  _isPreviousExpanded = !_isPreviousExpanded;
                });
              },
              tasks: [
                _buildTaskItem('Tugas IMK', '17-12'),
                _buildTaskItem('Tugas PAM', '20 Des 2024'),
              ],
            ),

            // Bagian "Hari Ini"
            _buildSection(
              title: 'Hari Ini',
              isExpanded: _isTodayExpanded,
              onTap: () {
                setState(() {
                  _isTodayExpanded = !_isTodayExpanded;
                });
              },
              tasks: [
                _buildTaskItem('Tugas Flutter', '18-12'),
                _buildTaskItem('Tugas Laravel', '18-12'),
              ],
            ),

            // Bagian "Yang Akan Datang"
            _buildSection(
              title: 'Yang Akan Datang',
              isExpanded: _isUpcomingExpanded,
              onTap: () {
                setState(() {
                  _isUpcomingExpanded = !_isUpcomingExpanded;
                });
              },
              tasks: [
                _buildTaskItem('Tugas UAS', '25 Des 2024'),
                _buildTaskItem('Tugas Proposal', '30 Des 2024'),
              ],
            ),

            // Tambahkan teks di bagian akhir
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {
                  print('Teks periksa semua tugas ditekan');
                },
                child: Text(
                  "Periksa semua tugas yang telah selesai",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF1F0E8),
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'Rabu, 18 Desember',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          print('Tombol Menu Ditekan');
        },
        icon: Image.asset('assets/tombol_menu.png', width: 40, height: 40),
      ),
      actions: [
        IconButton(
          onPressed: () {
            print('Tombol Kalender Ditekan');
          },
          icon: Image.asset('assets/tombol_kalender.png', width: 40, height: 40),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> tasks,
  }) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 24,
              ),
            ],
          ),
          onTap: onTap,
        ),
        if (isExpanded)
          ListView(
            shrinkWrap: true, // Untuk menghindari overflow
            physics: const NeverScrollableScrollPhysics(), // ListView tidak bisa di-scroll secara independen
            children: tasks,
          ),
      ],
    );
  }

  Widget _buildTaskItem(String taskName, String deadline) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.circle_outlined, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(deadline, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.flag),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFB3C8CF),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/button_home.png', width: 50, height: 50),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF222831),
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/button_plus.png',
                  width: 70,
                  height: 70,
                  color: Color(0xFFF1F0E8),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/button_user.png', width: 50, height: 50),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
