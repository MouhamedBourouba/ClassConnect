import 'package:ClassConnect/presentation/cubit/authentication/register/register_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/email_verification_page.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/pages/login_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/authentication_scaffold.dart';
import 'package:ClassConnect/presentation/ui/widgets/button.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:ClassConnect/presentation/ui/widgets/outlined_text_field.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
              MaterialPageRoute(builder: (ctx) => const EmailVerificationPage()),
              (route) => false,
            );
          }
        },
        child: AuthenticationScaffold(
          body: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
        registerCubit.state.fullName.isNotEmpty &&
        registerCubit.state.password.length > 8 &&
        registerCubit.state.conformPassword == registerCubit.state.password &&
        registerCubit.state.phoneNumber.isNotEmpty &&
        registerCubit.state.email.isEmail();

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Full name",
                border: outlinedInputBorder,
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: registerCubit.onFullNameChanged,
            ),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: registerCubit.state.email,
              decoration: const InputDecoration(
                hintText: "Email",
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
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: InternationalPhoneNumberInput(
               validator: (val) => null,
                inputDecoration: const InputDecoration(
                  hintText:"Phone number",
                  border: outlinedInputBorder,
                  prefixIcon: Icon(Icons.phone),
                ),
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                initialValue: PhoneNumber(isoCode: "DZ"),
                onInputChanged: (PhoneNumber value) {
                  registerCubit.onPhoneNumberChanged(value);
                },
              ),
            ),
            const Divider(),
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
