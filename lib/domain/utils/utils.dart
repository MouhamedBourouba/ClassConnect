import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';

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