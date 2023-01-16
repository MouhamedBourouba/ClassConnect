// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/domain/cubit/authentication/screen_status.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  late AuthRepository authRepository;

  void updateEmail(String value) => emit(state.copyWith(email: value));

  void updateUsername(String value) => emit(state.copyWith(username: value));

  void updatePassword(String value) => emit(state.copyWith(password: value));

  void updateConformPassword(String value) => emit(state.copyWith(conformPassword: value));

  Future<void> register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      emit(
        state.copyWith(
          error: "Please check your internet connection",
          authStatus: ScreenStatus.error,
        ),
      );
      return;
    }
    try {
      emit(state.copyWith(authStatus: ScreenStatus.loading));
      authRepository = await GetIt.I.getAsync<AuthRepository>();
      authRepository.createAccount(state.password, state.email, state.username).then(
        (value) {
          emit(state.copyWith(authStatus: ScreenStatus.success));
        },
        onError: (error) {
          emit(
            state.copyWith(
              error: error is UnknownException ? "Unknown error please try again later" : error.toString(),
              authStatus: ScreenStatus.error,
            ),
          );
        },
      );
    } on Exception {
      state.copyWith(error: "Unknown error please try again later");
    }
  }
}
