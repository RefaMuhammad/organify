import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:organify/screens/sign_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:organify/screens/welcome_screen.dart';
import 'package:organify/screens/home.dart';
import 'package:organify/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLaunch = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunchedBefore = prefs.getBool('hasLaunchedBefore') ?? false;

    setState(() {
      isFirstLaunch = !hasLaunchedBefore;
    });

    if (!hasLaunchedBefore) {
      await prefs.setBool('hasLaunchedBefore', true);
    }
  }

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organify App',
      debugShowCheckedModeBanner: false,
      initialRoute: _determineInitialRoute(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(isLoggedIn: isLoggedIn, onLogin: logout,),
        '/profile': (context) => ProfilePage(isLoggedIn: isLoggedIn),
        '/signpage': (context) => SignPage(isLoggedIn: isLoggedIn, onLogin: logout,),
      },
    );
  }

  String _determineInitialRoute() {
    if (isFirstLaunch) {
      return '/welcome';
    } else {
      return isLoggedIn ? '/home' : '/welcome';
    }
  }
}
