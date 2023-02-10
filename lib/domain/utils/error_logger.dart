import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ErrorLogger {
  void showError(String error) {
    Fluttertoast.showToast(msg: error, backgroundColor: Colors.red);
  }

  void showNoInternetError() {
    Fluttertoast.showToast(msg: "Please Check your Internet Connection and try again", backgroundColor: Colors.red);
  }
}
