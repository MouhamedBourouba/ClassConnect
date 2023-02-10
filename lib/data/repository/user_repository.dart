import 'package:injectable/injectable.dart';
import 'package:school_app/data/data_source/cloud_data_source.dart';
import 'package:school_app/data/data_source/local_data_source.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/domain/utils/extension.dart';
import 'package:school_app/domain/services/hashing_service.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  User? getCurrentUser();

  Future<void> registerUser(String username, String email, String password);

  Future<User> loginUser(String usernameOrEmail, String password);

  Future<void> updateUser({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    int? grade,
    String? parentPhone,
    List<String>? classes,
    List<String>? teachingClasses,
  });

  Future<User> fetchUserById(String id);

  Future<User?> fetchUserByEmailOrUsername(String value);

  Future<void> checkUserDetails(String username, String email);

  List<User> getAllUsersFromLocalDB();

  Future<List<Map<String, String>>?> getAllUsersFromCloudDB();
}

@LazySingleton(as: UserRepository)
class UserRepositoryImp extends UserRepository {
  final LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;
  final HashingService hashingService;
  final Uuid uuid;

  UserRepositoryImp(this.hashingService, this.uuid, this.localDataSource, this.cloudDataSource);

  @override
  Future<void> checkUserDetails(String username, String email) async {
    final allUsers = await getAllUsersFromCloudDB();
    if (allUsers!.any((user) => user["username"] == username)) {
      return Future.error("Username Already Taken, Please Change it");
    }
    if (allUsers.any((user) => user["email"] == email)) {
      return Future.error("Email Already In User, Please login");
    }
  }

  @override
  Future<List<Map<String, String>>?> getAllUsersFromCloudDB() async {
    final allUsers = await cloudDataSource.getAllRows(MTable.usersTable);
    for (final userMap in allUsers!) {
      await localDataSource.addUserToUsersBox(userMap.toUser());
    }
    return allUsers;
  }

  @override
  List<User> getAllUsersFromLocalDB() => localDataSource.getUsers();

  @override
  User? getCurrentUser() => localDataSource.getCurrentUser();

  @override
  Future<void> registerUser(String username, String email, String password) async {
    final user = User(id: uuid.v1(), username: username, password: hashingService.hash(password), email: email);
    await checkUserDetails(username, email);
    await cloudDataSource.appendRow(user.toMap(), MTable.usersTable);
    await localDataSource.putDataToAppBox("current_user", user);
    await localDataSource.putDataToAppBox("isLoggedIn", true);
    return;
  }

  @override
  Future<User?> fetchUserByEmailOrUsername(String value) async {
    final searchTaskResult = await cloudDataSource.getRowsByValue(value, MTable.usersTable);
    return searchTaskResult?.first.toUser();
  }

  @override
  Future<User> loginUser(String usernameOrEmail, String password) async {
    final user = await fetchUserByEmailOrUsername(usernameOrEmail);
    if (user == null) return Future.error("User Dose not exist, check your email/username");
    final isPasswordCorrect = hashingService.verify(password, user.password);
    if (!isPasswordCorrect) return Future.error("Wrong password !");
    await localDataSource.putDataToAppBox("current_user", user);
    await localDataSource.putDataToAppBox("isLoggedIn", true);
    return user;
  }

  @override
  Future<User> fetchUserById(String id) async {
    final userMap = await cloudDataSource.getRow(MTable.usersTable, rowKey: id);
    if (userMap == null) {
      return Future.error("Please login again");
    }
    return userMap.toUser();
  }

  @override
  Future<void> updateUser({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    int? grade,
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
      for (final task in tasksList) {
        await task;
      }
      return;
    }
  }
}
