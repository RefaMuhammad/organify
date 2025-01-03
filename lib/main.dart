import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:organify/screens/sign_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:organify/screens/welcome_screen.dart';
import 'package:organify/screens/home.dart';
import 'package:organify/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organify App',
      debugShowCheckedModeBanner: false,
      home: AppEntryPoint(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(
          isLoggedIn: true,  // Pass the 'isLoggedIn' value
          onLogin: () {},    // You can pass the logout handler here
        ),
        '/signpage': (context) => SignPage(
          isLoggedIn: false,  // Pass the 'isLoggedIn' value
          onLogin: () {},     // You can pass the login handler here
        ),
        '/profile': (context) => ProfilePage(
          isLoggedIn: true,   // Pass the 'isLoggedIn' value
        ),
      },
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  @override
  _AppEntryPointState createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool isFirstLaunch = true;
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasLaunchedBefore = prefs.getBool('hasLaunchedBefore') ?? false;
      final sharedPrefLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      final firebaseUser = FirebaseAuth.instance.currentUser;

      setState(() {
        isFirstLaunch = !hasLaunchedBefore;
        isLoggedIn = firebaseUser != null || sharedPrefLoggedIn;
      });

      if (!hasLaunchedBefore) {
        await prefs.setBool('hasLaunchedBefore', true);
      }

      if (firebaseUser != null && !sharedPrefLoggedIn) {
        await prefs.setBool('isLoggedIn', true);
      }
    } catch (e) {
      print('Error initializing app: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isFirstLaunch) {
      return WelcomeScreen();
    }

    return isLoggedIn
        ? HomeScreen(isLoggedIn: isLoggedIn, onLogin: _handleLogout)
        : SignPage(isLoggedIn: isLoggedIn, onLogin: _handleLogin);
  }

  void _handleLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    setState(() {
      isLoggedIn = true;
    });
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await FirebaseAuth.instance.signOut();

    setState(() {
      isLoggedIn = false;
    });
  }
}