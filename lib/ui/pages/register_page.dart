import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_app/domain/bloc/authentication/screen_status.dart';
import 'package:school_app/domain/bloc/authentication/register/register_cubit.dart';
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

    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.authStatus == ScreenStatus.error) {
          hideLoading(context);
          Fluttertoast.showToast(msg: state.error, backgroundColor: Colors.red);
        }
        if (state.authStatus == ScreenStatus.success) {
          hideLoading(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const CompleteAccountPage()),
            (route) => false,
          );
        }
        if(state.authStatus == ScreenStatus.loading) {
          showLoading(context);
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
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: registerCubit.state.username,
              onChanged: registerCubit.updateUsername,
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
              onChanged: registerCubit.updateEmail,
              validator: (value) {
                if (value == "" || value == null) return null;
                if (EmailValidator.validate(value)) return null;
                return "Invalid email";
              },
            ),
            const SizedBox(height: 4),
            PasswordTextField(
              onChange: registerCubit.updatePassword,
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
              onChanged: registerCubit.updateConformPassword,
              validator: (value) {
                if (value == "" || value == null || value == registerCubit.state.password) return null;
                return "Password dose not match";
              },
            ),
            const MDivider(),
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                final canRegister = state.conformPassword.isNotEmpty &&
                    state.password.isNotEmpty &&
                    state.email.isNotEmpty &&
                    state.username.isNotEmpty &&
                    state.password.length > 8 &&
                    state.conformPassword == state.password &&
                    EmailValidator.validate(state.email);
                print(canRegister);
                return MButton(
                  onClick: canRegister
                      ? () {
                          registerCubit.register();
                        }
                      : null,
                  title: "SingUp",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
