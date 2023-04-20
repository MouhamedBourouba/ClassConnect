part of 'class_cubit.dart';

@freezed
class ClassState with _$ClassState {
  const factory ClassState.initial({
    @Default("") String classId,
    @Default("") String teacherEmail,
    @Default("") String errorMessage,
    @Default(0) int pageIndex,
    @Default([]) List<User> classMembers,
    @Default([]) List<User> teachers,
    @Default(PageState.init) PageState pageState,
    Class? currentClass,
  }) = _Initial;
}
