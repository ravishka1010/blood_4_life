import 'package:blood4life/src/features/authentication/screens/confirm_screen.dart';
import 'package:blood4life/src/features/authentication/screens/donation_page.dart';
import 'package:blood4life/src/features/authentication/screens/find_donor_page.dart';
import 'package:blood4life/src/features/authentication/screens/homepage.dart';
import 'package:blood4life/src/features/authentication/screens/bloodbanks_page.dart';
import 'package:blood4life/src/features/authentication/screens/hospitals_page.dart';
import 'package:blood4life/src/features/authentication/screens/notifications_page.dart';
import 'package:blood4life/src/features/authentication/screens/profile_page.dart';
import 'package:blood4life/src/features/authentication/screens/onboarding_screen.dart';
import 'package:blood4life/src/features/authentication/screens/welcome_screen.dart';
import 'package:blood4life/src/features/authentication/screens/login_screen.dart';
import 'package:blood4life/src/features/authentication/screens/signup_screen.dart';
import 'package:blood4life/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood4Life Sri Lanka',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/confirm': (context) => const ConfirmProfileScreen(),
        '/home': (context) => const HomePage(),
        '/donate': (context) => const DonationPage(),
        '/findDonor': (context) => const FindDonorPage(),
        '/bloodBanks': (context) => const BloodBanksPage(),
        '/hospitals': (context) => const HospitalsPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}