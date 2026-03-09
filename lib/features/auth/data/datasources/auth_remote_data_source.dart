import 'package:dio/dio.dart';
import 'package:to_do_app/core/api/api_error.dart';
import 'package:to_do_app/core/api/api_routes.dart';
import 'package:to_do_app/core/api/base_remote_source.dart';
import 'package:to_do_app/core/config/app_config.dart';
import 'package:to_do_app/features/auth/data/models/auth_session_model.dart';
import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';

class AuthRemoteDataSource extends BaseRemoteSource {
  const AuthRemoteDataSource(super.client);

  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  }) {
    _ensureConfigured();
    return guard(
      request: () => client.postUri(
        ApiRoutes.signIn(),
        data: {
          'email': email.trim(),
          'password': password.trim(),
          'returnSecureToken': true,
        },
      ),
      parser: (json) =>
          AuthSessionModel.fromAuthJson(json as Map<String, dynamic>),
    );
  }

  Future<AuthSessionModel> signUp({
    required String email,
    required String password,
  }) {
    _ensureConfigured();
    return guard(
      request: () => client.postUri(
        ApiRoutes.signUp(),
        data: {
          'email': email.trim(),
          'password': password.trim(),
          'returnSecureToken': true,
        },
      ),
      parser: (json) =>
          AuthSessionModel.fromAuthJson(json as Map<String, dynamic>),
    );
  }

  Future<AuthSessionModel> refreshSession(AuthSession session) {
    _ensureConfigured();
    return guard(
      request: () => client.postUri(
        ApiRoutes.refreshToken(),
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': session.refreshToken,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
      parser: (json) => AuthSessionModel.fromRefreshJson(
        json as Map<String, dynamic>,
        previous: session,
      ),
    );
  }

  void _ensureConfigured() {
    if (!AppConfig.isFirebaseConfigured) {
      throw const ApiError(
        message:
            'Firebase is not configured. Add FIREBASE_API_KEY and FIREBASE_DATABASE_URL.',
        type: ApiErrorType.validation,
      );
    }
  }
}
