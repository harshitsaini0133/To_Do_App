import 'package:to_do_app/features/auth/domain/repositories/auth_repository.dart';

class SignOut {
  const SignOut(this.repository);

  final AuthRepository repository;

  Future<void> call() {
    return repository.signOut();
  }
}
