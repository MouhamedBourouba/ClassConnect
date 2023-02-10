part of 'create_class_cubit.dart';

@freezed
class CreateClassState with _$CreateClassState {
  const factory CreateClassState.initial({
    @Default("") String className,
    @Default("") String classSubject,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
  }) = _Initial;
}
