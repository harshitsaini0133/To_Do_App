import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/utils/form_utils.dart';
import 'package:to_do_app/core/widgets/app_button.dart';
import 'package:to_do_app/core/widgets/app_error_snackbar.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';
import 'package:to_do_app/core/widgets/task_input_field.dart';
import 'package:to_do_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/presentation/widgets/auth_background.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FormUtils.unfocus(context);
    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state.errorMessage != null) {
          showErrorSnackBar(context, state.errorMessage!);
          context.read<AuthBloc>().add(const AuthMessageHandled());
        }
      },
      child: AuthBackground(
        title: 'Start your system',
        subtitle:
            'Create a focused workspace for tasks, routines, and daily momentum.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskInputField(
                label: 'Email',
                hintText: 'alex@example.com',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: ValidationLogic.email,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
              ),
              AppSpacing.h(context, 18),
              TaskInputField(
                label: 'Password',
                hintText: 'At least 6 characters',
                obscureText: true,
                controller: _passwordController,
                validator: ValidationLogic.password,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ),
              AppSpacing.h(context, 18),
              TaskInputField(
                label: 'Confirm Password',
                hintText: 'Repeat your password',
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) => ValidationLogic.confirmPassword(
                  value,
                  _passwordController.text,
                ),
                prefixIcon: const Icon(Icons.verified_user_outlined),
              ),
              AppSpacing.h(context, 24),
              Builder(
                builder: (context) {
                  final state = context.watch<AuthBloc>().state;
                  return GradientButton(
                    label: 'Create Account',
                    isLoading: state.isSubmitting,
                    onPressed: () => _submit(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
