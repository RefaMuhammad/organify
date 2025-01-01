import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignPage extends StatefulWidget {
  final bool isLoggedIn;
  final VoidCallback onLogin;

  const SignPage({
    Key? key,
    required this.isLoggedIn,
    required this.onLogin,
  }) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn;
  }

  void toggleSignInSignUp() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0E8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: !isLoggedIn
              ? SignInWidget(
            onSwitch: toggleSignInSignUp,
            onLoginSuccess: (bool success) async {
              if (success) {
                widget.onLogin();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      isLoggedIn: true,
                      onLogin: widget.onLogin,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Login gagal. Silakan periksa email atau password."),
                  ),
                );
              }
            },
          )
              : SignUpWidget(onSwitch: toggleSignInSignUp),
        ),
      ),
    );
  }
}

class SignInWidget extends StatefulWidget {
  final VoidCallback onSwitch;
  final Function(bool) onLoginSuccess;

  const SignInWidget({
    Key? key,
    required this.onSwitch,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        widget.onLoginSuccess(true);
      }
    } catch (e) {
      widget.onLoginSuccess(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222831),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Login Form',
            style: GoogleFonts.poppins(
              color: Color(0xFFF1F0E8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1F0E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4E6167),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFF1F0E8),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onSwitch,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F0E8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF4E6167),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              hintText: 'Email',
              hintStyle: GoogleFonts.poppins(
                color: Color(0xFF4E6167),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              hintText: 'Password',
              hintStyle: GoogleFonts.poppins(
                color: Color(0xFF4E6167),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await _login(context);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4E6167),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    color: Color(0xFFF1F0E8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  final VoidCallback onSwitch;

  const SignUpWidget({Key? key, required this.onSwitch}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fullname = _fullnameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (fullname.isEmpty || email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Semua field harus diisi!')),
        );
        return;
      }

      // Buat akun di Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await user?.sendEmailVerification();

      // Simpan hanya fullname ke Firestore
      await FirebaseFirestore.instance.collection('login').doc(user!.uid).set({
        'fullname': fullname, // Hanya menyimpan fullname
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun berhasil dibuat! Silakan cek email Anda untuk verifikasi.'),
        ),
      );

      widget.onSwitch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat akun: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222831),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign Up Form',
            style: GoogleFonts.poppins(
              color: Color(0xFFF1F0E8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1F0E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onSwitch,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F0E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF4E6167),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF4E6167),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            color: Color(0xFFF1F0E8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _fullnameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              hintText: 'Nama Lengkap',
              hintStyle: GoogleFonts.poppins(
                color: Color(0xFF4E6167),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              hintText: 'Email',
              hintStyle: GoogleFonts.poppins(
                color: Color(0xFF4E6167),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              hintText: 'Password',
              hintStyle: GoogleFonts.poppins(
                color: Color(0xFF4E6167),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: signUpUser,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4E6167),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(
                    color: Color(0xFFF1F0E8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}