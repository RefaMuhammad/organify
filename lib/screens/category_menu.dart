import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/controllers/kategori.dart'; // Import KategoriController
import 'package:organify/models/kategori.dart'; // Import model Kategori
import 'package:firebase_auth/firebase_auth.dart';

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
  final KategoriController _kategoriController = KategoriController();
  List<Kategori> kategoriList = [];
  late String uid;

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  // Fungsi untuk mengambil kategori dari database
  Future<void> _fetchKategori() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      try {
        final kategori = await _kategoriController.getKategori(uid);
        setState(() {
          kategoriList = kategori;
        });
      } catch (e) {
        print('Error fetching kategori: $e');
      }
    }
  }

  // Fungsi untuk membuat kategori baru
  Future<void> _createKategori(String nama) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _kategoriController.createKategori(user.uid, nama);
        _fetchKategori(); // Refresh daftar kategori setelah membuat baru
      } catch (e) {
        print('Error creating kategori: $e');
      }
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
            // Tampilkan kategori dari database
            for (var kategori in kategoriList)
              ListTile(
                title: Text(kategori.kategori),
                onTap: () {
                  print('Kategori dipilih(menu): ${kategori.kategori}'); // Debugging
                  widget.onCategorySelected?.call(kategori.kategori); // Panggil callback
                  Navigator.of(context).pop();
                },
              ),
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
                // Tampilkan dialog untuk membuat kategori baru
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
                                  _createKategori(newCategory!); // Buat kategori baru
                                  Navigator.of(context).pop(); // Tutup dialog
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