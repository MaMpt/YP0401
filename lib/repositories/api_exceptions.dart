class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException() : super('Ошибка сети. Проверьте подключение к интернету.');
}

class ValidationException extends ApiException {
  final Map<String, String> errors;

  ValidationException(this.errors)
      : super('Ошибка валидации', 422);
}

class ConflictException extends ApiException {
  ConflictException(String message) : super(message, 409);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Требуется авторизация', 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException() : super('Доступ запрещён', 403);
}

class ServerException extends ApiException {
  ServerException() : super('Ошибка сервера', 500);
}
