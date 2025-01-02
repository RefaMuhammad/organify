import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/listTugasSelesai_page.dart';
import 'package:organify/screens/sign_page.dart';
import 'package:organify/screens/taskCalender_page.dart';
import 'package:organify/screens/task_item.dart';
import 'bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'button.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;
  final VoidCallback onLogin;
  const HomeScreen({Key? key, required this.isLoggedIn, required this.onLogin}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State untuk masing-masing bagian
  bool _isPreviousExpanded = false;
  bool _isTodayExpanded = false;
  bool _isUpcomingExpanded = false;

  int _selectedIndex = 0;

  late final VoidCallback login;

  bool _showSearchBar = false; // State untuk menampilkan searchbar

  get isLoggedIn => widget.isLoggedIn; // Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    login = widget.onLogin; // Inisialisasi dengan widget.onLogin
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
    });
  }

  Future<void> _launchEmail() async {
    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: 'septianworkingemail@gmail.com',
      queryParameters: {
        'subject': 'Masukan Aplikasi Organify', // Subjek email
        'body': 'Tulis feedback Anda di sini...', // Isi email
      },
    );

    try {
      if (await canLaunch(mailtoUri.toString())) {
        await launch(mailtoUri.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka aplikasi email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            // Tampilkan searchbar atau Padding dengan Row
            _showSearchBar ? _buildSearchBar() : _buildChipsRow(),
            _buildSection(
              title: 'Sebelumnya',
              isExpanded: _isPreviousExpanded,
              onTap: () {
                setState(() {
                  _isPreviousExpanded = !_isPreviousExpanded;
                });
              },
              tasks: [
                const TaskItem(taskName: 'Tugas IMK', deadline: '17-12-2024'),
                const TaskItem(taskName: 'Tugas PAM', deadline: '20 Des 2024'),
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
                const TaskItem(taskName: 'Tugas Flutter', deadline: '18-12'),
                const TaskItem(taskName: 'Tugas Laravel', deadline: '18-12'),
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
                const TaskItem(taskName: 'Tugas UAS', deadline: '25 Des 2024'),
                const TaskItem(taskName: 'Tugas Proposal', deadline: '30 Des 2024'),
              ],
            ),

            // Tambahkan teks di bagian akhir
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TugasSelesaiPage()),
                  );
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
        isLoggedIn: widget.isLoggedIn, // Gunakan widget.isLoggedIn
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9), // Warna background searchbar
          borderRadius: BorderRadius.circular(30), // Bentuk kapsul
          border: Border.all(
            color: Color(0xFFD9D9D9), // Warna outline
            width: 1, // Ketebalan outline
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _toggleSearchBar,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Mencari tugas...",
                  border: InputBorder.none, // Menghilangkan border default TextField
                  contentPadding: EdgeInsets.symmetric(vertical: 12), // Padding vertikal
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222831)
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsRow() {
    return Padding(
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
            padding: EdgeInsets.zero,
            child: PopupMenuButton<String>(
              icon: Image.asset(
                'assets/tombol_tiga_titik.png',
                width: 24,
                height: 24,
              ),
              onSelected: (String value) {
                if (value == 'search') {
                  _toggleSearchBar();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'search',
                    child: Container(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,// Padding di dalam Container diatur ke zero
                      child: Text(
                        "Mencari Tugas",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Color(0xFF222831),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              color: Color(0xFFF1F0E8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Sudut melengkung
              ),
              padding: EdgeInsets.zero, // Padding di luar PopupMenuButton diatur ke zero
              offset: Offset(0, 40), // Sesuaikan posisi popover jika diperlukan
            ),
          ),
        ],
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
            // Navigasi ke halaman TaskCalendar
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskCalendar()),
            );
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
                title: Text(
                  'Buat Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  if (!widget.isLoggedIn) {
                    // Jika belum login, arahkan ke halaman SignIn
                    Navigator.pushReplacementNamed(context, '/signpage');
                  } else {
                    // Jika sudah login, tampilkan dialog untuk membuat kategori baru
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String? newCategory;
                        bool isInputFilled = false;

                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text(
                                'Buat Kategori Baru',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF222831),
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
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      hintText: 'Ketik disini',
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: const Color(0xFF222831),
                                      ),
                                      border: const OutlineInputBorder(),
                                      counterText: '',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: Text(
                                    'Batal',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF222831),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: isInputFilled
                                      ? () {
                                    if (newCategory != null &&
                                        newCategory!.trim().isNotEmpty) {
                                      print('Kategori baru: $newCategory');
                                      // Tambahkan kategori baru ke daftar
                                    }
                                    Navigator.of(context).pop(); // Tutup dialog
                                  }
                                      : null, // Disable jika input kosong
                                  child: Text(
                                    'Simpan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF222831),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          //Masukan
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.black),
            title: const Text('Masukan'),
            onTap: _launchEmail, // Panggil fungsi _launchEmail di sini
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
}