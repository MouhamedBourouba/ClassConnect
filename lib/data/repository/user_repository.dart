import 'dart:io';

import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/settings_repository.dart';
import 'package:ClassConnect/data/services/hashing_service.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  User? getCurrentUser();

  Stream<BoxEvent> getUserUpdates();

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

  Future<Result<Unit, Unit>> sendEmailVerificationMessage();

  Future<Result<Unit, String>> verifyEmail(String code);
}

@LazySingleton(as: UserRepository)
class UserRepositoryImp extends UserRepository {
  final LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;
  final HashingService hashingService;
  final Uuid uuid;
  final SettingsRepository settingsRepository;

  UserRepositoryImp(
      this.hashingService, this.uuid, this.localDataSource, this.cloudDataSource, this.settingsRepository);

  Result<Unit, MException> checkUserDetails(String username, String email, List<User> users) {
    if (users.any((user) => user.username == username)) {
      return Error(MException("This username is already taken. Please choose a different username"));
    } else if (users.any((user) => user.email == email)) {
      return Error(MException("The email address is already associated with an account. Please log in"));
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
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }

  @override
  User? getCurrentUser() => localDataSource.getCurrentUser();

  @override
  Future<Result<Unit, MException>> registerUser(String username, String email, String password) async {
    try {
      final user = User(id: uuid.v1(), username: username, password: hashingService.hash(password), email: email);
      final allUsers = await getAllUsers(DataSource.remote);
      if (allUsers.isError()) return Error(allUsers.tryGetError()!);
      final isUserValidResult = checkUserDetails(username, email, allUsers.tryGetSuccess()!);
      if (isUserValidResult.isError()) return Result.error(isUserValidResult.tryGetError()!);
      await cloudDataSource.appendRow(user.toMap(), MTable.usersTable);
      await localDataSource.putDataToAppBox("current_user", user);
      return const Success(unit);
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }

  Future<Result<User, MException>> fetchUserByEmailOrUsername(String value) async {
    final searchingResult = await cloudDataSource.getRowsByValue(value, MTable.usersTable);
    if (searchingResult.isEmpty) {
      return Result.error(MException("There is no user associated with this Email/Username, Please register ..."));
    }
    return Result.success(searchingResult.first.toUser());
  }

  @override
  Future<Result<User, MException>> loginUser(String usernameOrEmail, String password) async {
    try {
      final userResult = await fetchUserByEmailOrUsername(usernameOrEmail);
      if (userResult.isError()) return Result.error(userResult.tryGetError()!);
      final user = userResult.tryGetSuccess()!;
      final isPasswordCorrect = hashingService.verify(password, user.password);
      if (!isPasswordCorrect) return Result.error(MException("Incorrect password. Please try again"));
      await localDataSource.putDataToAppBox("current_user", user);
      final isEmailVerified = await checkEmailVerification(user);
      settingsRepository.setIsEmailVerified(isEmailVerified: isEmailVerified);
      return Result.success(user);
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }

  Future<bool> checkEmailVerification(User user) async {
    final otpList = await cloudDataSource.getAllRows(MTable.emailOtpTabel);
    final isVerified = otpList?.any((element) => element["isVerified"] == "true" && element["userId"] == user.id);
    return isVerified == true;
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
        final usersJson = await cloudDataSource.getAllRows(MTable.usersTable);
        if (usersJson == null || usersJson.isEmpty) return Result.error(MException.unknown());
        final List<User> users = [];
        for (final userJson in usersJson) {
          users.add(userJson.toUser());
        }
        for (final user in users) {
          localDataSource.addUserToUsersBox(user);
        }
        return Result.success(users);
      } on SocketException {
        return Result.error(MException.noInternetConnection());
      } catch (e) {
        return Result.error(MException.unknown());
      }
    }
  }

  @override
  Future<Result<Unit, Unit>> sendEmailVerificationMessage() async {
    try {
      final user = localDataSource.getCurrentUser();
      final username = user!.username;
      final email = user.email;
      final userId = user.id;
      final response =
          await http.get(Uri.parse("http://192.168.1.16:8080/email_verification/$email/$username/$userId"));
      if (response.statusCode == 200) {
        return Result.success(unit);
      } else {
        return Result.error(unit);
      }
    } catch (e) {
      return Result.error(unit);
    }
  }

  @override
  Future<Result<Unit, String>> verifyEmail(String code) async {
    try {
      final otpMap = await cloudDataSource.getRowsByValue(code, MTable.emailOtpTabel);
      if (otpMap.isEmpty) return Result.error("code does not exist. Please double-check and try again");
      final isCodeCorrect =
          otpMap.any((element) => element["userId"] == localDataSource.getCurrentUser()!.id && element["code"] == code);
      if (isCodeCorrect) {
        await cloudDataSource.updateValues(
          true,
          MTable.emailOtpTabel,
          rowKey: localDataSource.getCurrentUser()!.id,
          column: 3,
        );
        return Result.success(unit);
      } else {
        return Result.error("code does not exist. Please double-check and try again");
      }
    } catch (e) {
      return Result.error("An unknown error occurred. Please try again later.");
    }
  }

  @override
  Stream<BoxEvent> getUserUpdates() => localDataSource.getCurrentUserUpdates();

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
      if ((await cloudDataSource.getRowsByValue(username, MTable.usersTable)).isEmpty) {
        tasksList.add(
          cloudDataSource.updateValue(
            username,
            MTable.usersTable,
            rowKey: userId,
            columnKey: "username",
          ),
        );
        localDataSource.updateCurrentUser(username: username);
      } else {
        return Result.error(MException("This username is already taken. Please choose a different username."));
      }
    }
    if (firstName != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          firstName.replaceAll(" ", ""),
          MTable.usersTable,
          rowKey: userId,
          columnKey: "firstName",
        ),
      );
      localDataSource.updateCurrentUser(firstName: firstName);
    }
    if (lastName != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          lastName.replaceAll(" ", ""),
          MTable.usersTable,
          rowKey: userId,
          columnKey: "lastName",
        ),
      );
      localDataSource.updateCurrentUser(lastName: lastName);
    }
    if (email != null) {
      if ((await cloudDataSource.getRowsByValue(email, MTable.usersTable)).isEmpty) {
        tasksList.add(
          cloudDataSource.updateValue(
            email,
            MTable.usersTable,
            rowKey: userId,
            columnKey: "email",
          ),
        );
        localDataSource.updateCurrentUser(email: email);
      } else {
        return Result.error(
          MException(
            'The email address is already associated with another account',
          ),
        );
      }
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
      localDataSource.updateCurrentUser(grade: grade);
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
      localDataSource.updateCurrentUser(parentPhone: parentPhone);
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
      localDataSource.updateCurrentUser(classes: classes);
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
      localDataSource.updateCurrentUser(teachingClasses: teachingClasses);
    }
    try {
      for (final task in tasksList) {
        await task;
      }
      return Result.success(unit);
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }
}
