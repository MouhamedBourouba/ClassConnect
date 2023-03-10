import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';

part 'complete_account_cubit.freezed.dart';

part 'complete_account_state.dart';

class CompleteAccountCubit extends Cubit<CompleteAccountState> {
  CompleteAccountCubit() : super(const CompleteAccountState.initial()) {
    userRepository = getIt();
    errorLogger = getIt();
  }

  late UserRepository userRepository;
  late ErrorLogger errorLogger;

  void onParentPhoneChange(String value) => emit(state.copyWith(parentPhone: value));

  void onFirstNameChange(String value) => emit(state.copyWith(firstName: value));

  void onLastNameChange(String value) => emit(state.copyWith(lastName: value));

  void onGradeChange(String value) => emit(state.copyWith(grade: value));

  Future<void> completeRegistration() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final updateTask = await userRepository.updateUser(
      firstName: state.firstName,
      lastName: state.lastName,
      grade: state.grade,
      parentPhone: state.parentPhone,
    );
    updateTask.when(
      (success) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      (error) {
        emit(state.copyWith(isLoading: false));
        errorLogger.showError(error.errorMessage);
      },
    );
  }
}
