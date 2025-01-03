import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = true;
  late String uid = '';

  @override
  void initState() {
    super.initState();
    _getUid(); // Ambil UID saat inisialisasi
  }

  // Fungsi untuk mengambil UID dari FirebaseAuth
  void _getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid; // Simpan UID ke variabel
      });
    }
  }

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
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                          Navigator.of(context).pop();
                          _showPasswordDialog(context);
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

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan Password Anda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _isPasswordValid = value.isNotEmpty;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus Akun'),
              onPressed: _isPasswordValid ? () => _deleteAccount(context) : null,
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: _passwordController.text,
          ),
        );

        await user.delete();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      }
    } catch (e) {
      String errorMessage = "Terjadi kesalahan, coba lagi nanti.";
      if (e is FirebaseAuthException) {
        if (e.code == 'requires-recent-login') {
          errorMessage = "Anda perlu login kembali untuk menghapus akun.";
        }
      }
      _showErrorDialog(context, errorMessage);
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Gagal Menghapus Akun',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: Text(
            errorMessage,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
        _showInfoDialog(context, "Email reset password sudah dikirim. Silakan cek inbox Anda.");
      }
    } catch (e) {
      String errorMessage = "Terjadi kesalahan, coba lagi nanti.";
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = "Email tidak ditemukan.";
        }
      }
      _showErrorDialog(context, errorMessage);
    }
  }

  void _showInfoDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Info',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> clearLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('Pengguna tidak ditemukan'));
    }

    return Scaffold(
      backgroundColor: Color(0xFFF1F0E8),
      appBar: AppBar(
        title: Text('Akun', style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222831)
        )),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'lupa_password') {
                _resetPassword(context);
              } else if (value == 'hapus_akun') {
                _showDeleteAccountDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(value: 'lupa_password', child: Text('Lupa Password')),
                PopupMenuItem<String>(value: 'hapus_akun', child: Text('Hapus Akun')),
              ];
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('login').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Data pengguna tidak ditemukan'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String fullname = userData['fullname'] ?? 'Nama tidak tersedia';
          String email = user.email ?? 'Email tidak tersedia'; // Ambil email dari Firebase Auth

          return Padding(
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
                Text(
                  fullname,
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
                SizedBox(height: 8),
                Text(
                  'Email',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222831),
                  ),
                ),
                Text(
                  email,
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
                GestureDetector(
                  onTap: () async {
                    try {
                      await clearLocalData();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            (Route<dynamic> route) => false,
                      );
                    } catch (e) {
                      _showErrorDialog(context, "Terjadi kesalahan saat logout. Coba lagi.");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'LOGOUT',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF0004),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}