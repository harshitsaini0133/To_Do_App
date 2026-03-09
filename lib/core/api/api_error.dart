import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  cancelled,
  unknown,
}

class ApiError extends Equatable implements Exception {
  const ApiError({
    required this.message,
    required this.type,
    this.statusCode,
    this.raw,
  });

  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final dynamic raw;

  factory ApiError.fromResponse(Response<dynamic> response) {
    final statusCode = response.statusCode;
    final message = _extractMessage(response.data);
    return ApiError(
      message: message,
      type: _mapStatus(statusCode),
      statusCode: statusCode,
      raw: response.data,
    );
  }

  factory ApiError.fromDio(DioException exception) {
    if (exception.type == DioExceptionType.connectionError) {
      return const ApiError(
        message: 'No internet connection. Check your network and try again.',
        type: ApiErrorType.network,
      );
    }

    if (exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.connectionTimeout) {
      return const ApiError(
        message: 'The request timed out. Please try again.',
        type: ApiErrorType.timeout,
      );
    }

    if (exception.type == DioExceptionType.cancel) {
      return const ApiError(
        message: 'The request was cancelled.',
        type: ApiErrorType.cancelled,
      );
    }

    final response = exception.response;
    if (response != null) {
      return ApiError.fromResponse(response);
    }

    return ApiError(
      message: exception.message ?? 'Something went wrong.',
      type: ApiErrorType.unknown,
      raw: exception.error,
    );
  }

  static ApiErrorType _mapStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
      case 422:
        return ApiErrorType.validation;
      case 401:
        return ApiErrorType.unauthorized;
      case 403:
        return ApiErrorType.forbidden;
      case 404:
        return ApiErrorType.notFound;
      default:
        if ((statusCode ?? 0) >= 500) {
          return ApiErrorType.server;
        }
        return ApiErrorType.unknown;
    }
  }

  static String _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final nested = body['error'];
      if (nested is Map<String, dynamic>) {
        final firebaseCode = nested['message']?.toString();
        if (firebaseCode != null && firebaseCode.isNotEmpty) {
          return _humanizeFirebaseCode(firebaseCode);
        }
      }

      final directMessage =
          body['message']?.toString() ?? body['error']?.toString();
      if (directMessage != null && directMessage.isNotEmpty) {
        return _humanizeFirebaseCode(directMessage);
      }
    }
    if (body is String && body.isNotEmpty) {
      return _humanizeFirebaseCode(body);
    }
    return 'Something went wrong. Please try again.';
  }

  static String _humanizeFirebaseCode(String code) {
    switch (code) {
      case 'EMAIL_EXISTS':
        return 'An account already exists for this email.';
      case 'EMAIL_NOT_FOUND':
        return 'No account was found for this email.';
      case 'INVALID_PASSWORD':
        return 'The password is incorrect.';
      case 'USER_DISABLED':
        return 'This account has been disabled.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'The email or password is incorrect.';
      case 'INVALID_ID_TOKEN':
      case 'TOKEN_EXPIRED':
        return 'Your session has expired. Please sign in again.';
      case 'Permission denied':
      case 'PERMISSION_DENIED':
        return 'Firebase Realtime Database rules rejected this request. Allow the signed-in user to access /users/{uid}/tasks.';
      default:
        return code
            .replaceAll('_', ' ')
            .toLowerCase()
            .replaceFirstMapped(
              RegExp(r'^[a-z]'),
              (match) => match.group(0)!.toUpperCase(),
            );
    }
  }

  @override
  List<Object?> get props => [message, type, statusCode, raw];
}
