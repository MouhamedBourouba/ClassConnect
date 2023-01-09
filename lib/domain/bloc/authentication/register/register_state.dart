part of 'register_cubit.dart';

class RegisterState {
  String password = "";
  String email = "";
  String username = "";
  String conformPassword = "";
  ScreenStatus authStatus = ScreenStatus.initial;
  String error = "";

  RegisterState copyWith(
      {String? password, String? email, String? username, String? conformPassword, ScreenStatus? authStatus, String? error}) {
    return RegisterState()
      ..password = password ?? this.password
      ..email = email ?? this.email
      ..username = username ?? this.username
      ..conformPassword = conformPassword ?? this.conformPassword
      ..authStatus = authStatus ?? this.authStatus
    ..error = error ??  this.error;
  }
}
