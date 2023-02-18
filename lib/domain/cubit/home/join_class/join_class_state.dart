part of 'join_class_cubit.dart';

@freezed
class JoinClassState with _$JoinClassState {
  const factory JoinClassState.initial({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default("") String classId,
  }) = _Initial;
}
