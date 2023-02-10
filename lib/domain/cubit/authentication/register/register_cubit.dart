import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';
import 'package:school_app/domain/utils/utils.dart';

part 'register_cubit.freezed.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState.initial());

  final ErrorLogger errorLogger = getIt<ErrorLogger>();
  final UserRepository userRepository = getIt();

  void onUsernameChanged(String value) => emit(state.copyWith(username: value));

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void onConformPasswordChanged(String value) => emit(state.copyWith(conformPassword: value));

  Future<void> register() async {
    if (await isNotOnline()) {
      errorLogger.showNoInternetError();
      return;
    }
    emit(state.copyWith(isLoading: true));
    await userRepository.registerUser(state.username, state.email, state.password).then(
          (value) => emit(state.copyWith(isSuccess: true, isLoading: false)),
          onError: errorLogger.showError,
        );
    emit(state.copyWith(isLoading: false));
  }
}
