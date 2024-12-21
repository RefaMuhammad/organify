import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organify/screens/home.dart';

class SignPage extends StatefulWidget {
  final bool isLoggedIn;
  final VoidCallback onLogin; // tambahkan ini

  const SignPage({
    Key? key,
    required this.isLoggedIn,
    required this.onLogin, // tambahkan ini
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
            onLoginSuccess: (bool success) {
              if (success) {
                widget.onLogin();// panggil fungsi login dari MyApp
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(isLoggedIn: true, onLogin: () {
                      print("Callback onLogin dipanggil");
                      },
                    ),
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

class SignInWidget extends StatelessWidget {
  final VoidCallback onSwitch;
  final Function(bool) onLoginSuccess;

  const SignInWidget({
    Key? key,
    required this.onSwitch,
    required this.onLoginSuccess,
  }) : super(key: key);

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
                    onTap: onSwitch,
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
            onTap: () => onLoginSuccess(true),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4E6167),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
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
        ],
      ),
    );
  }
}

class SignUpWidget extends StatelessWidget {
  final VoidCallback onSwitch;

  const SignUpWidget({Key? key, required this.onSwitch}) : super(key: key);

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
                    onTap: onSwitch,
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
            onTap: onSwitch,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4E6167),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
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
        ],
      ),
    );
  }
}