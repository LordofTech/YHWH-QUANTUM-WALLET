import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000/api');

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: apiBaseUrl));

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) async {
    final token = await _getToken();
    return _dio.get<T>(
      path,
      queryParameters: query,
      options: Options(headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      }),
    );
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    final token = await _getToken();
    return _dio.post<T>(
      path,
      data: data,
      options: Options(headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Idempotency-Key': DateTime.now().millisecondsSinceEpoch.toString(),
      }),
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_id_token');
  }
}
