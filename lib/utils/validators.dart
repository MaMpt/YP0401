class Validators {
  static String? required(String? value, {String fieldName = 'Поле'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName обязательно для заполнения';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email обязателен';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Некорректный email';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String fieldName = 'Поле'}) {
    if (value == null || value.length < min) {
      return '$fieldName должно содержать минимум $min символов';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String fieldName = 'Поле'}) {
    if (value != null && value.length > max) {
      return '$fieldName должно содержать максимум $max символов';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль обязателен';
    }
    if (value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Пароль должен содержать буквы';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Пароль должен содержать цифры';
    }
    return null;
  }
}
