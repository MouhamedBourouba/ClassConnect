part of 'update_profile_cubit.dart';

@freezed
class UpdateProfileState with _$UpdateProfileState {
  const factory UpdateProfileState.init({
    required User currentUser,
    @Default("") String firstName,
    @Default("") String lastName,
    @Default("") String email,
    @Default("") String parentPhone,
    @Default("") String username,
    @Default("") String grade,
    @Default("") String errorMessage,
    @Default(PageState.init) PageState pageState,
  }) = UpdateProfileStateInit;
}
