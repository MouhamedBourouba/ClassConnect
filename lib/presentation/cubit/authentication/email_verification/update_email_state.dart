part of 'update_email_cubit.dart';

@freezed
class UpdateEmailState with _$UpdateEmailState {
  const factory UpdateEmailState.initial({
    @Default("") String email,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
  }) = _Initial;
}
