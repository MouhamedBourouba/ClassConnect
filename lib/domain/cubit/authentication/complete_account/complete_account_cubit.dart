import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';
import 'package:school_app/domain/utils/utils.dart';

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

  void onGradeChange(int value) => emit(state.copyWith(grade: value));

  Future<void> completeRegistration() async {
    final updateTask = userRepository.updateUser(
      firstName: state.firstName,
      lastName: state.lastName,
      grade: state.grade,
      parentPhone: state.parentPhone,
    );
    await checkInternetConnection();
    updateTask.then(
      (value) {
        emit(state.copyWith(isSuccess: true));
      },
      onError: errorLogger.showError,
    );
    emit(state.copyWith(isLoading: false));
  }
}
