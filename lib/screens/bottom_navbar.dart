import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/profile_page.dart';
import 'package:organify/screens/sign_page.dart';
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
  void _showBtmSheet(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white, // Latar belakang BottomSheet
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
              color: Colors.white, // Warna putih penuh untuk Container
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9), // Warna putih untuk TextField
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
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD9D9D9), // Warna putih tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const CategoryButton(),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CalendarPopup();
                          },
                        );
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
                      onTap: () {
                        Navigator.of(context).pop();
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
