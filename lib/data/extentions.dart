import 'model/user.dart';

extension UserFromList on List<String> {
  User toUser() {
    return User(
      id: first,
      username: this[1],
      hashedPassword: this[2],
      email: this[3],
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

  bool isValidName() {
    final nameRegExp = RegExp(
        r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$");
    return true;
  }
}
