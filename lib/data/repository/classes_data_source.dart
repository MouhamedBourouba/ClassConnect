import 'dart:convert';
import 'dart:io';

import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

abstract class ClassesRepository {
  ValueListenable<Box<Class>> getClassesValueListener();

  Future<List<Class>> getClasses(DataSource source);

  Future<Result<Unit, MException>> createClass(String className, String classSubject);

  Future<Result<Unit, MException>> joinClass(String classId);

  Future<Result<List<User>, MException>> getCurrentUserTeachers([DataSource? source]);
}

@LazySingleton(as: ClassesRepository)
class ClassesRepositoryImp extends ClassesRepository {
  final LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;
  final Uuid uuid;
  final UserRepository userRepository;

  ClassesRepositoryImp(this.localDataSource, this.cloudDataSource, this.uuid, this.userRepository);

  @override
  Future<Result<Unit, MException>> createClass(String className, String classSubject) async {
    try {
      final classId = uuid.v1().substring(0, 5);
      final currentUser = localDataSource.getCurrentUser()!;
      final currentUserTeachingClasses = currentUser.teachingClasses;
      currentUserTeachingClasses?.add(classId);
      final class_ = Class(
        id: classId,
        creatorId: currentUser.id,
        streamMessagesId: uuid.v1().substring(0, 6),
        studentsIds: [],
        homeWorkId: uuid.v1().substring(0, 7),
        bannedStudents: [],
        className: className,
        subject: classSubject,
      );
      final addingClassTask = cloudDataSource.appendRow(class_.toMap(), MTable.classesTable);
      final updatingUserTask = cloudDataSource.updateValue(
        currentUserTeachingClasses ?? [classId],
        MTable.usersTable,
        rowKey: currentUser.id,
        columnKey: "teachingClasses",
      );
      if (await addingClassTask && await updatingUserTask) {
        await localDataSource.addClass(class_);
        await localDataSource.updateCurrentUser(teachingClasses: currentUserTeachingClasses ?? [classId]);
        return Result.success(unit);
      } else {
        return Result.error(MException.unknown());
      }
    } on SocketException {
      return Result.error(MException.noInternetConnection());
    } on Exception {
      return Result.error(MException.unknown());
    }
  }

  @override
  Future<Result<Unit, MException>> joinClass(String classId) async {
    try {
      final currentUser = localDataSource.getCurrentUser()!;
      final searchingForClass = await cloudDataSource.getRowsByValue(classId, MTable.classesTable);
      if (searchingForClass.isEmpty == true) {
        return Result.error(MException("Class dose not exist please check the code"));
      }
      final classes = currentUser.classes;
      final classMap = searchingForClass.first;
      if (classes?.contains(classId) == true) return Result.error(MException("Your already joined this class"));
      if (currentUser.teachingClasses?.contains(classId) == true) {
        return Result.error(
          MException("You are the teacher of this class you cant join it as student"),
        );
      }
      classes?.add(classId);
      final students = classMap["studentsIds"].toString().toList();
      students.add(currentUser.id);
      final updatingClassTask = cloudDataSource.updateValue(
        jsonEncode(students),
        MTable.classesTable,
        rowKey: classId,
        columnKey: "studentsIds",
      );
      if (await updatingClassTask) {
        final updatingUserTask = userRepository.updateUser(classes: classes ?? [classId]);
        if ((await updatingUserTask).isSuccess()) {
          await localDataSource.addClass(classMap.toClass());
          return Result.success(unit);
        } else {
          return Result.error(MException.unknown());
        }
      } else {
        return Result.error(MException.unknown());
      }
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }

  @override
  ValueListenable<Box<Class>> getClassesValueListener() => localDataSource.getClassesValueListener();

  @override
  Future<List<Class>> getClasses(DataSource source) async {
    try {
      if (source == DataSource.local) {
        return localDataSource.getClasses();
      } else {
        final classesMap = await cloudDataSource.getAllRows(MTable.usersTable);
        final List<Class> classes = [];
        classesMap?.forEach((class_) {
          final List<String> students = class_["studentsIds"].toString().toList();
          if (students.any((id) => id == localDataSource.getCurrentUser()!.id) == true ||
              class_["creatorId"] == localDataSource.getCurrentUser()!.id) {
            classes.add(class_.toClass());
            localDataSource.addClass(class_.toClass());
          }
        });
        return classes;
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Result<List<User>, MException>> getCurrentUserTeachers([DataSource? source]) async {
    try {
      final classes = localDataSource.getClasses();
      Future<Result<List<User>, MException>> getTeachersFromCloud() async {
        return (await userRepository.getAllUsers(DataSource.remote)).when(
          (users) {
            final teachers = users.where((user) => classes.any((class_) => class_.creatorId == user.id));
            return Result.success(teachers.toList());
          },
          (error) => Result.error(error),
        );
      }

      if (source == DataSource.remote) {
        return getTeachersFromCloud();
      }
      final users = localDataSource.getUsers();
      final teachers = users.where((user) => classes.any((class_) => class_.creatorId == user.id));
      if (classes.every((class_) => teachers.any((teacher) => class_.creatorId == teacher.id))) {
        return Result.success(teachers.toList());
      } else {
        return getCurrentUserTeachers();
      }
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }
}
