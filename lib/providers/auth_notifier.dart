import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../repositories/api_client.dart';
import '../repositories/api_exceptions.dart';

class AuthNotifier extends ChangeNotifier {
  final ApiClient _apiClient;
  AppUser? _user;
  String? _token;
  bool _isLoading = false;

  AuthNotifier(this._apiClient);

  AppUser? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isLoading => _isLoading;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null) {
      _apiClient.setToken(_token);
      try {
        await _loadUser();
      } catch (e) {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> _loadUser() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/auth/me');
    _user = AppUser.fromJson(data['user']);
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        {'username': username, 'password': password},
      );

      _token = data['token'] as String;
      _user = AppUser.fromJson(data['user']);
      _apiClient.setToken(_token);

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
    _apiClient.setToken(null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }
}
