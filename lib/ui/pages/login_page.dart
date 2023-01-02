import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:school_app/domain/controllers/login_controller.dart';
import 'package:school_app/ui/widgets/authentication_scaffold.dart';
import 'package:school_app/ui/widgets/outlined_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    Widget logo() {
      return Hero(
        // logo is heading when keyboard is open
        tag: isKeyboardOpen ? "" : "logo",
        child: SvgPicture.asset(
          "assets/images/logo_no_text.svg",
          width: isKeyboardOpen ? 0 : 200,
        ),
      );
    }

    Widget loginText() {
      return Text(
        "Login",
        textAlign: TextAlign.center,
        style: theme.textTheme.headline4!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    Widget emailTextField() {
      return Consumer<LoginProvider>(
        builder: (_, controller, __) => OutlinedTextFiled(
          hint: "email",
          prefixIcon: Icons.email,
          isTextShown: true,
          onValueChanged: controller.updateEmail,
          inputType: TextInputType.emailAddress,
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 8),
          errorText: controller.emailTextFieldValue.errorMessage,
        ),
      );
    }

    Widget passwordTextField() {
      return Consumer<LoginProvider>(
        builder: (_, controller, __) => OutlinedTextFiled(
          hint: "password",
          prefixIcon: Icons.password,
          isTextShown: controller.isPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () => controller.togglePasswordVisibility(),
            icon: Icon(
              controller.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
          onValueChanged: controller.updatePassword,
          inputType: TextInputType.visiblePassword,
          padding: const EdgeInsets.only(left: 16, right: 16),
          errorText: controller.passwordTextValue.errorMessage,
        ),
      );
    }

    Widget loginButton() {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Consumer<LoginProvider>(
          builder: (_, controller, __) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              backgroundColor: theme.colorScheme.secondary,
            ),
            onPressed: (controller.emailTextFieldValue.value.isNotEmpty &&
                    controller.passwordTextValue.value.isNotEmpty &&
                    controller.emailTextFieldValue.errorMessage == null &&
                    controller.passwordTextValue.errorMessage == null)
                ? () {
                    controller.login(context);
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                "Sing in",
                style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    Widget registerNavigationText() {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text("No Account? , "),
          GestureDetector(
            onTap: () => Provider.of<LoginProvider>(context, listen: false)
                .navigateToRegisterScreen(context),
            child: Text(
              "Click HERE ",
              style: theme.textTheme.bodyLarge!
                  .copyWith(color: theme.colorScheme.primary),
            ),
          ),
          const Text("to Register")
        ],
      );
    }

    return AuthenticationScaffold(
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              logo(),
              loginText(),
              emailTextField(),
              passwordTextField(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Divider(
                  thickness: 1,
                ),
              ),
              loginButton(),
              registerNavigationText(),
            ],
          ),
        ),
      ),
    );
  }
}
