part of 'class_cubit.dart';

@freezed
class ClassState with _$ClassState {
  const factory ClassState.initial({
    @Default("") String classId,
    @Default(PageState.init) PageState pageState,
  }) = _Initial;
}
