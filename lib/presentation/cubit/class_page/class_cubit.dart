import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_cubit.freezed.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit(String classId) : super(const ClassState.initial()) {
    emit(state.copyWith(classId: classId, currentUser: userRepository.getCurrentUser()));
    late final Class currentClass;
    isOnline().then((isOnline) async {
      currentClass = (isOnline ? await classesRepository.getClasses(DataSource.remote) : await classesRepository.getClasses(DataSource.local))
          .where((class_) => class_.id == state.classId)
          .first;
      emit(state.copyWith(currentClass: currentClass));
      fetchClassMembers();
    });
  }

  final ClassesRepository classesRepository = getIt();
  final UserRepository userRepository = getIt();

  void navigate(int index) => emit(state.copyWith(pageIndex: index));

  Future<void> fetchClassMembers() async {
    emit(state.copyWith(pageState: PageState.loading));
    final List<User> classMates = [];
    final List<User> teachers = [];
    for (final element in state.currentClass!.studentsIds) {
      final user = (await userRepository.fetchUserById(element)).tryGetSuccess();
      if (user != null) classMates.add(user);
    }
    for (final element in state.currentClass!.teachers) {
      final user = (await userRepository.fetchUserById(element)).tryGetSuccess();
      if (user != null) teachers.add(user);
    }
    emit(
      state.copyWith(
        classMembers: classMates,
        teachers: teachers,
        pageState: PageState.success,
      ),
    );
  }

  void onTeacherEmailChanged(String value) => emit(state.copyWith(teacherEmail: value));

  Future<void> inviteMember(Role role) async {
    if (state.teacherEmail.isEmpty) return;
    emit(state.copyWith(pageState: PageState.loading));
    (await classesRepository.inviteMember(state.currentClass!, state.teacherEmail, role)).when(
      (success) {
        fetchClassMembers();
        emit(state.copyWith(pageState: PageState.init));
      },
      (error) => emit(state.copyWith(pageState: PageState.error, errorMessage: error.errorMessage)),
    );
  }

  void setStateToInit() => emit(state.copyWith(pageState: PageState.init));
}
