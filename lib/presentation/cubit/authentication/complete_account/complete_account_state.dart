part of 'complete_account_cubit.dart';

@freezed
class CompleteAccountState with _$CompleteAccountState {
  const factory CompleteAccountState.initial({
    @Default("First Grade") String grade,
    @Default("") String firstName,
    @Default("") String lastName,
    @Default("") String parentPhone,
    @Default(false) bool isSuccess,
    @Default(false) bool isLoading,
  }) = _Initial;
}
