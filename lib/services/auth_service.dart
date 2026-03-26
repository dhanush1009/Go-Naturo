import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_base_url_resolver.dart';

class AuthService {
  static Future<({http.Response response, Map<String, dynamic> body})>
  _postAuthWithFallback(String endpoint, Map<String, dynamic> payload) async {
    final baseUrls = await ApiBaseUrlResolver.getCandidateBaseUrls();

    Exception? lastNetworkError;
    http.Response? lastResponse;
    Map<String, dynamic>? lastBody;

    for (final baseUrl in baseUrls) {
      final authBaseUrl = '$baseUrl/api/auth';

      try {
        final response = await http
            .post(
              Uri.parse('$authBaseUrl/$endpoint'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 10));

        final body = jsonDecode(response.body) as Map<String, dynamic>;

        if (response.statusCode < 500) {
          await ApiBaseUrlResolver.rememberWorkingBaseUrl(baseUrl);
          return (response: response, body: body);
        }

        lastResponse = response;
        lastBody = body;
      } on SocketException catch (e) {
        lastNetworkError = Exception('Network error: ${e.message}');
      } on HttpException catch (e) {
        lastNetworkError = Exception('HTTP error: ${e.message}');
      } on FormatException catch (_) {
        lastNetworkError = Exception('Invalid server response');
      } catch (e) {
        lastNetworkError = Exception('Unable to connect to server: $e');
      }
    }

    if (lastResponse != null && lastBody != null) {
      return (response: lastResponse, body: lastBody);
    }

    throw lastNetworkError ??
        Exception(
          'Unable to reach backend. Use LAN mode (run_mobile_lan.bat) when USB is disconnected.',
        );
  }

  /// Register a new user. Returns user data map on success, throws on error.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await _postAuthWithFallback('register', {
      'name': name,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });

    final response = result.response;
    final body = result.body;
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
    final result = await _postAuthWithFallback('login', {
      'email': email,
      'password': password,
    });

    final response = result.response;
    final body = result.body;
    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    }
    throw Exception(body['error'] ?? 'Login failed');
  }
}
