import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';

part 'register_cubit.freezed.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState.initial());

  final ErrorLogger errorLogger = getIt<ErrorLogger>();
  final UserRepository userRepository = getIt();

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void onConformPasswordChanged(String value) => emit(state.copyWith(conformPassword: value));

  void onFullNameChanged(String value) => emit(state.copyWith(fullName: value));

  void onPhoneNumberChanged(PhoneNumber value) => emit(state.copyWith(phoneNumber: value.phoneNumber ?? ""));

  Future<void> register() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final registeringTask = await userRepository.registerUser(state.fullName, state.email, state.password, state.phoneNumber);
    registeringTask.when(
      (success) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      (error) {
        errorLogger.showError(error.errorMessage);
        emit(state.copyWith(isLoading: false));
      },
    );
  }
}
