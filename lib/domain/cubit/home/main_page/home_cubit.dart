import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/model/class.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/classes_data_source.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/domain/utils/error_logger.dart';
import 'package:school_app/domain/utils/extension.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.loading()) {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(10.seconds());
    final currentUser = userRepository.getCurrentUser()!;
    (await classesRepository.getCurrentUserTeachers()).when(
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
