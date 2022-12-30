import 'package:school_app/data/google_sheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../domain/utils/hashing.dart';
import '../model/user.dart';

abstract class AuthRepository {
  Future<void> createAccount(String password, String email, String username);

  Future<User> login(email, password);
}

class AuthRepositoryImp extends AuthRepository {
  final Uuid uuid;
  final Hashing hash;

  final GoogleSheets googleSheets;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImp(
      this.uuid, this.hash, this.googleSheets, this.sharedPreferences);

  insertUserToPref(user) async {
    await sharedPreferences.setString("username", user.username);
    await sharedPreferences.setString("email", user.email);
    await sharedPreferences.setString("id", user.id);
    await sharedPreferences.setBool("isLoggedIn", true);
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
      insertUserToPref(insertedUser);
    }
  }

  @override
  Future<User> login(email, password) async {
    var user = await googleSheets.getUser(email);
    if (hash.verify(password, user.hashedPassword)) {
      insertUserToPref(user);
      return user;
    } else {
      return Future.error("Wrong password");
    }
  }
}
