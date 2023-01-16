import 'package:school_app/data/model/user.dart';

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
      grade: int.tryParse(this[4]),
    );
  }
}

extension SubjectExtentionFromInt on int {
  Subject fromInt() {
    switch (this) {
      case 0:
        return Subject.match;
      case 1:
        return Subject.arabic;
      case 2:
        return Subject.english;
      case 3:
        return Subject.french;
      case 4:
        return Subject.history;
      case 5:
        return Subject.physics;
      case 6:
        return Subject.science;
      case 7:
        return Subject.other;
    }
    return Subject.other;
  }
}

extension SubjectExtentionFromSubject on Subject {
  int toInt() {
    switch (this) {
      case Subject.match:
        return 0;
      case Subject.arabic:
        return 1;
      case Subject.english:
        return 2;
      case Subject.french:
        return 3;
      case Subject.history:
        return 4;
      case Subject.physics:
        return 5;
      case Subject.science:
        return 6;
      case Subject.other:
        return 7;
    }
  }
}

enum Subject {
  match,
  arabic,
  english,
  french,
  history,
  physics,
  science,
  other,
}

extension UserFromMap on Map<String, dynamic> {
  User toUser() => User(
        id: this["id"].toString(),
        username: this["username"].toString(),
        password: this["hashedPassword"].toString(),
        email: this["email"].toString(),
        firstName: this["firstName"].toString(),
        lastName: this["lastName"].toString(),
        grade: int.tryParse(this["grade"].toString()),
        parentPhone: this["parentPhone"].toString(),
        classes: this["classes"].toString().split(","),
        teachingClasses: this["teachingClasses"].toString().split(","),
      );
}

extension StringUtils on String {
  bool isEmail() {
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailValid.hasMatch(this);
  }

  String firstLatter() {
    return this[0];
  }
}
