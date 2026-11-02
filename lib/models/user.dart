enum Role {
  viewer,
  member,
  admin;

  String get displayName {
    switch (this) {
      case Role.viewer:
        return 'Просмотр';
      case Role.member:
        return 'Участник';
      case Role.admin:
        return 'Администратор';
    }
  }
}

class AppUser {
  final String id;
  final String username;
  final String email;
  final Role role;
  final String? avatarUrl;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: Role.values.byName(json['role'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool hasRole(Role requiredRole) {
    return role.index >= requiredRole.index;
  }

  AppUser copyWith({
    String? id,
    String? username,
    String? email,
    Role? role,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
