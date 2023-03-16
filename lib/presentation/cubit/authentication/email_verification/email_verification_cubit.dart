import 'dart:async';

import 'package:ClassConnect/data/repository/settings_repository.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multiple_result/multiple_result.dart';

part 'email_verification_cubit.freezed.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit({this.emailUpdated}) : super(const EmailVerificationState.initial()) {
    emit(state.copyWith(email: emailUpdated ?? userRepository.getCurrentUser()?.email ?? ""));
    sendEmailVerificationMessage();
  }

  final String? emailUpdated;
  final UserRepository userRepository = getIt();
  final SettingsRepository settingsRepository = getIt();
  final ErrorLogger errorLogger = getIt();
  bool isDialogOpened = false;

  Future<void> sendEmailVerificationMessage() async {
    await checkInternetConnection();
    emit(state.copyWith(loadingEmail: true));
    final sendingEmailResult = await userRepository
        .sendEmailVerificationMessage()
        .timeout(25.seconds())
        .onError((error, stackTrace) => Result.error(unit));
    sendingEmailResult.when(
      (success) {
        Fluttertoast.showToast(msg: "Message sent successfully", backgroundColor: Colors.green);
        emit(state.copyWith(isMessageSent: true, timeLeft: 120));
        _startTimer();
      },
      (error) => errorLogger.showError("Unknown Error please check your internet and try again ..."),
    );
    emit(state.copyWith(loadingEmail: false));
  }

  Future<void> verifyEmail() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final verifyingTask = await userRepository.verifyEmail(state.code);
    verifyingTask.when(
      (success) {
        settingsRepository.setIsEmailVerified(isEmailVerified: true);
        emit(state.copyWith(isEmailVerified: true));
      },
      (error) => errorLogger.showError(error),
    );
    emit(state.copyWith(isLoading: false));
  }

  void onCodeSubmitChanged(String value) => emit(state.copyWith(code: value));

  void onCodeChanged(String value) => emit(state.copyWith(code: ""));

  void onEmailTextFiledChanged(String value) => emit(state.copyWith(textFieldEmail: value));

  void onEmailUpdated(String email) => emit(state.copyWith(email: email));

  void _startTimer() => Timer.periodic(1.seconds(), (timer) {
        //prevent dialog from closing
        if (isDialogOpened) return;
        if (state.timeLeft > 0) {
          emit(state.copyWith(timeLeft: state.timeLeft - 1));
        } else {
          emit(state.copyWith(isMessageSent: false));
          timer.cancel();
        }
      });
}
