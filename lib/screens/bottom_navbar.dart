import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organify/screens/profile_page.dart';
import 'package:organify/screens/sign_page.dart';
import '../services/api_service.dart';
import 'category_button.dart';
import 'calendar_popup.dart';

class BottomNavbar extends StatefulWidget {
  final int selectedIndex;
  final bool isLoggedIn;
  final Function(int) onItemTapped;

  const BottomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  String _kategori = '';
  String _namaList = '';
  DateTime _tanggalDeadline = DateTime.now();
  String _selectedCategory = 'kategori'; // Default value
  String? uid; // Tambahkan variabel untuk menyimpan UID

  @override
  void initState() {
    super.initState();
    _fetchUID(); // Ambil UID saat widget diinisialisasi
  }

  // Fungsi untuk mengambil UID
  void _fetchUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  void _updateSelectedCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _showBtmSheet(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buat tugas baru disini',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        counterText: '', // Sembunyikan counter default
                      ),
                      maxLength: 25, // Batasi input menjadi 25 karakter
                      onChanged: (value) {
                        setState(() {
                          _namaList = value;
                        });
                      },
                    )
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Anda bisa menambahkan logika untuk memilih kategori di sini
                      },
                      child: CategoryButton(
                        onCategorySelected: (String category) {
                          setState(() {
                            _kategori = category; // Update nilai _kategori
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDialog<DateTime>(
                          context: context,
                          builder: (BuildContext context) {
                            return const CalendarPopup();
                          },
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _tanggalDeadline = selectedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/tombol_kalender.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (_namaList.isNotEmpty && _kategori.isNotEmpty && uid != null) {
                          try {
                            await ApiService().createCatatan(
                              uid!, // Sertakan UID
                              _kategori,
                              _namaList,
                              _tanggalDeadline as String,
                              false, // Status default (misalnya, false untuk tugas belum selesai)
                            );
                            Navigator.of(context).pop();
                            // Tambahkan logika untuk memperbarui UI atau menampilkan pesan sukses
                          } catch (e) {
                            // Tambahkan logika untuk menangani error
                            print('Error: $e');
                          }
                        } else {
                          // Tampilkan pesan error jika input tidak lengkap
                          print('Kategori, Nama List, dan UID harus diisi');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF828282),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFB3C8CF),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => widget.onItemTapped(0),
              child: Image.asset(
                'assets/button_home.png',
                width: 50,
                height: 50,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                if (!widget.isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignPage(
                        isLoggedIn: widget.isLoggedIn,
                        onLogin: () {
                          setState(() {
                            // Perbarui status login
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  _showBtmSheet(context);
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF222831),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/button_plus.png',
                  width: 70,
                  height: 70,
                  color: Color(0xFFF1F0E8),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(isLoggedIn: widget.isLoggedIn),
                  ),
                );
              },
              child: Image.asset(
                'assets/button_user.png',
                width: 50,
                height: 50,
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}