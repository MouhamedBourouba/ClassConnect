import 'package:gsheets/gsheets.dart';
import 'package:school_app/domain/extension.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';

abstract class UserDataSource {
  Future<void> appendUser(User user);

  Future<User> findUserByEmail(String value);

  Future<bool> updateUser(String userId, String columnKey, String value);

  Future<User?> fetchUserById(String id);
}

class GoogleSheetsUserDataSource extends UserDataSource {
  final Worksheet usersWorkSheet;

  GoogleSheetsUserDataSource(this.usersWorkSheet);

  @override
  Future<void> appendUser(User user) async {
    try {
      final userInDB = await usersWorkSheet.cells.findByValue(user.email);
      if (userInDB.isNotEmpty) {
        return Future.error("user already exist, login");
      }
      final userFromDB = user.toMap();
      if (userFromDB == null) {
        throw UnknownException();
      }
      final appendTask = await usersWorkSheet.values.map.appendRow(userFromDB);
      if (appendTask) {
        throw UnknownException();
      }
      return;
    } on Exception {
      throw UnknownException();
    }
  }

  @override
  Future<User> findUserByEmail(String value) async {
    try {
      final userCellLocation = await usersWorkSheet.cells.findByValue(value);

      if (userCellLocation.isEmpty) {
        return Future.error("user dose not exist, did try registering");
      }

      final userJson = await usersWorkSheet.values.map.row(userCellLocation.first.row);

      if (userJson.isNotEmpty) {
        return userJson.toUser();
      } else {
        return Future.error("unknown error please try again later");
      }
    } on Exception {
      throw UnknownException();
    }
  }

  @override
  Future<bool> updateUser(String userId, String columnKey, String value) async {
    try {
      return usersWorkSheet.values.insertValueByKeys(value, columnKey: columnKey, rowKey: userId);
    } on Exception {
      throw UnknownException();
    }
  }

  @override
  Future<User?> fetchUserById(String id) async {
    try {
      final userMap = await usersWorkSheet.values.map.rowByKey(id);
      if (userMap == null) {
        throw Future.error("user dose not exist!");
      }
      return userMap.toUser();
    } on Exception {
      throw UnknownException();
    }
  }
}
