import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navbar.dart';
import 'button.dart';

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
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Chip(
                            label: Text('Semua',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFF698791),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text('Pribadi',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black,
                                )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFFB3C8CF),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text('Kerja',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black,
                                )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFFB3C8CF),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text('Ulang Tahun',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black,
                                )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFFB3C8CF),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text('Kuliah',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black,
                                )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFFB3C8CF),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      'assets/tombol_tiga_titik.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
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
      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF1F0E8),
      centerTitle: true,
      automaticallyImplyLeading: true, // Mengaktifkan tombol menu untuk Drawer
      title: Text(
        'Rabu, 18 Desember',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Drawer
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF222831)),
            child: Center(
              child: Text(
                'Organify',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Kategori dengan ExpansionTile
          ExpansionTile(
            leading: const Icon(Icons.grid_view, color: Colors.black),
            title: Text('Kategori', style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),),
            trailing: const Icon(Icons.keyboard_arrow_up, color: Colors.black), // Panah ke atas/bawah
            children: [
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.black),
                title: Text('Semua', style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),),
                trailing: const Text('5', style: TextStyle(color: Colors.black)),
                onTap: () {
                  // Aksi untuk "Semua"
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title: Text('Pribadi', style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),),
                trailing: const Text('2', style: TextStyle(color: Colors.black)),
                onTap: () {
                  // Aksi untuk "Pribadi"
                },
              ),
              ListTile(
                leading: const Icon(Icons.work, color: Colors.black),
                title: Text('Kerja', style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),),
                trailing: const Text('3', style: TextStyle(color: Colors.black)),
                onTap: () {
                  // Aksi untuk "Kerja"
                },
              ),
              ListTile(
                leading: const Icon(Icons.cake, color: Colors.black),
                title: Text('Ulang Tahun', style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),),
                trailing: const Text('3', style: TextStyle(color: Colors.black)),
                onTap: () {
                  // Aksi untuk "Ulang Tahun"
                },
              ),
              // Buat Baru
              ListTile(
                leading: const Icon(Icons.add, color: Colors.black),
                title: Text('Buat Baru', style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String? newCategory;
                      bool isInputFilled = false; // Menyimpan status pengisian teks

                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text(
                              'Buat Kategori Baru',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF222831),
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      newCategory = value;
                                      isInputFilled = newCategory != null &&
                                          newCategory!.trim().isNotEmpty;
                                    });
                                  },
                                  maxLength: 50, // Batasi maksimal 50 karakter
                                  decoration: InputDecoration(
                                    hintText: 'Ketik disini',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF222831),
                                    ),
                                    border: const OutlineInputBorder(),
                                    counterText: '', // Hilangkan teks counter bawaan (opsional)
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              Opacity(
                                opacity: isInputFilled ? 1.0 : 0.5,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: Text(
                                    'Batal',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF222831),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (newCategory != null &&
                                      newCategory!.trim().isNotEmpty) {
                                    print('Kategori baru: $newCategory');
                                    // Lakukan aksi dengan kategori baru, misalnya tambah ke daftar
                                  }
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: Text(
                                  'Simpan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF222831),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),

          // Masukan
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.black),
            title: const Text('Masukan'),
            onTap: () {
              // Aksi untuk "Masukan"
            },
          ),
        ],
      ),
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                      Text(
                        deadline,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const MyButton(), // Ganti ikon flag dengan popover
        ],
      ),
    );
  }
}
