import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/auth/domain/repositories/auth_repository.dart';

class RestoreSession {
  const RestoreSession(this.repository);

  final AuthRepository repository;

  Future<AuthSession?> call() {
    return repository.restoreSession();
  }
}
