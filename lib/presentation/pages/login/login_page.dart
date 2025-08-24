import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmanager/core/utils/page_router.dart';
import 'package:taskmanager/core/utils/toast_util.dart';
import 'package:taskmanager/core/widgets/button.dart';
import 'package:taskmanager/core/widgets/typography.dart';
import 'package:taskmanager/injectable.dart';
import 'package:taskmanager/presentation/pages/login/bloc/auth_bloc.dart';
import 'package:taskmanager/presentation/widgets/custom_text_field.dart';
import 'package:taskmanager/utils/context_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = getIt.get<AuthBloc>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      _bloc.add(LoginRequested(email, password));
    } else {
      showErrorToast('Please enter email and password');
    }
  }

  void _onRegisterPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      _bloc.add(RegisterRequested(email, password));
    } else {
      showErrorToast('Please enter email and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocListener<AuthBloc, AuthState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is AuthLoading) {
            } else if (state is AuthAuthenticated) {
              showSuccessToast('Welcome!');
              context.replace(AppRoutes.home);
            } else if (state is AuthFailure) {
              showErrorToast(state.message);
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    AppTypography(
                      text: 'Task Manager',
                      fontSize: 24,
                    ),
                    const Gap(24),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null ||
                            text.isEmpty ||
                            RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(text) ==
                                false) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: passwordController,
                      obscureText: true,
                      hintText: 'Enter Password',
                    ),
                    CustomButton(
                      onPressed: _onLoginPressed,
                      text: 'Login',
                      margin: const EdgeInsets.only(top: 16),
                    ),
                    CustomButton(
                      onPressed: _onRegisterPressed,
                      text: 'Register',
                      margin: const EdgeInsets.only(top: 0),
                      isOuterButton: true,
                    )
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is! AuthLoading) {
                    return Container();
                  } else {
                    return Positioned.fill(
                      child: ColoredBox(
                        color: context.colorScheme.background.withOpacity(0.5),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
