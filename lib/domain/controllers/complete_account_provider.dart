import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:school_app/domain/models/text_field_value.dart';


class CompleteAccountProvider extends ChangeNotifier {
  String firstNameTextFieldValue = '';
  String lastNameTextFieldValue = '';
  final parentPhoneTextFieldValue = TextFieldValue();
  int? gradeTextFieldValue = 1;

  void updateFirstName(String value) {
    firstNameTextFieldValue = value;
    log((firstNameTextFieldValue != "" && lastNameTextFieldValue != "")
        .toString(),);
    notifyListeners();
  }

  void updateLastName(String value) {
    lastNameTextFieldValue = value;
    log((firstNameTextFieldValue != "" && lastNameTextFieldValue != "")
        .toString(),);
    notifyListeners();
  }

  void updatePhoneNumber(PhoneNumber value) {
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

  void updateGrade(value) {
    if (value != "") {
      gradeTextFieldValue = value.value as int;
    } else {
      gradeTextFieldValue = null;
    }
    notifyListeners();
  }

  void saveUserAccount({
    required Function() onCompleted,
    required Function(String) onError,
    required Function onStart,
    required Function onSuccess,
  }) {
    // update account
    FocusManager.instance.primaryFocus?.unfocus();
    
    onStart.call();

    Future.delayed(
      const Duration(seconds: 5),
      () {
        onCompleted();
        onError("ERROR IS HERE");
      },
    );
  }
}
