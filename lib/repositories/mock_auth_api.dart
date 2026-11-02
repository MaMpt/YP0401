import '../models/user.dart';

class MockAuthApi {
  static final List<AppUser> _users = [
    AppUser(
      id: '1',
      username: 'viewer',
      email: 'viewer@taskmanager.local',
      role: Role.viewer,
      createdAt: DateTime.now(),
    ),
    AppUser(
      id: '2',
      username: 'member',
      email: 'member@taskmanager.local',
      role: Role.member,
      createdAt: DateTime.now(),
    ),
    AppUser(
      id: '3',
      username: 'admin',
      email: 'admin@taskmanager.local',
      role: Role.admin,
      createdAt: DateTime.now(),
    ),
  ];

  static final Map<String, String> _passwords = {
    'viewer': 'password123',
    'member': 'password123',
    'admin': 'password123',
  };

  static Future<Map<String, dynamic>> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_passwords[username] != password) {
      throw Exception('Неверный логин или пароль');
    }

    final user = _users.firstWhere((u) => u.username == username);
    final token = 'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  static Future<Map<String, dynamic>> getMe(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final userId = token.split('_')[2];
    final user = _users.firstWhere((u) => u.id == userId);

    return {
      'user': user.toJson(),
    };
  }
}
