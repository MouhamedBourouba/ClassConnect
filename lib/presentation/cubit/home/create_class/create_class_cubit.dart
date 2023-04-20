import 'package:bloc/bloc.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';

part 'create_class_cubit.freezed.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  CreateClassCubit() : super(const CreateClassState.initial());

  final ClassesRepository classesRepository = getIt();
  final ErrorLogger errorLogger = getIt();

  void onClassNameChanged(String value) =>
      emit(state.copyWith(className: value));

  void onClassSubjectChanged(String value) =>
      emit(state.copyWith(classSubject: value));

  void onCustomSubjectChanged(String value) =>
      emit(state.copyWith(customSubject: value));

  void addSubject(String value) {
    if (value.isEmpty) return;
    final dropDownList = state.dropDownList;
    dropDownList.add(DropDownValueModel(name: value, value: ""));
    emit(state.copyWith(dropDownList: dropDownList));
  }

  Future<void> createClass() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final creatingClassTask = await classesRepository.createClass(
        state.className, state.classSubject);
    creatingClassTask.when(
      (success) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      (error) {
        errorLogger.showError(error.errorMessage);
        emit(state.copyWith(isSuccess: false, isLoading: false));
      },
    );
  }
}
