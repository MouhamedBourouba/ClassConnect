import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multiple_result/multiple_result.dart';

part 'update_profile_cubit.freezed.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileState.init(currentUser: User.defaultUser())) {
    emit(UpdateProfileState.init(currentUser: userRepository.getCurrentUser()!));
  }

  final UserRepository userRepository = getIt();

  void onUsernameChanged(String value) => emit(state.copyWith(username: value));

  void onFirstNameChanged(String value) => emit(state.copyWith(firstName: value));

  void onLastNameChanged(String value) => emit(state.copyWith(lastName: value));

  void onGradeChanged(String value) => emit(state.copyWith(grade: value));

  void onParentPhoneChanged(String value) => emit(state.copyWith(parentPhone: value));

  void onEmailChanged(String value) => emit(state.copyWith(parentPhone: value));

  Future<void> update(UserField field) async {
    await checkInternetConnection();
    emit(state.copyWith(pageState: PageState.loading));
    late Result<Unit, MException> updatingTask;

    switch (field) {
      case UserField.firstAndLastName:
        updatingTask = await userRepository.updateUser(firstName: state.firstName, lastName: state.lastName);
        break;
      case UserField.parentPhone:
        updatingTask = await userRepository.updateUser(parentPhone: state.parentPhone);
        break;
      case UserField.email:
        updatingTask = await userRepository.updateUser(email: state.email);
        break;
      case UserField.grade:
        updatingTask = await userRepository.updateUser(grade: state.grade);
        break;
    }

    updatingTask.when(
      (success) => emit(state.copyWith(pageState: PageState.success)),
      (error) => emit(
        state.copyWith(pageState: PageState.error, errorMessage: error.errorMessage),
      ),
    );
  }

  void setToInit() => emit(state.copyWith(pageState: PageState.init));
}

enum UserField { firstAndLastName, parentPhone, email, grade }
