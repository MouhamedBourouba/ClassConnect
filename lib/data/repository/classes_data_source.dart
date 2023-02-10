import 'package:injectable/injectable.dart';
import 'package:school_app/data/data_source/cloud_data_source.dart';
import 'package:school_app/data/data_source/local_data_source.dart';
import 'package:school_app/data/model/class.dart';
import 'package:uuid/uuid.dart';

abstract class ClassesRepository {
  Future<void> createClass(String className, String classSubject);

  Future<void> joinClass(String classId);
}

@LazySingleton(as: ClassesRepository)
class ClassesRepositoryImp extends ClassesRepository {
  final LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;
  final Uuid uuid;

  ClassesRepositoryImp(this.localDataSource, this.cloudDataSource, this.uuid);

  @override
  Future<void> createClass(String className, String classSubject) async {
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
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> joinClass(String classId) async {
    final currentUser = localDataSource.getCurrentUser()!;
    currentUser.classes?.add(classId);
    final updatingUserTask = cloudDataSource.updateValue(
      currentUser.classes ?? [classId],
      MTable.usersTable,
      rowKey: currentUser.id,
      columnKey: "classes",
    );
    if(await updatingUserTask) {
      await localDataSource.updateCurrentUser(classes: currentUser.classes ?? [classId]);
      return;
    }
  }
}
