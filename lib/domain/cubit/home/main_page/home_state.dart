part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = _Loading;

  const factory HomeState.loaded({
    required User currentUser,
    @Default([]) List<Class> classes,
    @Default([]) List<User> teachers,
  }) = _Loaded;

  const factory HomeState.error({
    @Default("") String errorMessage,
  }) = _Error;
}
