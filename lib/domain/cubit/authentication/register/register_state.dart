part of 'register_cubit.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial({
    @Default("") String email,
    @Default("") String username,
    @Default("") String password,
    @Default("") String conformPassword,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
  }) = _Initial;
}
