import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';
import 'package:school_app/domain/utils/utils.dart';

part 'login_cubit.freezed.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.initial()) {
    userRepository = getIt();
  }

  late UserRepository userRepository;
  final errorLogger = getIt<ErrorLogger>();

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> login() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final loginResult = await userRepository.loginUser(state.email, state.password);
    loginResult.when(
      (user) => emit(state.copyWith(isSuccess: true, user: user, isLoading: false)),
      (error) {
        emit(state.copyWith(isLoading: false));
        errorLogger.showError(error.errorMessage);
      },
    );
  }
}
