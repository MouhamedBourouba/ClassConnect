import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:school_app/domain/controllers/register_controller.dart';
import '../widgets/authentication_scaffold.dart';
import '../widgets/outlined_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    logo() {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Hero(
          // logo is heading when keyboard is open
          tag: isKeyboardOpen ? "1" : "logo",
          child: SvgPicture.asset(
            "assets/images/logo_no_text.svg",
            width: isKeyboardOpen ? 0 : 180,
          ),
        ),
      );
    }

    registerText() {
      return Text(
        "Register",
        textAlign: TextAlign.center,
        style: theme.textTheme.headline4!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    usernameTextField() {
      return OutlinedTextFiled(
        hint: "User name",
        prefixIcon: Icons.person,
        isTextShown: true,
        suffixIcon: null,
        onValueChanged: (value) =>
            Provider.of<RegisterProvider>(context, listen: false)
                .updateUsername(value),
        inputType: TextInputType.name,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      );
    }

    emailTextField() {
      return Consumer<RegisterProvider>(
        builder: (_, controller, __) => OutlinedTextFiled(
          hint: "email",
          prefixIcon: Icons.email,
          isTextShown: true,
          suffixIcon: null,
          errorText: controller.emailTextFieldValue.errorMessage,
          onValueChanged: (value) => controller.updateEmail(value),
          inputType: TextInputType.emailAddress,
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
        ),
      );
    }

    passwordTextField() {
      return Consumer<RegisterProvider>(
        builder: (_, controller, __) => OutlinedTextFiled(
          hint: "password",
          prefixIcon: Icons.password,
          isTextShown: controller.isPasswordVisible,
          onValueChanged: (value) => controller.updatePassword(value),
          inputType: TextInputType.visiblePassword,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          errorText: controller.passwordTextFieldValue.errorMessage,
          suffixIcon: IconButton(
            onPressed: () => controller.togglePasswordVisibility(),
            icon: Icon(
              controller.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
      );
    }

    conformPasswordTextField() {
      return Consumer<RegisterProvider>(
        builder: (_, provider, __) => OutlinedTextFiled(
          hint: "Conform Password",
          prefixIcon: Icons.password,
          isTextShown: provider.isPasswordVisible,
          suffixIcon: null,
          errorText: provider.conformPasswordTextFieldValue.errorMessage,
          onValueChanged: (value) => provider.updateConformPassword(value),
          inputType: TextInputType.visiblePassword,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
        ),
      );
    }

    registerButton() {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Consumer<RegisterProvider>(
          builder: (_, controller, __) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 16,
              backgroundColor: theme.colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            onPressed: (controller.usernameTextFieldValue.value != "" &&
                    controller.emailTextFieldValue.value != "" &&
                    controller.passwordTextFieldValue.value != "" &&
                    controller.conformPasswordTextFieldValue.value != "" &&
                    controller.emailTextFieldValue.errorMessage == null &&
                    controller.passwordTextFieldValue.errorMessage == null &&
                    controller.conformPasswordTextFieldValue.errorMessage == null)
                ? () {
                    controller.register(context);
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                "Sing up",
                style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    loginNavigationText() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Text("No Account? ,"),
            GestureDetector(
              onTap: () => Provider.of<RegisterProvider>(context, listen: false)
                  .navigateToLoginScreen(context),
              child: Text(
                "Click HERE ",
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.colorScheme.primary),
              ),
            ),
            const Text("to Register")
          ],
        ),
      );
    }

    return AuthenticationScaffold(
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              logo(),
              registerText(),
              usernameTextField(),
              emailTextField(),
              passwordTextField(),
              conformPasswordTextField(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Divider(
                  thickness: 1,
                ),
              ),
              registerButton(),
              loginNavigationText(),
            ],
          ),
        ),
      ),
    );
  }
}
