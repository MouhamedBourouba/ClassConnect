import 'dart:convert';

import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/class_message.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/data/repository/user_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

enum Role { classMate, teacher }

abstract class ClassesRepository {
  ValueListenable<Box<Class>> getClassesValueListener();

  Future<List<Class>> getClasses(DataSource source);

  Future<Result<Unit, MException>> createClass(String className, String classSubject);

  Future<Result<Unit, MException>> joinClass(String classId);

  Future<Result<Unit, MException>> inviteMember(Class class_, String teacherEmail, Role role);

  Future<Class> getClassById(String id);

  Future<Result<Unit, String>> sendMessage(ClassMessage classMessage);

  Future<Result<List<ClassMessage>, String>> getClassMessages(String streamMessagesId);

  Future<Result<Unit, String>> acceptInvitation(ClassInvitationEventData data);
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
      final class_ = Class(
        id: classId,
        teachers: [currentUser.id],
        streamMessagesId: uuid.v1().substring(0, 6),
        studentsIds: [],
        homeWorkId: uuid.v1().substring(0, 7),
        bannedStudents: [],
        className: className,
        subject: classSubject,
      );
      final addingClassTask = cloudDataSource.appendRow(class_.toMap(), MTable.classesTable);
      if (await addingClassTask) {
        await localDataSource.addClass(class_);
        return Result.success(unit);
      } else {
        return Result.error(MException.unknown());
      }
    } catch (e) {
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
      final class_ = searchingForClass.first.toClass();
      if (class_.teachers.contains(currentUser.id)) {
        return Result.error(MException("You are the teacher of this class you cant join it as student"));
      } else if (class_.studentsIds.contains(currentUser.id)) {
        return Result.error(MException("you've already joined this class"));
      }
      class_.studentsIds.add(currentUser.id);
      final updatingClassTask = cloudDataSource.updateValue(
        jsonEncode(class_.studentsIds),
        MTable.classesTable,
        rowKey: classId,
        columnKey: "studentsIds",
      );
      if (await updatingClassTask) {
        await localDataSource.addClass(class_);
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
  Future<List<Class>> getClasses(DataSource source) async {
    try {
      if (source == DataSource.local) {
        return localDataSource.getClasses();
      } else {
        final classesMap = await cloudDataSource.getAllRows(MTable.classesTable);
        final List<Class> classes = [];
        classesMap?.forEach((classMap) {
          final class_ = classMap.toClass();
          if (class_.studentsIds.contains(localDataSource.getCurrentUser()!.id) || class_.teachers.contains(localDataSource.getCurrentUser()!.id)) {
            classes.add(class_);
            localDataSource.addClass(class_);
          }
        });
        return classes;
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Result<Unit, MException>> inviteMember(Class class_, String teacherEmail, Role role) async {
    final currentUser = localDataSource.getCurrentUser()!;
    final updatedClass = await getClassById(class_.id);
    if (currentUser.email == teacherEmail) return Result.error(MException("you can't invite yourself"));
    try {
      final searchingForUser = await cloudDataSource.getRowsByValue(teacherEmail, MTable.usersTable);
      if (searchingForUser.isEmpty) {
        return Result.error(MException("Can't find this ${role == Role.teacher ? "teacher" : "user"} please double check the email address"));
      }
      final userData = searchingForUser.first.toUser();
      if (updatedClass.teachers.contains(userData.id)) return Result.error(MException("This user is already teacher in this class"));
      final sendingInvitationTask = await cloudDataSource.appendRow(
        UserEvent(
          id: getIt<Uuid>().v1(),
          eventType: EventType.classMemberShipInvitation,
          eventReceiverId: userData.id,
          eventSenderId: currentUser.id,
          seen: false,
          encodedContent: jsonEncode(
            ClassInvitationEventData(
              role: role,
              senderName: currentUser.fullName,
              classId: class_.id,
              className: updatedClass.className,
            ).toMap(),
          ),
        ).toMap(),
        MTable.eventsTable,
      );
      return sendingInvitationTask ? Result.success(unit) : Result.error(MException.unknown());
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }

  @override
  Future<Class> getClassById(String id) async {
    final classMap = await cloudDataSource.getRow(MTable.classesTable, rowKey: id);
    return classMap!.toClass();
  }

  @override
  Future<Result<Unit, String>> acceptInvitation(ClassInvitationEventData data) async {
    try {
      final currentUser = localDataSource.getCurrentUser()!;
      final classData = (await cloudDataSource.getRow(MTable.classesTable, rowKey: data.classId))!.toClass();
      late List<String> updatedList;
      if (classData.teachers.contains(currentUser.id)) {
        return Result.error("You are already teacher in this class");
      } else if (classData.studentsIds.contains(currentUser.id) && data.role == Role.classMate) {
        return Result.error("you've already joined this class");
      }

      switch (data.role) {
        case Role.classMate:
          updatedList = [...classData.studentsIds, localDataSource.getCurrentUser()!.id];
          break;
        case Role.teacher:
          updatedList = [...classData.teachers, localDataSource.getCurrentUser()!.id];
          break;
      }
      await cloudDataSource.updateValue(
        updatedList,
        MTable.classesTable,
        rowKey: data.classId,
        columnKey: data.role == Role.classMate ? 'studentsIds' : "teachers",
      );

      await localDataSource.addClass(classData);
      return Result.success(unit);
    } catch (e) {
      return Result.error("An unknown error occurred. Please try again later.");
    }
  }

  @override
  Future<Result<Unit, String>> sendMessage(ClassMessage classMessage) async {
    final isSuccess = await cloudDataSource.appendRow(classMessage.toMap(), MTable.streamMessagesTable);
    return isSuccess ? Result.success(unit) : Result.error("An unknown error occurred. Please try again later.");
  }

  @override
  Future<Result<List<ClassMessage>, String>> getClassMessages(String streamMessagesId) async {
    final allMessages =
        (await cloudDataSource.getAllRows(MTable.streamMessagesTable))?.map((e) => ClassMessage.fromMap(e)) ?? localDataSource.getClassMessages();
    for (final message in allMessages) {
      localDataSource.addClassMessage(message);
    }
    return Result.success(allMessages.where((element) => element.streamMessagesId == streamMessagesId).toList());
  }
}
