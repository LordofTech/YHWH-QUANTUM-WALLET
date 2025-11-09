
import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../services/tx_service.dart';

class TxList extends StatefulWidget {
  final String? walletId;
  const TxList({super.key, required this.walletId});

  @override
  State<TxList> createState() => _TxListState();
}

class _TxListState extends State<TxList> {
  final _svc = TxService();
  List<Tx> _txs = [];
  bool _loading = false;

  @override
  void didUpdateWidget(covariant TxList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.walletId != widget.walletId) {
      _load();
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.walletId == null) return;
    setState(() => _loading = true)
    try {
      final rows = await _svc.list(walletId: widget.walletId);
      setState(() => _txs = rows);
    } catch (_) {} finally {
      setState(() => _loading = false)
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (widget.walletId == null) return const SizedBox.shrink();
    if (_txs.isEmpty) return const Text('No transactions yet.');
    return RefreshIndicator(
      onRefresh: () async { await _load(); },
      child: Column(
        children: _txs.take(10).map((t) => ListTile(
        title: Text('${t.type} • ₦${t.amount.toStringAsFixed(2)}'),
        subtitle: Text(t.createdAt.toLocal().toString()),
        trailing: Text(t.status),
        )).toList(),
      ),
    );
  }
}
