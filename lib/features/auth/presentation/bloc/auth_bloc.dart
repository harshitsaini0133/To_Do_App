import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/api/api_error.dart';
import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';
import 'package:to_do_app/features/auth/domain/usecases/restore_session.dart';
import 'package:to_do_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:to_do_app/features/auth/domain/usecases/sign_out.dart';
import 'package:to_do_app/features/auth/domain/usecases/sign_up_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSession restoreSession,
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignOut signOut,
  })  : _restoreSession = restoreSession,
        _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signOut = signOut,
        super(const AuthState(status: AuthStatus.loading)) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthMessageHandled>(_onAuthMessageHandled);
  }

  final RestoreSession _restoreSession;
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignOut _signOut;

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, isSubmitting: false));
    final session = await _restoreSession();
    if (session == null) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearSession: true,
          clearMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        session: session,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        isSubmitting: true,
        clearMessage: true,
      ),
    );

    try {
      final session = await _signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          isSubmitting: false,
          clearMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          isSubmitting: false,
          errorMessage: _messageFrom(error),
          clearSession: true,
        ),
      );
    }
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        isSubmitting: true,
        clearMessage: true,
      ),
    );

    try {
      final session = await _signUpWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          isSubmitting: false,
          clearMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          isSubmitting: false,
          errorMessage: _messageFrom(error),
          clearSession: true,
        ),
      );
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut();
    emit(
      const AuthState(
        status: AuthStatus.unauthenticated,
        isSubmitting: false,
      ),
    );
  }

  void _onAuthMessageHandled(
    AuthMessageHandled event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        status: state.session == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
        clearMessage: true,
      ),
    );
  }

  String _messageFrom(Object error) {
    if (error is ApiError) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
