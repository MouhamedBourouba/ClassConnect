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
      grade: this[4],
    );
  }
}

extension UserFromMap on Map<String, dynamic> {
  User toUser() => User(
        id: this["id"].toString(),
        username: this["username"].toString(),
        password: this["hashedPassword"].toString(),
        email: this["email"].toString(),
        firstName: this["firstName"].toString(),
        lastName: this["lastName"].toString(),
        grade:this["grade"].toString(),
        parentPhone: this["parentPhone"].toString(),
        classes: this["classes"].toString().split(","),
        teachingClasses: this["teachingClasses"].toString().split(","),
      );
}

extension StringUtils on String? {
  bool isEmail() {
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailValid.hasMatch(this ?? "");
  }

  String firstLatter() {
    if (this == null || this?.isEmpty == true) {
      return "A";
    } else {
      return this![0];
    }
  }
}
