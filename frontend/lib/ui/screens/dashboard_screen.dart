
import 'package:flutter/material.dart';
import 'sync_screen.dart';
import 'transaction_screen.dart';
import 'settings_screen.dart';
import '../widgets/wallet_dropdown.dart';
import '../widgets/tx_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: const Color(0xFF00A86B),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _walletSection(context),
          const SizedBox(height: 16),
          _actionButton(context, 'Sync Device', Icons.sync, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncScreen()))),
          _actionButton(context, 'Send Money', Icons.send, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionScreen()))),
          _actionButton(context, 'Pay Bill', Icons.receipt, () {}),
          _actionButton(context, 'Savings', Icons.savings, () {}),
        ],
      ),
    );
  }

  Widget _walletSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    WalletDropdown(
                      onChanged: (wallet) {
                        setState(() {
                          _selectedWalletId = wallet?.id;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recent Transactions',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            TxList(walletId: _selectedWalletId),
          ],
        ),
      ),
    );
  }

  Widget _balanceCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Total Balance', style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 4),
          Text('₦25,400', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Chip(label: Text('Primary')),
              SizedBox(width: 8),
              Text('• Active', style: TextStyle(color: Colors.green)),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _actionButton(BuildContext context, String title, IconData icon, VoidCallback onTap) => Card(
    child: ListTile(
      leading: Icon(icon, color: const Color(0xFF00A86B)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}
