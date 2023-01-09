// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/repository/complete_account_repository.dart';
import 'package:school_app/domain/bloc/authentication/screen_status.dart';

part 'complete_account_state.dart';

class CompleteAccountCubit extends Cubit<CompleteAccountState> {
  CompleteAccountCubit() : super(CompleteAccountState());
  CompleteAccountRepository? completeAccountRepository;

  void firstNameChanged(String value) => emit(state.copyWith(firstName: value));

  void lastNameChanged(String value) => emit(state.copyWith(lastName: value));

  void parentPhoneChanged(String value, String dial) => emit(state.copyWith(parentPhone: value)..dialCode = dial);

  void gradeChanged(int? value) => emit(state.copyWith()..grade = value);

  Future<void> register() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: "¨Please check you connection", backgroundColor: Colors.red);
      return;
    }
    emit(state.copyWith(screenStatus: ScreenStatus.loading));
    try {
      completeAccountRepository ??= await GetIt.I.getAsync<CompleteAccountRepository>();

      completeAccountRepository!.completeAccount(state.grade!, state.firstName, state.lastName, state.parentPhone).then(
        (value) => emit(state.copyWith(screenStatus: ScreenStatus.success)),
        onError: (error) {
          emit(
            state.copyWith(
              screenStatus: ScreenStatus.error,
              error: error is UnknownException ? "Unknown error please try again later" : error.toString(),
            ),
          );
        },
      );
    } on Exception {
      emit(state.copyWith(screenStatus: ScreenStatus.error, error: "Unknown error try again later"));
    }
  }
}
