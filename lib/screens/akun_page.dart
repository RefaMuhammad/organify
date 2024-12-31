import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/welcome_screen.dart';

class AccountPage extends StatelessWidget {
  // Fungsi untuk menampilkan dialog konfirmasi
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.error_outline, color: Colors.black, size: 70),
          content: Text(
            'Apakah Anda yakin ingin menghapus akun ini?\nProses ini bersifat permanen dan tidak dapat diubah.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ), // Teks rata tengah
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan tombol di ujung kiri dan kanan
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Sudut melengkung
                    child: Container(
                      color: Color(0xFFB8B7B7),
                      child: TextButton(
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Jarak antara tombol
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Sudut melengkung
                    child: Container(
                      color: Colors.red,
                      child: TextButton(
                        child: Text(
                          'Lanjutkan',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0E8), // Background color #F1F0E8
      appBar: AppBar(
        title: Text('Akun', style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222831)
        )),
        actions: [
          // Tombol untuk menampilkan popover
          PopupMenuButton<String>(
            icon: Image.asset('assets/tombol_tiga_titik.png', width: 20, height: 20), // Gambar tombol
            offset: Offset(0, kToolbarHeight),
            onSelected: (String value) {
              // Aksi ketika item dipilih
              if (value == 'lupa_password') {
                print('Lupa Password diklik');
                // Tambahkan logika untuk lupa password
              } else if (value == 'hapus_akun') {
                _showDeleteAccountDialog(context); // Tampilkan dialog konfirmasi
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                // Opsi "Lupa Password"
                PopupMenuItem<String>(
                  value: 'lupa_password',
                  child: Text('Lupa Password'),
                ),
                // Opsi "Hapus Akun"
                PopupMenuItem<String>(
                  value: 'hapus_akun',
                  child: Text('Hapus Akun'),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Menghilangkan shadow di AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 1,
              color: Color(0xFFB8B7B7),
            ),
            SizedBox(height: 8),
            Text(
              'Nama',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222831),
              ),
            ),
            // Nama Pengguna
            Text(
              'Septian Hadi Nugroho',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4E6167),
              ),
            ),
            SizedBox(height: 8),
            const Divider(
              thickness: 1,
              color: Color(0xFFB8B7B7),
            ),
            SizedBox(height: 8), // Jarak antara nama dan email
            Text(
              'Email',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222831),
              ),
            ),
            // Email Pengguna
            Text(
              'septianhadingroho4@gmail.com',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4E6167),
              ),
            ),
            SizedBox(height: 8),
            const Divider(
              thickness: 1,
              color: Color(0xFFB8B7B7),
            ),
            Container(
              width: double.infinity, // Lebar container mengisi layar
              padding: const EdgeInsets.all(16), // Padding di sekitar teks
              child: GestureDetector(
                onTap: () {
                  // Navigasi ke WelcomeScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
                child: Container(
                  width: double.infinity, // Lebar container mengisi layar
                  padding: const EdgeInsets.all(16), // Padding di sekitar teks
                  child: Text(
                    'LOGOUT',
                    textAlign: TextAlign.end, // Mengatur alignment teks ke kanan (end)
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF0004),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}