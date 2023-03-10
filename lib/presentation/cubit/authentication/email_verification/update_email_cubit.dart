import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_email_state.dart';

part 'update_email_cubit.freezed.dart';

class UpdateEmailCubit extends Cubit<UpdateEmailState> {
  UpdateEmailCubit() : super(const UpdateEmailState.initial());
  final UserRepository userRepository = getIt();
  final ErrorLogger errorLogger = getIt();

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  Future<void> update() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final updatingTask = await userRepository.updateUser(email: state.email);
    updatingTask.when(
      (success) => emit(state.copyWith(isSuccess: true, isLoading: false)),
      (error) {
        emit(state.copyWith(isLoading: false));
        errorLogger.showError(error.errorMessage);
      },
    );
  }
}
