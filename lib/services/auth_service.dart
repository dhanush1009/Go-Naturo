import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class AuthService {
  static const String _baseUrl = '${AppConfig.apiBaseUrl}/api/auth';

  /// Register a new user. Returns user data map on success, throws on error.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            if (phone != null && phone.isNotEmpty) 'phone': phone,
          }),
        )
        .timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 201 && body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    }
    throw Exception(body['error'] ?? 'Registration failed');
  }

  /// Login. Returns user data map on success, throws on error.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    }
    throw Exception(body['error'] ?? 'Login failed');
  }
}
