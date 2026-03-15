import 'package:flutter/foundation.dart';
import 'user_state_service.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  Map<String, dynamic>? _user;

  bool get isLoggedIn => _user != null;

  Map<String, dynamic>? get user => _user;

  String get userName => _user?['name'] ?? '';
  String get userEmail => _user?['email'] ?? '';
  int? get userId => _user?['id'] as int?;

  Future<void> login(Map<String, dynamic> userData) async {
    _user = userData;
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
    notifyListeners();
  }
}
