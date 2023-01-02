
import 'package:school_app/data/model/user.dart';

extension UserFromList on List<String> {
  User toUser() {
    return User(
      id: first,
      username: this[1],
      hashedPassword: this[3],
      email: this[2],
      parentPhone: this[5],
      firstName: this[6],
      lastName: this[7],
      grade: this[4],
    );
  }
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
