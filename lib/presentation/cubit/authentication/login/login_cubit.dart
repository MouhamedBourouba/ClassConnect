import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/settings_repository.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_cubit.freezed.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.initial());

  final UserRepository userRepository = getIt();
  final SettingsRepository settingsRepository = getIt();
  final errorLogger = getIt<ErrorLogger>();

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> login() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final loginResult = await userRepository.loginUser(state.email, state.password);
    loginResult.when(
      (user) => emit(
        state.copyWith(
          isSuccess: true,
          user: user,
          isLoading: false,
          isEmailVerified: settingsRepository.isEmailVerified(),
        ),
      ),
      (error) {
        emit(state.copyWith(isLoading: false));
        errorLogger.showError(error.errorMessage);
      },
    );
  }
}
