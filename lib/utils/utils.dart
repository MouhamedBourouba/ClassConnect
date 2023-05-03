import 'dart:io';

import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:flutter/material.dart';

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

List<T> removeDuplicates<T>(List<T> list, {bool? isClass, bool? isUser}) {
  final List<T> finalList = [];
  for (final element in list) {
    if (isUser == true) {
      if (!finalList.any((user) => (user as User).id == (element as User).id)) finalList.add(element);
    } else if (isClass == true) {
      if (!finalList.any((class_) => (class_ as Class).id == (element as Class).id)) {
        finalList.add(element);
      }
    } else {
      if (!finalList.contains(element)) finalList.add(element);
    }
  }
  return finalList;
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

class RandomColorGenerator {
  final _colorList = Colors.primaries.map((e) => e).toList();

  RandomColorGenerator() {
    _colorList.shuffle();
  }

  Color getColorHash(int index) {
    try {
      return _colorList[index];
    } catch (e) {
      return getColorHash(index - _colorList.length);
    }
  }
}
