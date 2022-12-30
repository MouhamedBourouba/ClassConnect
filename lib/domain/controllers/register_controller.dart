import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/login_page.dart';
import 'package:school_app/ui/widgets/loading.dart';

class RegisterProvider extends ChangeNotifier {
  var usernameTextFieldValue = TextFieldValue();
  var emailTextFieldValue = TextFieldValue();
  var passwordTextFieldValue = TextFieldValue();
  var conformPasswordTextFieldValue = TextFieldValue();
  var isPasswordVisible = false;
  var isLoading = false;
  var canRegister = false;
  final AuthRepository authRepository = GetIt.I.get();

  togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  updateUsername(String value) {
    usernameTextFieldValue.value = value;
    notifyListeners();
  }

  updateEmail(String value) {
    emailTextFieldValue.value = value;
    if (!validateEmail(value)) {
      emailTextFieldValue.errorMessage = "Email Address is Badly Formatted";
    } else {
      emailTextFieldValue.errorMessage = null;
    }
    notifyListeners();
  }

  updatePassword(String value) {
    passwordTextFieldValue.value = value;
    if (value.length < 8) {
      passwordTextFieldValue.errorMessage = "Password is too short";
    } else {
      passwordTextFieldValue.errorMessage = null;
    }
    if (conformPasswordTextFieldValue.value != "") {
      if (value != conformPasswordTextFieldValue.value) {
        conformPasswordTextFieldValue.errorMessage = "Password doesn't match";
      } else {
        conformPasswordTextFieldValue.errorMessage = null;
      }
    }
    notifyListeners();
  }

  updateConformPassword(String value) async {
    conformPasswordTextFieldValue.value = value;
    if (value != passwordTextFieldValue.value) {
      conformPasswordTextFieldValue.errorMessage = "Password doesn't match";
    } else {
      conformPasswordTextFieldValue.errorMessage = null;
    }
    notifyListeners();
  }

  validateEmail(email) {
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailValid.hasMatch(email);
  }

  navigateToLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (builder) => const LoginPage()),
      (route) => false,
    );
  }

  register(context) async {
    final isOnline = await Connectivity().checkConnectivity();
    if (isOnline == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "Please Check your internet connection",
        backgroundColor: Colors.red,
      );
      return;
    }

    showDialog(context: context, builder: (context) => const LoadingDialog());

    final registrationTask = authRepository.createAccount(
      passwordTextFieldValue.value,
      emailTextFieldValue.value,
      usernameTextFieldValue.value,
    );

    registrationTask.then(
      (value) {
        Navigator.pop(context);
        log("Account Created");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (ctx) => HomePage()), (route) => false);
      },
      onError: (error) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: error.toString());
      },
    );
  }
}

class TextFieldValue {
  String value = "";
  String? errorMessage;
}
