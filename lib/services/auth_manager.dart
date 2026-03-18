import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_state_service.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();
  static const String _sessionKey = 'auth_user_session';
  factory AuthManager() => _instance;
  AuthManager._internal();

  Map<String, dynamic>? _user;
  bool _isInitialized = false;

  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized;

  Map<String, dynamic>? get user => _user;

  String get userName => _user?['name'] ?? '';
  String get userEmail => _user?['email'] ?? '';
  int? get userId => _user?['id'] as int?;

  static Future<void> initialize() async {
    await _instance._restoreSession();
  }

  Future<void> _restoreSession() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          _user = _normalizeUserData(decoded);
        } else if (decoded is Map) {
          _user = _normalizeUserData(Map<String, dynamic>.from(decoded));
        }
      } catch (_) {
        _user = null;
      }
    }

    _isInitialized = true;
    notifyListeners();

    final id = userId;
    if (id != null) {
      try {
        await UserStateService.applyUserStateToManagers(id);
      } catch (_) {
        // Keep session restored even if state sync fails temporarily.
      }
    }
  }

  Map<String, dynamic> _normalizeUserData(Map<String, dynamic> userData) {
    final normalized = Map<String, dynamic>.from(userData);
    final rawId = normalized['id'];

    if (rawId is int) {
      normalized['id'] = rawId;
    } else if (rawId is num) {
      normalized['id'] = rawId.toInt();
    } else if (rawId is String) {
      normalized['id'] = int.tryParse(rawId);
    }

    return normalized;
  }

  Future<void> _persistSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user == null) {
      await prefs.remove(_sessionKey);
      return;
    }
    await prefs.setString(_sessionKey, jsonEncode(_user));
  }

  Future<void> login(Map<String, dynamic> userData) async {
    _user = _normalizeUserData(userData);
    await _persistSession();
    notifyListeners();

    final id = userId;
    if (id != null) {
      try {
        await UserStateService.applyUserStateToManagers(id);
      } catch (_) {
        // Keep login successful even if state sync fails temporarily.
      }
    }
  }

  void logout() {
    _user = null;
    UserStateService.clearLocalState();
    _persistSession();
    notifyListeners();
  }
}
