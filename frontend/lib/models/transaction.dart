class Tx {
  final String id;
  final String type;
  final double amount;
  final String status;
  final DateTime createdAt;

  Tx({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Tx.fromJson(Map<String, dynamic> j) {
    return Tx(
      id: j['id'] as String,
      type: j['type'] as String,
      amount: (j['amount'] as num).toDouble(),
      status: j['status'] as String? ?? 'completed',
      createdAt: DateTime.parse(j['created_at'] as String),
    );
  }
}
