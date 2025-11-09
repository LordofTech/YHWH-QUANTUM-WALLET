
import 'package:flutter/material.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';

class WalletDropdown extends StatefulWidget {
  final void Function(Wallet?) onChanged;
  const WalletDropdown({super.key, required this.onChanged});

  @override
  State<WalletDropdown> createState() => _WalletDropdownState();
}

class _WalletDropdownState extends State<WalletDropdown> {
  final _svc = WalletService();
  List<Wallet> _wallets = [];
  Wallet? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final w = await _svc.list(userId: 'demo-user-uid'); // demo user matches backend seed
      setState(() {
        _wallets = w;
        if (_wallets.isNotEmpty) _selected = _wallets.first;
      });
      widget.onChanged(_selected);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Wallet>(
      value: _selected,
      hint: const Text('Select Wallet'),
      items: _wallets.map((w) => DropdownMenuItem(value: w, child: Text((w.name ?? 'Wallet') + ' (${w.type})'))).toList(),
      onChanged: (val) {
        setState(() => _selected = val);
        widget.onChanged(val);
      },
    );
  }
}
