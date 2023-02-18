import 'package:school_app/data/model/class.dart';
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
        grade: this["grade"].toString(),
        parentPhone: this["parentPhone"].toString(),
        classes: this["classes"].toString().split(","),
        teachingClasses: this["teachingClasses"].toString().split(","),
      );

  Class toClass() => Class(
        id: this["id"].toString(),
        creatorId: this["creatorId"].toString(),
        streamMessagesId: this["streamMessagesId"].toString(),
        studentsIds: [],
        homeWorkId: this["homeWorkId"].toString(),
        bannedStudents: [],
        className: this["className"].toString(),
        subject: this["subject"].toString(),
      );
}

extension IntUtils on int {
  Duration seconds() => Duration(seconds: this);
}

extension StringUtils on String? {
  bool isEmail() {
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailValid.hasMatch(this ?? "");
  }

  String getSubjectIconPath() {
    switch(this) {
      case "math": return "assets/images/math.png";
      case "arabic": return "assets/images/arabic.png";
      case "french": return "assets/images/french.png";
      case "english": return "assets/images/english.png";
      case "science": return "assets/images/science.png";
      case "physics": return "assets/images/physics.png";
      case "history": return "assets/images/history.png";
      default: return "assets/images/other.png";
    }
  }

  String firstLatter() {
    if (this == null || this?.isEmpty == true) {
      return "A";
    } else {
      return this![0];
    }
  }
}
