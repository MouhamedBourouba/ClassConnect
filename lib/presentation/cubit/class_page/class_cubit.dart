import 'dart:math';

import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_cubit.freezed.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit(String classId) : super(const ClassState.initial()) {
    fetchClassMembers();
    emit(state.copyWith(classId: classId, currentUser: userRepository.getCurrentUser()));
    classesRepository.getClasses(DataSource.local).then((classes) {
      try {
        final currentClass = classes.where((element) => element.id == classId).first;
        emit(state.copyWith(currentClass: currentClass));
      } catch (e) {
        classesRepository.getClasses(DataSource.remote).then((classes) {
          final currentClass = classes.where((element) => element.id == classId).first;
          emit(state.copyWith(currentClass: currentClass));
        });
      }
    });
  }

  final ClassesRepository classesRepository = getIt();
  final UserRepository userRepository = getIt();

  void navigate(int index) => emit(state.copyWith(pageIndex: index));

  Future<void> fetchClassMembers() async {
    List<User> users = [];
    emit(state.copyWith(pageState: PageState.loading));
    try {
      if (!(await isOnline())) throw Exception();
      (await userRepository.getAllUsers(DataSource.remote)).when(
        (data) => users = data,
        (error) => throw Exception(),
      );
    } catch (e) {
      (await userRepository.getAllUsers(DataSource.local)).when(
        (data) {
          final List<User> users0 = [];
          for (final user in data) {
            if(!users0.any((element) => element.id == user.id)) users0.add(user);
          }
          users = users0;
        },
        (error) => null,
      );
    }
    final classMates = users.where((user) => user.classes.any((id) => id == state.classId)).toList();
    final teachers = users.where((user) => user.teachingClasses.any((classId) => classId == state.classId)).toList();
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
    if(state.teacherEmail.isEmpty) return;
    emit(state.copyWith(pageState: PageState.loading));
    (await classesRepository.inviteMember(state.classId, state.teacherEmail, role)).when(
      (success) {
        fetchClassMembers();
        emit(state.copyWith(pageState: PageState.init));
      },
      (error) => emit(state.copyWith(pageState: PageState.error, errorMessage: error.errorMessage)),
    );
  }

  void setStateToInit() => emit(state.copyWith(pageState: PageState.init));
}
