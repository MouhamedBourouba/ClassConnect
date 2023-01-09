import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/user_data_source.dart';
import 'package:school_app/domain/services/hashing_service.dart';
import 'package:uuid/uuid.dart';

abstract class AuthRepository {
  Future<void> createAccount(String password, String email, String username);

  Future<User> login(String email, String password);
}

class AuthRepositoryImp extends AuthRepository {
  final Uuid uuid;
  final HashingService hashingService;
  final UserDataSource dataSource;
  final Box hiveBox;

  AuthRepositoryImp({
    required this.uuid,
    required this.hashingService,
    required this.dataSource,
    required this.hiveBox,
  });

  @override
  Future<void> createAccount(
    String password,
    String email,
    String username,
  ) async {
    final user = User(
      id: uuid.v4(),
      username: username,
      password: hashingService.hash(password),
      email: email,
    );
    await dataSource.appendUser(user);
    await hiveBox.put(
      "user",
      user,
    );
    await hiveBox.put("isLoggedIn", true);
    await hiveBox.put("isAccountCompleted", false);
    return;
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await dataSource.findUserByEmail(email);
    if (hashingService.verify(password, user.password)) {
      await hiveBox.put("user", user);
      await hiveBox.put("isLoggedIn", true);
      await hiveBox.put(
        "isAccountCompleted",
        user.lastName != null && user.lastName != null && user.grade != null && user.parentPhone != null,
      );
      return user;
    } else {
      return Future.error("Wrong password");
    }
  }
}
