import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with different configurations for web and other platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCofQIcEaxmAmqMrwckJiEU_UBNTMKvJR0",
        authDomain: "smartwatchapp-23fe3.firebaseapp.com",
        projectId: "smartwatchapp-23fe3",
        storageBucket: "smartwatchapp-23fe3.firebasestorage.app",
        messagingSenderId: "603504642203",
        appId: "1:603504642203:web:461df38731e852cecf5e3e",
        measurementId: "G-2CY7TJKD5R",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), // Route to LoginScreen
        '/dashboard': (context) {
          // Example: Fetching userId dynamically
          final userId = FirebaseAuth.instance.currentUser?.uid ??
              ''; // Fetch the userId from FirebaseAuth
          return DashboardScreen(userId: userId); // Pass the userId dynamically
        },
        '/history': (context) {
          // Example: Fetching userId dynamically for HistoryScreen
          final userId = FirebaseAuth.instance.currentUser?.uid ??
              ''; // Fetch the userId from FirebaseAuth
          return HistoryScreen(
              userId: userId); // Pass the userId to HistoryScreen
        },
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
