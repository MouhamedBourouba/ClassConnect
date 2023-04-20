import 'dart:io';

import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:flutter/cupertino.dart';

Future<bool> isOnline() async {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<void> checkInternetConnection() async {
  final ErrorLogger errorLogger = getIt();
  if (!(await isOnline())) {
    errorLogger.showError("Please check your internet Connection");
    throw Exception();
  } else {
    return;
  }
}

void popDialog(BuildContext context) {
  if (ModalRoute.of(context)?.isCurrent != true) {
    Navigator.pop(context);
  }
}
