import 'package:to_do_app/core/api/token_manager.dart';
import 'package:to_do_app/features/auth/data/models/auth_session_model.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._tokenManager);

  final TokenManager _tokenManager;

  Future<void> saveSession(AuthSessionModel session) {
    return _tokenManager.saveSession(session.toStorageString());
  }

  Future<AuthSessionModel?> getSession() async {
    final rawSession = await _tokenManager.readSession();
    if (rawSession == null || rawSession.isEmpty) {
      return null;
    }
    return AuthSessionModel.fromStorageString(rawSession);
  }

  Future<void> clearSession() {
    return _tokenManager.clearSession();
  }
}
