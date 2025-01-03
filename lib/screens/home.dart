import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/controllers/catatan.dart';
import 'package:organify/controllers/kategori.dart';
import 'package:organify/models/catatan.dart';
import 'package:organify/models/kategori.dart';
import 'package:organify/screens/listTugasSelesai_page.dart';
import 'package:organify/screens/sign_page.dart';
import 'package:organify/screens/taskCalender_page.dart';
import 'package:organify/screens/task_item.dart';
import 'bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  late String uid;
  String _searchQuery = '';
  int _selectedIndex = 0;
  List<Kategori> _kategoriList = []; // Daftar kategori
  String? _selectedKategori; // Kategori yang sedang dipilih

  late final VoidCallback login;
  final CatatanController _catatanController = CatatanController();
  Map<String, List<Catatan>> filteredCatatans = {
    'sebelumnya': [],
    'hariIni': [],
    'yangAkanDatang': [],
  };

  bool _showSearchBar = false; // State untuk menampilkan searchbar

  get isLoggedIn => widget.isLoggedIn; // Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    login = widget.onLogin;
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {});
    });
    fetchData(); // Ambil data tugas
    fetchKategori(); // Ambil data kategori
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignPage(
              isLoggedIn: false,
              onLogin: () {
                setState(() {
                  uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                });
              },
            ),
          ),
        );
      });
    }
  }

  // Fungsi untuk mengupdate query pencarian
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // Fungsi untuk memfilter catatan berdasarkan query pencarian
  List<Catatan> _filterCatatans(List<Catatan> catatans) {
    if (_searchQuery.isEmpty) {
      return catatans; // Jika query kosong, kembalikan semua catatan
    }
    return catatans.where((catatan) {
      return catatan.namaList.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }


  String formatTanggalRealtime(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, d MMMM', 'id_ID'); // Format: Hari, Tanggal Bulan
    return formatter.format(date);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      _searchQuery = ''; // Reset query pencarian saat search bar ditutup
    });
  }

  Future<void> fetchKategori() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final kategoriController = KategoriController();
        final data = await kategoriController.getKategori(user.uid);
        setState(() {
          _kategoriList = data;
        });
      } catch (e) {
        print('Error fetching kategori: $e');
      }
    }
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

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final data = await _catatanController.getFilteredCatatans(user.uid);
        setState(() {
          filteredCatatans = data;
        });
      } catch (e) {
        print('Error fetching catatans: $e');
      }
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
              catatans: filteredCatatans['sebelumnya']!,
            ),
            _buildSection(
              title: 'Hari Ini',
              isExpanded: _isTodayExpanded,
              onTap: () {
                setState(() {
                  _isTodayExpanded = !_isTodayExpanded;
                });
              },
              catatans: filteredCatatans['hariIni']!,
            ),
            _buildSection(
              title: 'Yang Akan Datang',
              isExpanded: _isUpcomingExpanded,
              onTap: () {
                setState(() {
                  _isUpcomingExpanded = !_isUpcomingExpanded;
                });
              },
              catatans: filteredCatatans['yangAkanDatang']!,
            ),
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
                    color: Color(0xFF222831),
                  ),
                ),
                onChanged: _updateSearchQuery, // Panggil fungsi saat input berubah
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
                  // Chip "Semua"
                  FilterChip(
                    label: Text(
                      'Semua',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    selected: _selectedKategori == null, // Tandai jika tidak ada kategori yang dipilih
                    selectedColor: const Color(0xFF698791),
                    backgroundColor: const Color(0xFFB3C8CF),
                    onSelected: (_) {
                      setState(() {
                        _selectedKategori = null; // Reset filter
                      });
                    },
                  ),
                  const SizedBox(width: 12),

                  // Chip untuk setiap kategori
                  ..._kategoriList.map((kategori) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: FilterChip(
                        label: Text(
                          kategori.kategori,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        selected: _selectedKategori == kategori.kategori, // Tandai jika kategori dipilih
                        selectedColor: const Color(0xFF698791),
                        backgroundColor: const Color(0xFFB3C8CF),
                        onSelected: (_) {
                          setState(() {
                            _selectedKategori = kategori.kategori; // Set filter
                          });
                        },
                      ),
                    );
                  }).toList(),
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
                      alignment: Alignment.center,
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
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
              offset: Offset(0, 40),
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
        formatTanggalRealtime(DateTime.now()), // Tanggal real-time
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
            title: Text(
              'Kategori',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_up, color: Colors.black),
            children: [
              // ListTile untuk "Semua"
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.black),
                title: Text(
                  'Semua',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                trailing: Text(
                  '${filteredCatatans['sebelumnya']!.length + filteredCatatans['hariIni']!.length + filteredCatatans['yangAkanDatang']!.length}',
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () {
                  setState(() {
                    _selectedKategori = null; // Reset filter
                  });
                  Navigator.pop(context); // Tutup drawer
                },
              ),

              // ListTile untuk setiap kategori dari database
              ..._kategoriList.map((kategori) {
                return ListTile(
                  leading: const Icon(Icons.category, color: Colors.black),
                  title: Text(
                    kategori.kategori,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    '${filteredCatatans['sebelumnya']!.where((catatan) => catatan.kategori == kategori.kategori).length + filteredCatatans['hariIni']!.where((catatan) => catatan.kategori == kategori.kategori).length + filteredCatatans['yangAkanDatang']!.where((catatan) => catatan.kategori == kategori.kategori).length}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedKategori = kategori.kategori; // Set filter
                    });
                    Navigator.pop(context); // Tutup drawer
                  },
                );
              }).toList(),

              // ListTile "Buat Baru"
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
                                      ? () async {
                                    if (newCategory != null &&
                                        newCategory!.trim().isNotEmpty) {
                                      try {
                                        final kategoriController =
                                        KategoriController();
                                        await kategoriController.createKategori(
                                            uid, newCategory!);
                                        await fetchKategori(); // Refresh kategori
                                        setState(() {});
                                        Navigator.of(context).pop(); // Tutup dialog
                                      } catch (e) {
                                        print('Error creating kategori: $e');
                                      }
                                    }
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

          // Masukan
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
    required List<Catatan> catatans,
  }) {
    // Filter catatan berdasarkan kategori yang dipilih
    List<Catatan> filteredCatatans = _selectedKategori == null
        ? catatans // Jika tidak ada filter, tampilkan semua
        : catatans.where((catatan) => catatan.kategori == _selectedKategori).toList();

    // Filter catatan berdasarkan query pencarian
    filteredCatatans = _filterCatatans(filteredCatatans);

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
            children: filteredCatatans.map((catatan) {
              return TaskItem(
                taskName: catatan.namaList,
                deadline: DateFormat('dd-MM-yyyy').format(DateTime.parse(catatan.tanggalDeadline)),
                uid: uid,
                idCatatan: catatan.id,
              );
            }).toList(),
          ),
      ],
    );
  }
}