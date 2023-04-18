part of 'create_class_cubit.dart';

@freezed
class CreateClassState with _$CreateClassState {
  const factory CreateClassState.initial({
    @Default("")
        String className,
    @Default("")
        String customSubject,
    @Default("match")
        String classSubject,
    @Default(false)
        bool isLoading,
    @Default(false)
        bool isSuccess,
    @Default([
      DropDownValueModel(name: "math", value: 0),
      DropDownValueModel(name: "arabic", value: 1),
      DropDownValueModel(name: "english", value: 2),
      DropDownValueModel(name: "french", value: 3),
      DropDownValueModel(name: "history", value: 4),
      DropDownValueModel(name: "physics", value: 5),
      DropDownValueModel(name: "science", value: 6),
      DropDownValueModel(name: "other", value: 7),
    ])
        List<DropDownValueModel> dropDownList,
  }) = _Initial;
}
