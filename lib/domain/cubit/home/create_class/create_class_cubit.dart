import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/repository/classes_data_source.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';

import '../../../utils/utils.dart';

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
    classesRepository.createClass(state.className, state.classSubject).then(
      (value) => emit(state.copyWith(isSuccess: true, isLoading: false)),
      onError: (error) {
        errorLogger.showError("Unknown error try again later");
        emit(state.copyWith(isLoading: false));
      },
    );
  }
}
