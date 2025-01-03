import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_page.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka URL di browser

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isChecked = false; // Status checkbox

  // Fungsi untuk membuka URL Privacy Policy
  void _launchPrivacyPolicy() async {
    const url = 'https://github.com/RefaMuhammad/organify/blob/master/README.md'; // Ganti dengan URL Privacy Policy Anda
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF1F0E8), // Warna latar belakang
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0), // Jarak dari atas layar
          child: Column(
            mainAxisSize: MainAxisSize.max, // Kolom hanya selebar kontennya
            crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara horizontal
            children: [
              const SizedBox(height: 20),
              Text(
                'Organify',
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Jarak antar elemen
              Image.asset('assets/filling_survey.png'),
              const SizedBox(height: 10), // Jarak antar elemen
              Text(
                'Selamat Datang di Organify',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Jarak antar elemen
              Container(
                margin: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: Text(
                  'Atur, rencanakan dan capai tujuanmu dengan mudah. Hidup lebih terorganisasi dimulai dari sini.',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20), // Jarak antara teks dan checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Pusatkan checkbox dan teks
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false; // Update status checkbox
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: _launchPrivacyPolicy, // Buka URL saat teks diklik
                    child: Text(
                      'Saya sudah membaca Privacy Policy',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue, // Warna teks seperti link
                        decoration: TextDecoration.underline, // Garis bawah seperti link
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Jarak antara checkbox dan tombol
              ElevatedButton(
                onPressed: isChecked
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignPage(
                        isLoggedIn: false, // Contoh nilai
                        onLogin: () {
                          // Tindakan ketika login berhasil
                          print("Silahkan Login");
                        },
                      ),
                    ),
                  );
                }
                    : null, // Nonaktifkan tombol jika checkbox tidak dicentang
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222831), // Warna tombol
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 12.0), // Ukuran tombol
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Ayo Mulai!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Warna teks tombol
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}