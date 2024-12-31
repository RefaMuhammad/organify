import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryMenu extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoryMenu({
    super.key,
    required this.onCategorySelected,
  });

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
            ListTile(
              title: const Text('Pribadi'),
              onTap: () {
                onCategorySelected('Pribadi'); // Callback ke CategoryButton
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Kerja'),
              onTap: () {
                onCategorySelected('Kerja'); // Callback ke CategoryButton
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Ulang Tahun'),
              onTap: () {
                onCategorySelected('Ulang Tahun'); // Callback ke CategoryButton
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
