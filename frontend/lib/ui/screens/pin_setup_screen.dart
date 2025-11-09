
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String pin = '';

  void _addDigit(String digit) {
    setState(() {
      if (pin.length < 4) pin += digit;
      if (pin.length == 4) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Set Your PIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 16, height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < pin.length ? const Color(0xFF00A86B) : Colors.grey,
                ),
              )),
            ),
            const Spacer(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              children: [
                ...['1','2','3','4','5','6','7','8','9'].map((d) => _key(d)),
                const SizedBox(),
                _key('0'),
                _backspace(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _key(String text) => TextButton(
    onPressed: () => _addDigit(text),
    child: Text(text, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
  );

  Widget _backspace() => TextButton(
    onPressed: () => setState(() => pin = pin.isNotEmpty ? pin.substring(0, pin.length - 1) : ''),
    child: const Icon(Icons.backspace, size: 28),
  );
}
