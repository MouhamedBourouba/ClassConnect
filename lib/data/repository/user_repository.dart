import 'dart:convert';

import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/source.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/settings_repository.dart';
import 'package:ClassConnect/data/services/hashing_service.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  User? getCurrentUser();

  Stream<BoxEvent> getUserUpdates();

  Future<Result<void, MException>> registerUser(
    String fullName,
    String email,
    String password,
    String phoneNumber,
  );

  Future<Result<User, MException>> loginUser(String usernameOrEmail, String password);

  Future<Result<Unit, MException>> updateUser({
    String? fullName,
    String? email,
    String? phoneNumber,
  });

  Future<Result<List<User>, MException>> getAllUsers(DataSource dataSource);

  Future<Result<List<User>, MException>> saveUsersToLocalDataSource();

  Future<Result<Unit, Unit>> sendEmailVerificationMessage();

  Future<Result<Unit, String>> verifyEmail(String code);

  Future<Result<User, Unit>> fetchUserById(String id);
}

@LazySingleton(as: UserRepository)
class UserRepositoryImp extends UserRepository {
  final LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;
  final HashingService hashingService;
  final Uuid uuid;
  final SettingsRepository settingsRepository;

  UserRepositoryImp(this.hashingService, this.uuid, this.localDataSource, this.cloudDataSource, this.settingsRepository);

  Result<Unit, MException> checkUserDetails(String username, String email, List<User> users) {
    if (users.any((user) => user.fullName == username)) {
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
        await localDataSource.addUser(userMap.toUser());
      }
      return Result.success(allUsers);
    } catch (e) {
      return Result.error(MException.unknown());
    }
  }

  @override
  User? getCurrentUser() => localDataSource.getCurrentUser();

  @override
  Future<Result<Unit, MException>> registerUser(String fullName, String email, String password, String phoneNumber) async {
    try {
      final user = User(
        id: uuid.v1(),
        fullName: fullName,
        password: hashingService.hash(password),
        email: email,
        phoneNumber: phoneNumber,
      );
      final allUsers = await getAllUsers(DataSource.remote);
      if (allUsers.isError()) return Error(allUsers.tryGetError()!);
      final isUserValidResult = checkUserDetails(fullName, email, allUsers.tryGetSuccess()!);
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

  @override
  Future<Result<User, Unit>> fetchUserById(String id) async {
    if (await isOnline()) {
      final userMapById = await cloudDataSource.getRow(MTable.usersTable, rowKey: id);
      if (userMapById == null) return Result.error(unit);
      return Result.success(userMapById.toUser());
    } else {
      final userL = localDataSource.getUsers().where((element) => element.id == id);
      return userL.isEmpty ? Result.error(unit) : Result.success(userL.first);
    }
  }

  @override
  Future<Result<List<User>, MException>> getAllUsers(DataSource dataSource) async {
    if (dataSource == DataSource.local) {
      return Result.success(localDataSource.getUsers());
    } else {
      try {
        final usersJson = await cloudDataSource.getAllRows(MTable.usersTable);
        if (usersJson == null || usersJson.isEmpty) return Result.error(MException.unknown());
        final List<User> users = usersJson.map((e) => e.toUser()).toList();
        for (final user in users) {
          localDataSource.addUser(user);
        }
        return Result.success(users);
      } catch (e) {
        return Result.error(MException.unknown());
      }
    }
  }

  @override
  Future<Result<Unit, Unit>> sendEmailVerificationMessage() async {
    try {
      String getEmailVerificationMessage(String username) {
        return """
Dear $username, 
Thank you for registering in our app, ClassConnect is an online platform designed to enhance your learning experience.
We are thrilled to have you on board! To activate your account, we need you to confirm your email address.
Here is your code: ___code___,
once you Confirmed Your Email will have full access to our App, where you can connect with your teachers and classmates, participate in discussions, access course
materials, and submit assignments.
We look forward to seeing you on the app and providing you with an engaging and interactive learning environment. Thank you for choosing our App.
If you have any questions or concerns, please don't hesitate to contact our support team at ClassConnect@gmail.com.
Best regards,
Bourouba Mouhamed
ClassConnect APP""";
      }

      final user = localDataSource.getCurrentUser();
      final username = user!.fullName;
      final email = user.email;
      final response = await http.get(
        Uri.parse(
          "https://mouhamed22.pythonanywhere.com/email_verification/$email/${getEmailVerificationMessage(username)}/ClassConnect email verification",
        ),
      );
      if (response.statusCode == 200) {
        cloudDataSource.appendRow(
          {"userId": localDataSource.getCurrentUser()!.id, "code": jsonDecode(response.body) as String, "isVerified": false},
          MTable.emailOtpTabel,
        );
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
      final isCodeCorrect = otpMap.any((element) => element["userId"] == localDataSource.getCurrentUser()!.id && element["code"] == code);
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
    String? fullName,
    String? email,
    String? phoneNumber,
  }) async {
    final userId = localDataSource.getCurrentUser()!.id;
    final List<Future<bool>> tasksList = [];
    if (fullName != null) {
      if ((await cloudDataSource.getRowsByValue(fullName, MTable.usersTable)).isEmpty) {
        tasksList.add(
          cloudDataSource.updateValue(
            fullName,
            MTable.usersTable,
            rowKey: userId,
            columnKey: "fullName",
          ),
        );
        localDataSource.updateCurrentUser(fullName: fullName);
      } else {
        return Result.error(MException("This username is already taken. Please choose a different username."));
      }
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
        settingsRepository.setIsEmailVerified(isEmailVerified: false);
      } else {
        return Result.error(
          MException(
            'The email address is already associated with another account',
          ),
        );
      }
    }
    if (phoneNumber != null) {
      tasksList.add(
        cloudDataSource.updateValue(
          phoneNumber,
          MTable.usersTable,
          rowKey: userId,
          columnKey: "phoneNumber",
        ),
      );
      localDataSource.updateCurrentUser(phoneNumber: phoneNumber);
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
