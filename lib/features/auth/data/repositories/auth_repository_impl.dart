import 'package:to_do_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:to_do_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<AuthSession?> restoreSession() async {
    final cachedSession = await localDataSource.getSession();
    if (cachedSession == null) {
      return null;
    }

    if (!cachedSession.isExpired) {
      return cachedSession;
    }

    try {
      final refreshedSession = await remoteDataSource.refreshSession(
        cachedSession,
      );
      await localDataSource.saveSession(refreshedSession);
      return refreshedSession;
    } catch (_) {
      await localDataSource.clearSession();
      return null;
    }
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final session = await remoteDataSource.signIn(
      email: email,
      password: password,
    );
    await localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    final session = await remoteDataSource.signUp(
      email: email,
      password: password,
    );
    await localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<void> signOut() {
    return localDataSource.clearSession();
  }
}
