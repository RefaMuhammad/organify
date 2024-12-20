import 'package:flutter/material.dart';
import 'package:organify/screens/welcome_screen.dart';
import 'package:organify/screens/home.dart';
import 'package:organify/screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organify App',
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      initialRoute: '/welcome', // Halaman awal saat aplikasi dibuka
      routes: {
        '/welcome': (context) => const WelcomeScreen(), // Halaman Welcome
        '/home': (context) => const HomeScreen(),         // Halaman Home
        '/profile': (context) => ProfilePage(isLoggedIn: false), // Halaman Profile
      },
    );
  }
}
