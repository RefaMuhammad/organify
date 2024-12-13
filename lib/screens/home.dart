import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F0E8),
        centerTitle: true, // Pusatkan teks
        automaticallyImplyLeading: false,
        title: Text(
          'Rabu, 18 Desember',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Tombol kalender di kiri
        leading: IconButton(
          onPressed: () {
            // Aksi untuk tombol kalender
          },
          icon: Image.asset(
            'assets/button_kalender.png', // Path ikon kalender
            width: 24,
            height: 24,
          ),
        ),
        // Tombol list di kanan
        actions: [
          IconButton(
            onPressed: () {
              // Aksi untuk tombol list
            },
            icon: Image.asset(
              'assets/button_list.png', // Path ikon list
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F0E8),
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // Jarak horizontal antar Chip
          runSpacing: 4.0, // Jarak vertikal antar Chip
          children: [
            Chip(
              label: Text('Flutter'),
            ),
            Chip(
              label: Text('Dart'),
            ),
            Chip(
              label: Text('Kotlin'),
            ),
            Chip(
              label: Text('Android'),
            ),
            Chip(
              label: Text('iOS'),
            ),
          ],
        ),
      ),
          ),
    );
  }
}
