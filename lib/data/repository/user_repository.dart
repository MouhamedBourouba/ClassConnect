import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:school_app/data/data_source/cloud_data_source.dart';
import 'package:school_app/data/data_source/local_data_source.dart';
import 'package:school_app/data/model/error.dart';
import 'package:school_app/data/model/source.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/domain/services/hashing_service.dart';
import 'package:school_app/domain/utils/extension.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  User? getCurrentUser();

  Future<Result<void, MException>> registerUser(String username, String email, String password);

  Future<Result<User, MException>> loginUser(String usernameOrEmail, String password);

  Future<Result<Unit, MException>> updateUser({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? grade,
    String? parentPhone,
    List<String>? classes,
    List<String>? teachingClasses,
  });

  Future<Result<List<User>, MException>> getAllUsers(DataSource dataSource);

  Future<Result<List<User>, MException>> saveUsersToLocalDataSource();
}

@LazySingleton(as: UserRepository)
class UserRepositoryImp extends UserRepository {
  final LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;
  final HashingService hashingService;
  final Uuid uuid;

  UserRepositoryImp(this.hashingService, this.uuid, this.localDataSource, this.cloudDataSource);

  Result<Unit, MException> checkUserDetails(String username, String email, List<User> users) {
    if (users.any((user) => user.username == username)) {
      return Error(MException("Username Already Taken, Please Change it"));
    } else if (users.any((user) => user.email == email)) {
      return Error(MException("Email Already In User, Please login"));
    } else {
      return const Success(unit);
    }
  }

  @override
  Future<Result<List<User>, MException>> saveUsersToLocalDataSource() async {
    try {
      final allUsersMap = await cloudDataSource.getAllRows(MTable.usersTable);
      final List<User> allUsers = [];
      for (final userMap in allUsersMap!) {
        allUsers.add(userMap.toUser());
        await localDataSource.addUserToUsersBox(userMap.toUser());
      }
      return Result.success(allUsers);
    } on SocketException {
      return Result.error(MException.noInternetConnection());
    } on Exception {
      return Result.error(MException.unknown());
    }
  }

  @override
  User? getCurrentUser() => localDataSource.getCurrentUser();

  @override
  Future<Result<Unit, MException>> registerUser(String username, String email, String password) async {
    try {
      final user = User(id: uuid.v1(), username: username, password: hashingService.hash(password), email: email);
      final allUsers = await getAllUsers(DataSource.remote).timeout(const Duration(seconds: 10));
      if (allUsers.isError()) return Error(allUsers.tryGetError()!);
      checkUserDetails(username, email, allUsers.tryGetSuccess()!);
      await cloudDataSource.appendRow(user.toMap(), MTable.usersTable).timeout(const Duration(seconds: 10));
      await localDataSource.putDataToAppBox("current_user", user);
      return const Success(unit);
    } catch(e) {
      return Result.error(MException.unknown());
    }
  }

  Future<Result<User, MException>> fetchUserByEmailOrUsername(String value) async {
    final searchingResult = await cloudDataSource.getRowsByValue(value, MTable.usersTable);
    if (searchingResult == null || searchingResult.isEmpty) {
      return Result.error(MException("There is no user associated with this Email/Username, Please register ..."));
    }
    return Result.success(searchingResult.first.toUser());
  }

  @override
  Future<Result<User, MException>> loginUser(String usernameOrEmail, String password) async {
    try {
      final userResult = await fetchUserByEmailOrUsername(usernameOrEmail).timeout(const Duration(seconds: 10));
      if (userResult.isError()) return Result.error(userResult.tryGetError()!);
      final user = userResult.tryGetSuccess()!;
      final isPasswordCorrect = hashingService.verify(password, user.password);
      if (!isPasswordCorrect) return Result.error(MException("Wrong password !"));
      await localDataSource.putDataToAppBox("current_user", user);
      return Result.success(user);
    } catch(e) {
      debugPrint(e.toString());
      return Result.error(MException.unknown());
    }
  }

  Future<Result<User, MException>> fetchUserById(String id) async {
    final userMapById = await cloudDataSource.getRow(MTable.usersTable, rowKey: id);
    if (userMapById == null) return Result.error(MException.unknown());
    return Result.success(userMapById.toUser());
  }

  @override
  Future<Result<List<User>, MException>> getAllUsers(DataSource dataSource) async {
    if (dataSource == DataSource.local) {
      return Result.success(localDataSource.getUsers());
    } else {
      try {
        final usersJson = await cloudDataSource.getAllRows(MTable.usersTable).timeout(const Duration(seconds: 10));
        if (usersJson == null || usersJson.isEmpty) return Result.error(MException.unknown());
        final List<User> users = [];
        for (final userJson in usersJson) {
          users.add(userJson.toUser());
        }
        return Result.success(users);
      } on SocketException {
        return Result.error(MException.noInternetConnection());
      } on Exception {
        return Result.error(MException.unknown());
      }
    }
  }

  @override
  Future<Result<Unit, MException>> updateUser({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? grade,
    String? parentPhone,
    List<String>? classes,
    List<String>? teachingClasses,
  }) async {
    final userId = localDataSource.getCurrentUser()!.id;
    final List<Future<bool>> tasksList = [];
    if (username != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          username,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "username",
        ),
      );
    }
    if (firstName != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          firstName,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "firstName",
        ),
      );
    }
    if (lastName != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          lastName,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "lastName",
        ),
      );
    }
    if (email != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          email,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "email",
        ),
      );
    }
    if (grade != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          grade,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "grade",
        ),
      );
    }
    if (parentPhone != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          parentPhone,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "parentPhone",
        ),
      );
    }
    if (classes != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          classes,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "classes",
        ),
      );
    }
    if (teachingClasses != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          teachingClasses,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "teachingClasses",
        ),
      );
    }
    try {
      for (final task in tasksList) {
        await task;
      }
      return Result.success(unit);
    } on Exception {
      return Result.error(MException.unknown());
    }
  }
}
