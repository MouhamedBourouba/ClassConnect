import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_class_cubit.freezed.dart';
part 'join_class_state.dart';

class JoinClassCubit extends Cubit<JoinClassState> {
  JoinClassCubit() : super(const JoinClassState.initial());

  final ClassesRepository classesRepository = getIt();
  final errorLogger = getIt<ErrorLogger>();

  void onClassIdChange(String value) => emit(state.copyWith(classId: value));

  Future<void> joinClass() async {
    await checkInternetConnection();
    emit(state.copyWith(isLoading: true));
    final joiningResult = await classesRepository.joinClass(state.classId);
    joiningResult.when(
      (success) => emit(state.copyWith(isSuccess: true)),
      (error) => errorLogger.showError(error.errorMessage),
    );
    emit(state.copyWith(isLoading: false));
  }
}
