import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../repositories/mock_auth_api.dart';

class AuthNotifier extends ChangeNotifier {
  AppUser? _user;
  String? _token;
  bool _isLoading = false;

  AuthNotifier();

  AppUser? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isLoading => _isLoading;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null) {
      try {
        await _loadUser();
      } catch (e) {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> _loadUser() async {
    final data = await MockAuthApi.getMe(_token!);
    _user = AppUser.fromJson(data['user']);
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await MockAuthApi.login(username, password);

      _token = data['token'] as String;
      _user = AppUser.fromJson(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }
}
