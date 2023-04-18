part of 'update_profile_cubit.dart';

@freezed
class UpdateProfileState with _$UpdateProfileState {
  const factory UpdateProfileState.init({
    required User currentUser,
    @Default("") String fullName,
    @Default("") String email,
    @Default("") String phoneNumber,
    @Default("") String errorMessage,
    @Default(PageState.init) PageState pageState,
  }) = UpdateProfileStateInit;
}
