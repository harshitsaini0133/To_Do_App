import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmail {
  const SignInWithEmail(this.repository);

  final AuthRepository repository;

  Future<AuthSession> call({
    required String email,
    required String password,
  }) {
    return repository.signIn(email: email, password: password);
  }
}
