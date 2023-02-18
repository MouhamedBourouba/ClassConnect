import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:school_app/data/data_source/cloud_data_source.dart';
import 'package:school_app/data/data_source/local_data_source.dart';
import 'package:school_app/data/model/Error.dart';
import 'package:school_app/data/model/class.dart';
import 'package:school_app/data/model/source.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/domain/utils/extension.dart';
import 'package:uuid/uuid.dart';

abstract class ClassesRepository {
  ValueListenable<Box<Class>> getClassesValueListener();

  List<Class> getClasses();

  Future<Result<Unit, MException>> createClass(String className, String classSubject);

  Future<Result<Unit, MException>> joinClass(String classId);

  Future<Result<List<User>, MException>> getCurrentUserTeachers();
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
      final class_ = await cloudDataSource.getRowsByValue(classId, MTable.classesTable).timeout(7.seconds());
      if (class_?.isEmpty == true) return Result.error(MException("Class dose not exist please check the code"));
      final classes = currentUser.classes;
      if (classes?.contains(classId) == true) return Result.error(MException("Your already joined this class"));
      classes?.add(classId);
      final updatingUserTask = cloudDataSource.updateValue(
        classes ?? [classId],
        MTable.usersTable,
        rowKey: currentUser.id,
        columnKey: "classes",
      );
      if (await updatingUserTask) {
        await localDataSource.updateCurrentUser(classes: classes ?? [classId]);
        await localDataSource.addClass(class_!.first.toClass());
        return Result.success(unit);
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
  List<Class> getClasses() => localDataSource.getClasses();

  @override
  Future<Result<List<User>, MException>> getCurrentUserTeachers() async {
    try {
      final classes = getClasses();
      final users = await userRepository.getAllUsers(DataSource.local);
      final teachersFromLocalDB = users.tryGetSuccess()?.where(
            (user) => classes.any((class_) => class_.creatorId == user.id),
          );
      if ((teachersFromLocalDB?.length ?? -1) == classes.length) {
        return Result.success(teachersFromLocalDB!.toList());
      } else {
        final usersFromCloud = await userRepository.getAllUsers(DataSource.remote);
        return usersFromCloud.when(
          (users) =>
              Result.success(users.where((user) => classes.any((class_) => class_.creatorId == user.id)).toList()),
          (error) => Result.error(
            MException("Field to connect to the server please check your internet connection and try later"),
          ),
        );
      }
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }
}
