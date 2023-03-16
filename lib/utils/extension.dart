import 'dart:convert';

import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension UserFromList on List<String> {
  User toUser() {
    return User(
      id: first,
      username: this[1],
      password: this[3],
      email: this[2],
      parentPhone: this[5],
      firstName: this[6],
      lastName: this[7],
      grade: this[4],
    );
  }
}

extension UserFromMap on Map<String, dynamic> {
  User toUser() {
    return User(
      id: this["id"].toString(),
      username: this["username"].toString(),
      password: this["hashedPassword"].toString(),
      email: this["email"].toString(),
      firstName: this["firstName"].toString(),
      lastName: this["lastName"].toString(),
      grade: this["grade"].toString(),
      parentPhone: this["parentPhone"].toString(),
      classes: this["studentsIds"].toString().toList(),
      teachingClasses: this["studentsIds"].toString().toList(),
    );
  }

  Class toClass() => Class(
        id: this["id"].toString(),
        creatorId: this["creatorId"].toString(),
        streamMessagesId: this["streamMessagesId"].toString(),
        studentsIds: this["studentsIds"].toString().toList(),
        homeWorkId: this["homeWorkId"].toString(),
        bannedStudents: this["bannedStudents"].toString().toList(),
        className: this["className"].toString(),
        subject: this["subject"].toString(),
      );
}

extension IntUtils on int {
  Duration seconds() => Duration(seconds: this);

  String toTimeAsMin() {
    if (this > 60) {
      final min = this ~/ 60;
      final seconds = this - (min * 60);
      return "${min < 10 ? "0" : ""}$min:${seconds >= 10 ? seconds.toString() : "0$seconds"}";
    } else {
      return "00:${this >= 10 ? toString() : "0$this"}";
    }
  }
}

extension StringUtils on String? {
  bool isEmail() {
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailValid.hasMatch(this ?? "");
  }

  String getSubjectIconPath() {
    switch (this) {
      case "math":
        return "assets/images/math.png";
      case "arabic":
        return "assets/images/arabic.png";
      case "french":
        return "assets/images/france.png";
      case "english":
        return "assets/images/english.png";
      case "science":
        return "assets/images/science.png";
      case "physics":
        return "assets/images/physics.png";
      case "history":
        return "assets/images/history.png";
      default:
        return "assets/images/other.png";
    }
  }

  String firstLatter() {
    if (this == null || this?.isEmpty == true) {
      return "A";
    } else {
      return this![0];
    }
  }

  List<String> toList() {
    try {
      final listDynamic = jsonDecode(toString()) as List;
      return listDynamic.map((e) => e as String).toList();
    } catch (e) {
      return [];
    }
  }
}

extension WidgetUtlis on StatelessWidget {
  MaterialPageRoute asRoute() => MaterialPageRoute(builder: (context) => this);
}
