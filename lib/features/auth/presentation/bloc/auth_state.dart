part of 'auth_bloc.dart';

enum AuthStatus { loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.session,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthSession? session;
  final bool isSubmitting;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    bool isSubmitting = false,
    String? errorMessage,
    bool clearSession = false,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      isSubmitting: isSubmitting,
      errorMessage: clearMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, session, isSubmitting, errorMessage];
}
