import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:school_app/data/extentions.dart';

import '../../data/model/text_field_value.dart';

class CompleteAccountProvider extends ChangeNotifier {
  String firstNameTextFieldValue = '';
  String lastNameTextFieldValue = '';
  final parentPhoneTextFieldValue = TextFieldValue();
  int? gradeTextFieldValue = 1;

  String? validateName(String value) {
    return value.isValidName() ? null : "Please Enter valid name";
  }

  updateFirstName(String value) {
    firstNameTextFieldValue = value;
    log((firstNameTextFieldValue != "" && lastNameTextFieldValue != "")
        .toString());
    notifyListeners();
  }

  updateLastName(String value) {
    lastNameTextFieldValue = value;
    log((firstNameTextFieldValue != "" && lastNameTextFieldValue != "")
        .toString());
    notifyListeners();
  }

  updatePhoneNumber(PhoneNumber value) {
    parentPhoneTextFieldValue.value = value.phoneNumber.toString();
    if (value.phoneNumber != "" || value.phoneNumber != null) {
      if (value.phoneNumber!.length - value.dialCode!.length != 10) {
        parentPhoneTextFieldValue.errorMessage = "Invalid Phone Number";
      } else {
        parentPhoneTextFieldValue.errorMessage = null;
      }
    }
    notifyListeners();
  }

  updateGrade(value) {
    if (value != "") {
      gradeTextFieldValue = value.value;
    } else {
      gradeTextFieldValue = null;
    }
    notifyListeners();
  }

  saveUserAccount({
    required Function() onCompleted,
    required Function(String) onError,
    required Function onStart,
    required Function onSuccess,
  }) {
    // update account
    onStart();
    Future.delayed(
      const Duration(seconds: 5),
      () {
        onCompleted();
        onError("ERROR IS HERE");
      },
    );
  }
}
