import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/animations/app_page_route.dart';
import 'package:to_do_app/core/animations/fade_slide_up.dart';
import 'package:to_do_app/core/utils/form_utils.dart';
import 'package:to_do_app/core/widgets/app_button.dart';
import 'package:to_do_app/core/widgets/app_error_snackbar.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';
import 'package:to_do_app/core/widgets/task_input_field.dart';
import 'package:to_do_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/presentation/pages/register_page.dart';
import 'package:to_do_app/features/auth/presentation/widgets/auth_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FormUtils.unfocus(context);
    context.read<AuthBloc>().add(
          AuthSignInRequested(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        showErrorSnackBar(context, state.errorMessage!);
        context.read<AuthBloc>().add(const AuthMessageHandled());
      },
      child: AuthBackground(
        title: 'Welcome back',
        subtitle:
            'Keep your work in motion with a lightweight flow built for focus.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideUp(
                child: TaskInputField(
                  label: 'Email',
                  hintText: 'alex@example.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: ValidationLogic.email,
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                ),
              ),
              AppSpacing.h(context, 18),
              FadeSlideUp(
                delay: const Duration(milliseconds: 80),
                child: TaskInputField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  controller: _passwordController,
                  validator: ValidationLogic.password,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ),
              ),
              AppSpacing.h(context, 22),
              Builder(
                builder: (context) {
                  final state = context.select((AuthBloc bloc) => bloc.state);
                  return FadeSlideUp(
                    delay: const Duration(milliseconds: 140),
                    child: Column(
                      children: [
                        GradientButton(
                          label: 'Log In',
                          isLoading: state.isSubmitting,
                          onPressed: () => _submit(context),
                        ),
                        AppSpacing.h(context, 12),
                        const GradientButton(
                          label: 'Google Sign-In (optional)',
                          variant: ButtonVariant.secondary,
                          icon: Icon(Icons.auto_awesome_rounded),
                          onPressed: null,
                        ),
                      ],
                    ),
                  );
                },
              ),
              AppSpacing.h(context, 18),
              FadeSlideUp(
                delay: const Duration(milliseconds: 220),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Need an account? '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          AppPageRoute(page: const RegisterPage()),
                        );
                      },
                      child: const Text('Create one'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
