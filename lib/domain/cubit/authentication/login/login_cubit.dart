// ignore_for_file: use_setters_to_change_properties, depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/domain/cubit/authentication/screen_status.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.init());
  late AuthRepository authRepository;

  void updateEmail(String value) => emit(state.copyWith(email: value));

  void updatePassword(String value) => emit(state.copyWith(password: value));

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      emit(
        state.copyWith(
          error: "Please check your internet connection",
          loginStatus: ScreenStatus.error,
        ),
      );
      return;
    }
    try {
      authRepository = await GetIt.I.getAsync<AuthRepository>();
      emit(state.copyWith(loginStatus: ScreenStatus.loading));
      authRepository.login(state.email, state.password).then(
        (value) {
          emit(state.copyWith(loginStatus: ScreenStatus.success));
        },
        onError: (error) {
          emit(
            state.copyWith(loginStatus: ScreenStatus.error)
              ..error = error is UnknownException ? "Unknown error please try again later" : error.toString(),
          );
        },
      );
    } on Exception {
      emit(
        state.copyWith(loginStatus: ScreenStatus.error)..error = "Unknown error please try again later",
      );
    }
  }
}
