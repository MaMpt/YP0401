import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  String? _token;

  ApiClient(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        final exception = _handleError(error);
        return handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: exception,
        ));
      },
    ));
  }

  void setToken(String? token) {
    _token = token;
  }

  ApiException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return NetworkException();
    }

    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 401:
        return UnauthorizedException();
      case 403:
        return ForbiddenException();
      case 404:
        return NotFoundException(data?['message'] ?? 'Не найдено');
      case 409:
        return ConflictException(data?['message'] ?? 'Конфликт данных');
      case 422:
        final errors = data?['errors'] as Map<String, dynamic>? ?? {};
        return ValidationException(
          errors.map((key, value) => MapEntry(key, value.toString())),
        );
      case 500:
        return ServerException();
      default:
        return ApiException('Неизвестная ошибка', statusCode);
    }
  }

  Future<T> get<T>(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data as T;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  Future<T> post<T>(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data as T;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  Future<T> put<T>(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data as T;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  Future<void> delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }
}
