import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/repository/classes_data_source.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';
import 'package:school_app/domain/utils/utils.dart';

part 'create_class_cubit.freezed.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  CreateClassCubit() : super(const CreateClassState.initial());

  final ClassesRepository classesRepository = getIt();
  final ErrorLogger errorLogger = getIt();

  void onClassNameChanged(String value) => emit(state.copyWith(className: value));

  void onClassSubjectChanged(String value) => emit(state.copyWith(classSubject: value));

  Future<void> createClass() async {
    await isNotOnline();
    emit(state.copyWith(isLoading: true));
    final creatingClassTask = await classesRepository.createClass(state.className, state.classSubject);
    creatingClassTask.when(
      (success) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      (error) {
        errorLogger.showError(error.errorMessage);
        emit(state.copyWith(isSuccess: false, isLoading: false));
      },
    );
  }
}
