import 'package:ClassConnect/data/model/source.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/error_logger.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final currentUser = userRepository.getCurrentUser()!;
    (await classesRepository.getCurrentUserTeachers(DataSource.remote)).when(
      (teachers) => emit(
        HomeState.loaded(
          currentUser: currentUser,
          classes: classesRepository.getClasses(),
          teachers: teachers,
        ),
      ),
      (error) => emit(HomeState.error(errorMessage: error.errorMessage)),
    );
  }

  late UserRepository userRepository = getIt();
  final errorLogger = getIt<ErrorLogger>();
  final ClassesRepository classesRepository = getIt();
}
