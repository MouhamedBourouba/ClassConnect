import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/extentions.dart';
import 'package:school_app/domain/models/text_field_value.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/register_page.dart';
import 'package:school_app/ui/widgets/loading.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authenticationRepo = GetIt.I.get<AuthRepository>();
  TextFieldValue emailTextFieldValue = TextFieldValue();
  TextFieldValue passwordTextValue = TextFieldValue();
  bool isPasswordVisible = false;

  void updateEmail(String value) {
    emailTextFieldValue.value = value;
    if (value != "") {
      value.isEmail()
          ? emailTextFieldValue.errorMessage = null
          : emailTextFieldValue.errorMessage = "Email is Badly formatted";
    } else {
      emailTextFieldValue.errorMessage = null;
    }
    notifyListeners();
  }

  void updatePassword(String value) {
    passwordTextValue.value = value;
    if (value != "") {
      value.length < 8
          ? passwordTextValue.errorMessage = "password is too short"
          : passwordTextValue.errorMessage = null;
    } else {
      passwordTextValue.errorMessage = null;
    }
    notifyListeners();
  }

  void resetProvider() {
    emailTextFieldValue = TextFieldValue();
    passwordTextValue = TextFieldValue();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void login(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (ctx) => const LoadingDialog(),
      barrierDismissible: false,
    );

    final singInTask = authenticationRepo.login(
      emailTextFieldValue.value,
      passwordTextValue.value,
    );
    singInTask.then(
      (User value) {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => HomePage(),
          ),
        );
      },
      onError: (error) {
        Navigator.pop(context);

        Fluttertoast.showToast(
          msg: error.toString() == "Bad state: No element"
              ? "User don't Exist, Try Registering"
              : error.toString(),
          backgroundColor: Colors.red,
        );
      },
    );
  }

  void navigateToRegisterScreen(BuildContext context) {
    resetProvider();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const RegisterScreen(),
      ),
    );
  }
}
