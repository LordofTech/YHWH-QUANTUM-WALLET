
import 'package:flutter/material.dart';
import 'login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final tok = prefs.getString('firebase_id_token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => tok != null ? const DashboardScreen() : const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00A86B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/wallet_icon.png', width: 80),
            const SizedBox(height: 16),
            const Text('Quantum Wallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
