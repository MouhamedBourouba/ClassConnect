part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial({
    User? currentUser,
    @Default("") String joinClassId,
    @Default(false) bool isLoading,
    @Default(false) bool isJoiningClassTaskSuccess,
  }) = _Initial;
}
