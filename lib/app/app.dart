import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/di/service_locator.dart';
import 'package:to_do_app/core/theme/app_theme.dart';
import 'package:to_do_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/presentation/pages/login_page.dart';
import 'package:to_do_app/features/auth/presentation/pages/splash_page.dart';
import 'package:to_do_app/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:to_do_app/features/tasks/presentation/pages/dashboard_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(const AuthStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<TaskBloc>(),
        ),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.status != current.status || previous.session != current.session,
        listener: (context, state) {
          final taskBloc = context.read<TaskBloc>();
          if (state.status == AuthStatus.authenticated && state.session != null) {
            taskBloc.add(TasksRequested(state.session!));
          } else {
            taskBloc.add(const TasksCleared());
          }
        },
        child: const _AppShell(),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final state = context.watch<AuthBloc>().state;
        return AnimatedSwitcher(
          duration: AppConstants.mediumAnimation,
          child: switch (state.status) {
            AuthStatus.loading => const SplashPage(key: ValueKey('splash')),
            AuthStatus.authenticated =>
              const DashboardPage(key: ValueKey('dashboard')),
            AuthStatus.unauthenticated || AuthStatus.error =>
              const LoginPage(key: ValueKey('login')),
          },
        );
      },
    );
  }
}
