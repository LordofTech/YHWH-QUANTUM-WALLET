
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _locale = 'en';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _locale = prefs.getString('locale') ?? 'en');
  }

  Future<void> _saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', code);
    setState(() => _locale = code);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language saved. Restart app to apply.')),
    );
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _locale,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'yo', child: Text('Yorùbá')),
                DropdownMenuItem(value: 'ha', child: Text('Hausa')),
                DropdownMenuItem(value: 'pcm', child: Text('Nigerian Pidgin')),
              ],
              onChanged: (v) => _saveLocale(v ?? 'en'),
            ),
            const Divider(height: 32),
            const Text('Account', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}
