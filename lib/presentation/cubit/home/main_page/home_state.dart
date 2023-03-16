part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeStateLoading;

  const factory HomeState.loaded({
    required User currentUser,
    @Default([]) List<Class> classes,
  }) = HomeStateLoaded;

  const factory HomeState.error({
    @Default("") String errorMessage,
  }) = HomeStateError;

  const factory HomeState.singOut() = HomeStateSingedOut;

}
