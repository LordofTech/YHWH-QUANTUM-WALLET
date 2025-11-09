class Wallet {
  final String id;
  final String type;
  final String? name;
  final double balance;

  Wallet({
    required this.id,
    required this.type,
    required this.balance,
    this.name,
  });

  factory Wallet.fromJson(Map<String, dynamic> j) {
    return Wallet(
      id: j['id'] as String,
      type: j['type'] as String,
      name: j['name'] as String?,
      balance: (j['balance'] as num).toDouble(),
    );
  }
}
