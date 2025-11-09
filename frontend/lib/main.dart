
import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/theme/app_theme.dart';

void main() {
  runApp(const QuantumWalletApp());
}

class QuantumWalletApp extends StatelessWidget {
  const QuantumWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Wallet',
      theme: AppTheme.light,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
