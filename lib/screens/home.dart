import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/listTugasSelesai_page.dart';
import 'package:organify/screens/sign_page.dart';
import 'package:organify/screens/taskCalender_page.dart';
import 'package:organify/screens/task_item.dart';
import 'bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/api_service.dart';
import '../models/kategori.dart';
import '../models/catatan.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;
  final VoidCallback onLogin;
  const HomeScreen({Key? key, required this.isLoggedIn, required this.onLogin}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPreviousExpanded = false;
  bool _isTodayExpanded = false;
  bool _isUpcomingExpanded = false;
  int _selectedIndex = 0;
  late final VoidCallback login;
  bool _showSearchBar = false;
  String searchQuery = '';
  Future<List<Kategori>>? futureKategori;
  final ApiService apiService = ApiService();
  Future<List<Catatan>>? futureTugas;
  String? selectedKategori;
  String? uid;

  get isLoggedIn => widget.isLoggedIn;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    login = widget.onLogin;
    fetchUID();
    if (uid != null) {
      futureKategori = apiService.fetchKategori(uid!);
      futureTugas = apiService.fetchCatatan(uid!);
    }
  }

  void fetchUID() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user?.uid;
    });
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

  Map<String, List<Catatan>> _filterTugas(List<Catatan> tugas) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    List<Catatan> sebelumnya = [];
    List<Catatan> hariIni = [];
    List<Catatan> yangAkanDatang = [];

    for (var tugasItem in tugas) {
      if (!tugasItem.status) {
        if ((selectedKategori == null || selectedKategori == 'Semua' || tugasItem.kategori == selectedKategori) &&
            tugasItem.namaList.toLowerCase().contains(searchQuery.toLowerCase())) {
          DateTime deadline = tugasItem.tanggalDeadline;
          if (deadline.isBefore(today)) {
            sebelumnya.add(tugasItem);
          } else if (deadline.isAtSameMomentAs(today)) {
            hariIni.add(tugasItem);
          } else if (deadline.isAfter(today)) {
            yangAkanDatang.add(tugasItem);
          }
        }
      }
    }

    return {
      'sebelumnya': sebelumnya,
      'hariIni': hariIni,
      'yangAkanDatang': yangAkanDatang,
    };
  }

  void _onKategoriSelected(String? kategori) {
    setState(() {
      selectedKategori = kategori;
    });
  }

  Future<void> _launchEmail() async {
    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: 'septianworkingemail@gmail.com',
      queryParameters: {
        'subject': 'Masukan Aplikasi Organify',
        'body': 'Tulis feedback Anda di sini...',
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM', 'id_ID').format(now);
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0E8),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _showSearchBar ? _buildSearchBar() : _buildChipsRow(),
            FutureBuilder<List<Catatan>>(
              future: futureTugas,
              builder: (context, snapshot) {
                if (futureTugas == null) {
                  return Center(child: Text('UID tidak tersedia'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada tugas'));
                } else {
                  Map<String, List<Catatan>> filteredTugas = _filterTugas(snapshot.data!);
                  return Column(
                    children: [
                      _buildSection(
                        title: 'Sebelumnya',
                        isExpanded: _isPreviousExpanded,
                        onTap: () {
                          setState(() {
                            _isPreviousExpanded = !_isPreviousExpanded;
                          });
                        },
                        tasks: filteredTugas['sebelumnya']!
                            .map((tugas) => TaskItem(
                          id: tugas.id,
                          taskName: tugas.namaList,
                          deadline: DateFormat('dd-MM-yyyy').format(tugas.tanggalDeadline),
                        ))
                            .toList(),
                      ),
                      _buildSection(
                        title: 'Hari Ini',
                        isExpanded: _isTodayExpanded,
                        onTap: () {
                          setState(() {
                            _isTodayExpanded = !_isTodayExpanded;
                          });
                        },
                        tasks: filteredTugas['hariIni']!
                            .map((tugas) => TaskItem(
                          id: tugas.id,
                          taskName: tugas.namaList,
                          deadline: DateFormat('dd-MM-yyyy').format(tugas.tanggalDeadline),
                        ))
                            .toList(),
                      ),
                      _buildSection(
                        title: 'Yang Akan Datang',
                        isExpanded: _isUpcomingExpanded,
                        onTap: () {
                          setState(() {
                            _isUpcomingExpanded = !_isUpcomingExpanded;
                          });
                        },
                        tasks: filteredTugas['yangAkanDatang']!
                            .map((tugas) => TaskItem(
                          id: tugas.id,
                          taskName: tugas.namaList,
                          deadline: DateFormat('dd-MM-yyyy').format(tugas.tanggalDeadline),
                        ))
                            .toList(),
                      ),
                    ],
                  );
                }
              },
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
        isLoggedIn: isLoggedIn,
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
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color(0xFFD9D9D9),
            width: 1,
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
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222831),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
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
              child: FutureBuilder<List<Kategori>>(
                future: futureKategori,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Tidak ada kategori');
                  } else {
                    List<Kategori> kategoriList = snapshot.data!;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => _onKategoriSelected('Semua'),
                          child: Chip(
                            label: Text('Semua',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                )),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: selectedKategori == 'Semua'
                                ? const Color(0xFF698791)
                                : const Color(0xFFB3C8CF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ...kategoriList.map((kategori) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => _onKategoriSelected(kategori.kategori),
                              child: Chip(
                                label: Text(kategori.kategori,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: selectedKategori == kategori.kategori
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: selectedKategori == kategori.kategori
                                    ? const Color(0xFF698791)
                                    : const Color(0xFFB3C8CF),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          PopupMenuButton<String>(
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
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM', 'id_ID').format(now);

    return AppBar(
      backgroundColor: const Color(0xFFF1F0E8),
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Text(
        formattedDate,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
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
                trailing: const Text('5', style: TextStyle(color: Colors.black)),
                onTap: () {
                  _onKategoriSelected('Semua');
                },
              ),
              FutureBuilder<List<Kategori>>(
                future: futureKategori,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Tidak ada kategori');
                  } else {
                    List<Kategori> kategoriList = snapshot.data!;
                    return Column(
                      children: kategoriList.map((kategori) {
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
                            '${kategori.jumlahCatatan}',
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            _onKategoriSelected(kategori.kategori);
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignPage(
                          isLoggedIn: widget.isLoggedIn,
                          onLogin: () {
                            setState(() {
                              widget.onLogin();
                            });
                          },
                        ),
                      ),
                    );
                  } else {
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
                                        isInputFilled = newCategory != null && newCategory!.trim().isNotEmpty;
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
                                    Navigator.of(context).pop();
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
                                    if (newCategory != null && newCategory!.trim().isNotEmpty) {
                                      try {
                                        await ApiService().createKategori(uid!, newCategory!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Kategori berhasil ditambahkan'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                        setState(() {
                                          futureKategori = ApiService().fetchKategori(uid!);
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Gagal menambahkan kategori: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                      : null,
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
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.black),
            title: const Text('Masukan'),
            onTap: _launchEmail,
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