import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_app/data/google_sheets.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/model/user_entity.dart';
import 'package:school_app/domain/services/hashing.dart';
import 'package:uuid/uuid.dart';

abstract class AuthRepository {
  Future<void> createAccount(String password, String email, String username);

  Future<User> login(String email, String password);
}

class AuthRepositoryImp extends AuthRepository {

  final Uuid uuid;
  final HashingService hash;
  final GoogleSheets googleSheets;
  final Box hiveBox;

  AuthRepositoryImp({
    required this.uuid,
    required this.hash,
    required this.googleSheets,
    required this.hiveBox,
  });

  Future<void> insertUserToPref(User user, int row) async {
    await hiveBox.put(
      "user",
      UserEntity(
        row: row,
        username: user.username,
        email: user.email,
        id: user.id,
        grade: int.parse(user.grade ?? "0"),
        lastName: user.grade,
        firstName: user.firstName,
      ),
    );
  }

  @override
  Future<void> createAccount(
    String password,
    String email,
    String username,
  ) async {
    final insertedUser = User(
      id: uuid.v4(),
      username: username,
      hashedPassword: hash.hash(password),
      email: email,
    );

    final success = await googleSheets.insertUser(insertedUser);

    if (!success) {
      return Future.error(
        "Error while establishing connection with the server, try Again later",
      );
    } else {
      insertUserToPref(insertedUser, GoogleSheets.row);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await googleSheets.getUserByEmail(email);
    if (hash.verify(password, user.hashedPassword)) {
      insertUserToPref(user, GoogleSheets.row);
      return user;
    } else {
      return Future.error("Wrong password");
    }
  }
}
