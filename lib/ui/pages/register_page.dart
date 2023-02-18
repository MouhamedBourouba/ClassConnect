import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_app/domain/cubit/authentication/register/register_cubit.dart';
import 'package:school_app/domain/utils/extension.dart';
import 'package:school_app/ui/pages/complete_account_page.dart';
import 'package:school_app/ui/pages/login_page.dart';
import 'package:school_app/ui/widgets/authentication_scaffold.dart';
import 'package:school_app/ui/widgets/button.dart';
import 'package:school_app/ui/widgets/loading.dart';
import 'package:school_app/ui/widgets/outlined_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
          if (state.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => const CompleteAccountPage()),
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
                    "Register",
                    style: theme.textTheme.headline4?.copyWith(color: theme.colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const RegisterForm(),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Already have account? , ",
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
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                      ),
                      Text(
                        "to login",
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

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.watch<RegisterCubit>();
    final canRegister = registerCubit.state.conformPassword.isNotEmpty &&
        registerCubit.state.password.isNotEmpty &&
        registerCubit.state.email.isNotEmpty &&
        registerCubit.state.username.isNotEmpty &&
        registerCubit.state.password.length > 8 &&
        registerCubit.state.conformPassword == registerCubit.state.password &&
        registerCubit.state.email.isEmail();

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: registerCubit.state.username,
              onChanged: registerCubit.onUsernameChanged,
              decoration: const InputDecoration(
                hintText: "username",
                border: outlinedInputBorder,
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: registerCubit.state.email,
              decoration: const InputDecoration(
                hintText: "email",
                border: outlinedInputBorder,
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: registerCubit.onEmailChanged,
              validator: (value) {
                if ((value == "" || value == null) || value.contains("@") && value.contains(".")) return null;
                return "Invalid email";
              },
            ),
            const SizedBox(height: 4),
            PasswordTextField(
              onChange: registerCubit.onPasswordChanged,
              initValue: registerCubit.state.password,
            ),
            const SizedBox(height: 4),
            TextFormField(
              decoration: const InputDecoration(
                border: outlinedInputBorder,
                hintText: "conform password",
                prefixIcon: Icon(Icons.lock),
              ),
              initialValue: registerCubit.state.conformPassword,
              obscureText: true,
              onChanged: registerCubit.onConformPasswordChanged,
              validator: (value) {
                if (value == "" || value == null || value == registerCubit.state.password) return null;
                return "Password dose not match";
              },
            ),
            const MDivider(),
            MButton(
              onClick: canRegister ? registerCubit.register : null,
              title: "SingUp",
            ),
          ],
        ),
      ),
    );
  }
}
