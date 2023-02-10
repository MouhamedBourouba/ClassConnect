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
    _init();
  }

  late UserRepository userRepository;
  final errorLogger = getIt<ErrorLogger>();

  void _init() {
    userRepository = getIt();
  }

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> login() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    userRepository.loginUser(state.email, state.password).then(
      (value) => emit(state.copyWith(isSuccess: true, isLoading: false, user: value)),
      onError: (error) {
        errorLogger.showError(error.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }
}
