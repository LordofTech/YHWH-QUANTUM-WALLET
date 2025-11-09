
import 'package:flutter/material.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _synced = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _synced = true);
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Device')),
      body: Center(
        child: _synced
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text('Sync Complete!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Your offline transactions are updated.'),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotationTransition(turns: _controller, child: const Icon(Icons.sync, size: 80, color: Color(0xFF00A86B))),
                  const SizedBox(height: 16),
                  const Text('Syncing with Device...', style: TextStyle(fontSize: 18)),
                ],
              ),
      ),
    );
  }
}
