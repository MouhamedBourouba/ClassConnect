import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/events_repository.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.loading()) {
    _init();
  }

  final UserRepository _userRepository = getIt();
  final EventsRepository _eventsRepository = getIt();
  final ClassesRepository _classesRepository = getIt();
  final LocalDataSource _localDataSource = getIt();
  List<User> _users = [];

  Future<void> _init() async {
    try {
      final currentUser = _userRepository.getCurrentUser()!;
      final usersResult = await _userRepository.getAllUsers(DataSource.local);
      final List<Class> classes = (await isOnline())
          ? await _classesRepository.getClasses(DataSource.remote)
          : removeDuplicates<Class>(
              await _classesRepository.getClasses(DataSource.local),
              isClass: true,
            );
      usersResult.when(
        (data) {
          _users = data;
          emit(
            HomeState.loaded(
              currentUser: currentUser,
              classes: classes,
            ),
          );
          _eventsRepository.getEvents().then(
                (events) => emit(
                  HomeState.loaded(
                    currentUser: currentUser,
                    classes: classes,
                    notificationCounter: events.length,
                  ),
                ),
              );
        },
        (error) => emit(
          HomeState.error(
            errorMessage: error.errorMessage,
          ),
        ),
      );
    } catch (e) {
      emit(
        const HomeState.error(
          errorMessage: "An unknown error occurred. Please try again later.",
        ),
      );
    }
  }

  Future<void> singOut() async {
    await _localDataSource.clearAllData();
    emit(const HomeState.singOut());
  }

  User getTeacher(Class class_) {
    try {
      return _users.where((user) => class_.teachers.any((element) => element == user.id)).first;
    } catch (e) {
      emit(const HomeState.loading());
      _userRepository.getAllUsers(DataSource.remote).then((user) {
        user.when(
          (data) {
            _users = data;
            emit(HomeState.loaded(currentUser: _userRepository.getCurrentUser()!));
          },
          (error) => emit(HomeState.error(errorMessage: error.errorMessage)),
        );
      });
      return User.defaultUser();
    }
  }

  Future<void> refresh() async {
    _init();
  }
}
