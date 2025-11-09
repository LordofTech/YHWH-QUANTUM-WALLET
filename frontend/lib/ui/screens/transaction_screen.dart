
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Wallet? _selectedWallet;
  final _amount = TextEditingController();
  String _type = 'airtime';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('From Wallet'),
            const SizedBox(height: 8),
            WalletDropdown(onChanged: (w) => setState(() => _selectedWallet = w)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'airtime', child: Text('Airtime')),
                DropdownMenuItem(value: 'p2p', child: Text('P2P Transfer')),
                DropdownMenuItem(value: 'bill', child: Text('Bill Payment')),
              ],
              onChanged: (v) => setState(() => _type = v ?? 'airtime'),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pretend sending $_type of ₦${_amount.text}…')),
                );
              },
              child: const Text('Send'),
            )
          ],
        ),
      ),
    );
  }
}
