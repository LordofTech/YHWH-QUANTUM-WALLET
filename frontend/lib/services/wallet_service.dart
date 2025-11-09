import 'api_client.dart';
import '../models/wallet.dart';

class WalletService {
  final ApiClient _api = ApiClient();

  Future<List<Wallet>> list({required String userId}) async {
    final res = await _api.get<List<dynamic>>('/wallet');
    final data = res.data ?? [];
    return data
        .map((e) => Wallet.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
