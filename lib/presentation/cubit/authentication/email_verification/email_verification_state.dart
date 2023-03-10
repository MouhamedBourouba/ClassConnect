part of 'email_verification_cubit.dart';

@freezed
class EmailVerificationState with _$EmailVerificationState {
  const factory EmailVerificationState.initial({
    @Default("") String code,
    @Default("") String email,
    @Default("") String error,
    @Default("") String textFieldEmail,
    @Default(0) int timeLeft,
    @Default(false) bool isLoading,
    @Default(false) bool loadingEmail,
    @Default(false) bool isError,
    @Default(false) bool isUpdatingEmail,
    @Default(false) bool isMessageSent,
    @Default(false) bool isEmailVerified,
  }) = _Initial;
}
