import 'api_client.dart';
import '../models/transaction.dart';

class TxService {
  final ApiClient _api = ApiClient();

  Future<List<Tx>> list({required String walletId}) async {
    final res = await _api.get<List<dynamic>>('/tx', query: {
      'wallet_id': walletId,
    });
    final data = res.data ?? [];
    return data
        .map((e) => Tx.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
