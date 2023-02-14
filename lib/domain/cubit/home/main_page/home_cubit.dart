import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/classes_data_source.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';
import 'package:school_app/domain/utils/utils.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial()) {
    userRepository = getIt();
    emit(state.copyWith(currentUser: userRepository.getCurrentUser()));
  }

  late UserRepository userRepository;
  final errorLogger = getIt<ErrorLogger>();
  final ClassesRepository classesRepository = getIt();

  void onJoinClassIdChanged(String value) => emit(state.copyWith(joinClassId: value));

  Future<void> joinClass() async {
    await checkInternetConnection();
    final joiningTask = await classesRepository.joinClass(state.joinClassId);
    emit(state.copyWith(isLoading: true));
    joiningTask.when(
      (success) => emit(state.copyWith(isJoiningClassTaskSuccess: true, isLoading: true)),
      (error) {
        emit(state.copyWith(isJoiningClassTaskSuccess: false, isLoading: false));
        errorLogger.showError(error.errorMessage);
      },
    );
  }
}
