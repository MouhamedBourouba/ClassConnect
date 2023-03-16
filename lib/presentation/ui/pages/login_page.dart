import 'package:ClassConnect/presentation/cubit/authentication/login/login_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/email_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ClassConnect/presentation/cubit/authentication/login/login_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/complete_account_page.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/pages/register_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/authentication_scaffold.dart';
import 'package:ClassConnect/presentation/ui/widgets/button.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:ClassConnect/presentation/ui/widgets/outlined_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
          if (state.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (state.user?.isAccountCompleted() == false) {
                    return const CompleteAccountPage();
                  } else if(!state.isEmailVerified){
                    return const EmailVerificationPage();
                  } else {
                    return const HomePage();
                  }
                },
              ),
              (route) => false,
            );
          }
        },
        child: AuthenticationScaffold(
          body: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: "logo",
                    child: SvgPicture.asset(
                      "assets/images/logo_no_text.svg",
                      width: 200,
                    ),
                  ),
                  Text(
                    "Login",
                    style: theme.textTheme.headline4?.copyWith(color: theme.colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  LoginForm(),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "No account? , ",
                        style: theme.textTheme.bodyLarge,
                      ),
                      GestureDetector(
                        child: Text(
                          "CLICK HERE ",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                      ),
                      Text(
                        "to register",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.watch<LoginCubit>();
    final canRegister = loginCubit.state.password.isNotEmpty &&
        loginCubit.state.email.isNotEmpty &&
        loginCubit.state.password.length > 8;

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            TextFormField(
              initialValue: context.read<LoginCubit>().state.email,
              decoration: const InputDecoration(
                hintText: "email/username",
                border: outlinedInputBorder,
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: loginCubit.onEmailChanged,
            ),
            const SizedBox(height: 6),
            PasswordTextField(
              onChange: loginCubit.onPasswordChanged,
              initValue: context.read<LoginCubit>().state.password,
            ),
            const MDivider(),
            MButton(
              onClick: canRegister ? loginCubit.login : null,
              title: "SingIn",
            ),
          ],
        ),
      ),
    );
  }
}
