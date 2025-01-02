import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/kategori.dart';
import '../services/api_service.dart';

class CategoryMenu extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryMenu({
    super.key,
    required this.onCategorySelected,
  });

  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  List<Kategori> _kategoriList = [];
  bool _isLoading = true;
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
      _fetchKategori(); // Ambil data kategori setelah UID tersedia
    }
  }

  Future<void> _fetchKategori() async {
    if (uid == null) return; // Pastikan UID tersedia

    try {
      final kategoriList = await ApiService().fetchKategori(uid!); // Sertakan UID
      setState(() {
        _kategoriList = kategoriList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching kategori: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF1F0E8).withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              ..._kategoriList.map((kategori) {
                return ListTile(
                  title: Text(kategori.kategori),
                  onTap: () {
                    widget.onCategorySelected(kategori.kategori); // Callback ke CategoryButton
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.black),
              title: Text(
                'Buat Baru',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF222831),
                ),
              ),
              onTap: () {
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
                                    newCategory!.trim().isNotEmpty &&
                                    uid != null) {
                                  try {
                                    await ApiService().createKategori(uid!, newCategory!); // Sertakan UID
                                    _fetchKategori(); // Refresh list kategori
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
              },
            ),
          ],
        ),
      ),
    );
  }
}