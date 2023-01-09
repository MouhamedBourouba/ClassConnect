import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_app/domain/bloc/authentication/screen_status.dart';
import 'package:school_app/domain/bloc/authentication/login/login_cubit.dart';
import 'package:school_app/ui/pages/complete_account_page.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/register_page.dart';
import 'package:school_app/ui/widgets/authentication_scaffold.dart';
import 'package:school_app/ui/widgets/button.dart';
import 'package:school_app/ui/widgets/loading.dart';
import 'package:school_app/ui/widgets/outlined_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == ScreenStatus.error) {
          hideLoading(context);
          if (state.error != null)
            Fluttertoast.showToast(
              msg: state.error.toString(),
              backgroundColor: Colors.red,
            );
        }
        if (state.loginStatus == ScreenStatus.loading) {
          showLoading(context);
        } else if (state.loginStatus == ScreenStatus.success) {
          hideLoading(context);
          context.read<LoginCubit>().close();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (ctx) => state.isUserAccountCompleted == true
                  ? const HomePage()
                  : const CompleteAccountPage(),
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
                  style: theme.textTheme.headline4
                      ?.copyWith(color: theme.colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
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
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
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
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                hintText: "email",
                border: outlinedInputBorder,
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: context.read<LoginCubit>().updateEmail,
              validator: (value) {
                if (value == "" || value == null) return null;
                if (EmailValidator.validate(value)) return null;
                return "Invalid email";
              },
            ),
            const SizedBox(height: 6),
            PasswordTextField(
              onChange: context.read<LoginCubit>().updatePassword,
              initValue: context.read<LoginCubit>().state.password,
            ),
            const MDivider(),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final canRegister = state.password.isNotEmpty &&
                    state.email.isNotEmpty &&
                    EmailValidator.validate(state.email) &&
                    state.password.length > 8;
                return MButton(
                  onClick: canRegister
                      ? () {
                          context.read<LoginCubit>().login();
                        }
                      : null,
                  title: "SingIn",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
