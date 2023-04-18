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

  void onFullNameChanged(String value) => emit(state.copyWith(fullName: value));

  void onPhoneNumberChanged(String value) => emit(state.copyWith(phoneNumber: value));

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  Future<void> update(UserField field) async {
    await checkInternetConnection();
    emit(state.copyWith(pageState: PageState.loading));
    late Result<Unit, MException> updatingTask;

    switch (field) {
      case UserField.fullName:
        updatingTask = await userRepository.updateUser(fullName: state.fullName);
        break;
      case UserField.email:
        updatingTask = await userRepository.updateUser(email: state.email);
        break;
      case UserField.phoneNumber:
        updatingTask = await userRepository.updateUser(phoneNumber: state.phoneNumber);
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

enum UserField { fullName, phoneNumber, email }
