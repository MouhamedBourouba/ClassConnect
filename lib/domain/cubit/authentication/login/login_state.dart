// ignore_for_file: must_be_immutable
part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final ScreenStatus loginStatus;
  bool? isUserAccountCompleted;
  User? user;
  String? error;

  LoginState({required this.email, required this.password, required this.loginStatus, this.error});

  factory LoginState.init() {
    return LoginState(email: "", password: "", loginStatus: ScreenStatus.initial);
  }

  LoginState copyWith({String? email, String? password, ScreenStatus? loginStatus, String? error}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loginStatus: loginStatus ?? this.loginStatus,
      error: error ?? this.error
    );
  }

  @override
  List<Object?> get props => [email, password, loginStatus];
}
