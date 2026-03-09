import 'package:to_do_app/config/firebase_config.dart';

class ApiRoutes {
  const ApiRoutes._();

  static Uri signIn() => Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithPassword',
        {'key': FirebaseConfig.apiKey},
      );

  static Uri signUp() => Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signUp',
        {'key': FirebaseConfig.apiKey},
      );

  static Uri refreshToken() => Uri.https(
        'securetoken.googleapis.com',
        '/v1/token',
        {'key': FirebaseConfig.apiKey},
      );

  static Uri userTasks(String userId, {String? authToken}) {
    return _databaseUri(
      '/users/$userId/tasks.json',
      authToken == null ? null : {'auth': authToken},
    );
  }

  static Uri taskById(
    String userId,
    String taskId, {
    required String authToken,
  }) {
    return _databaseUri(
      '/users/$userId/tasks/$taskId.json',
      {'auth': authToken},
    );
  }

  static Uri _databaseUri(String path, [Map<String, String>? queryParameters]) {
    final base = Uri.parse(FirebaseConfig.databaseUrl);
    final basePath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return base.replace(
      path: '$basePath$normalizedPath',
      queryParameters: queryParameters,
    );
  }
}
