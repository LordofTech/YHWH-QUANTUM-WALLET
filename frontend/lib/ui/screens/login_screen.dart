
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController(text: '+234');
  bool _loading = false;
  String? _lastError;

  Future<String?> _promptCode() async {
    String code = '';
    return await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter SMS Code'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (v) => code = v,
          decoration: const InputDecoration(hintText: '123456'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(code), child: const Text('Verify')),
        ],
      ),
    );
  }

  Future<void> _login() async {
    setState(() { _loading = true; _lastError = null; });
    try {
      await AuthService.init();
      final token = await AuthService.signInWithPhone(
        phone: _phoneCtrl.text.trim(),
        getSmsCode: _promptCode,
      );
      if (token != null) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        return;
      }
      setState(() => _lastError = 'Verification timed out or cancelled.');
    } catch (e) {
      setState(() => _lastError = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: '+2348012345678'
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Send OTP'),
              ),
            ),
            if (_lastError != null) ...[
              const SizedBox(height: 12),
              Text(_lastError!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
