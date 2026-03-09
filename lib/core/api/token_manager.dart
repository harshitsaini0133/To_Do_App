import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  TokenManager([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _sessionKey = 'auth_session';

  final FlutterSecureStorage _storage;

  Future<void> saveSession(String sessionJson) {
    return _storage.write(key: _sessionKey, value: sessionJson);
  }

  Future<String?> readSession() {
    return _storage.read(key: _sessionKey);
  }

  Future<void> clearSession() {
    return _storage.delete(key: _sessionKey);
  }
}
