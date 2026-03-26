import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class ApiBaseUrlResolver {
  static const String _lastWorkingBaseUrlKey = 'last_working_api_base_url';

  static Future<List<String>> getCandidateBaseUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_lastWorkingBaseUrlKey);
    final configured = _normalize(AppConfig.apiBaseUrl);

    final candidates = <String>[];

    if (saved != null && saved.trim().isNotEmpty) {
      final normalizedSaved = _normalize(saved);
      if (normalizedSaved.isNotEmpty) {
        candidates.add(normalizedSaved);
      }
    }

    if (!candidates.contains(configured)) {
      candidates.add(configured);
    }

    return candidates;
  }

  static Future<void> rememberWorkingBaseUrl(String baseUrl) async {
    final normalized = _normalize(baseUrl);
    if (normalized.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastWorkingBaseUrlKey, normalized);
  }

  static String _normalize(String url) {
    return url.trim().replaceFirst(RegExp(r'/+$'), '');
  }
}
