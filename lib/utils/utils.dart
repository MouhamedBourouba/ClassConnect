import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

Future<bool> isNotOnline() async {
  final connectionType = await Connectivity().checkConnectivity();
  if (connectionType == ConnectivityResult.none) {
    return true;
  } else {
    return false;
  }
}

Future<void> checkInternetConnection() async {
  final ErrorLogger errorLogger = getIt();
  if (await isNotOnline()) {
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
