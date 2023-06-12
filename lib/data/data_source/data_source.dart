import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/class_message.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class DataBaseRepository {
  Future<Result<Unit, String>> storeData<T>(Object data);

  Future<Result<List<T>, String>> getObjects<T>();

  Future<Result<T, String>> getObject<T>(String id);
}

class DataBaseImpl implements DataBaseRepository {
  final CloudDataSource cloudDataSource = getIt();
  final LocalDataSource localDataSource = getIt();

  @override
  Future<Result<Unit, String>> storeData<T>(Object data) async {
    if (await isOnline()) {
      await cloudDataSource.appendRow(dataToMap(data), typeToTable<T>());
    } else {
      return Result.error(MException.noInternetConnection().errorMessage);
    }
    if (data is User) {
      localDataSource.addUser(data);
    } else if (data is Class) {
      localDataSource.addClass(data);
    } else if (data is UserEvent) {
      localDataSource.addEvent(data);
    } else if (data is ClassMessage) {
      localDataSource.addClassMessage(data);
    }
    return Result.success(unit);
  }

  @override
  Future<Result<T, String>> getObject<T>(String id) async {
    if (await isOnline()) {
      final dataJson = await cloudDataSource.getRow(typeToTable<T>(), rowKey: id);
      final data = mapToData<T>(dataJson!);
      return Result.success(data);
    } else {
      if (T is User) {
        return Result.success(
          localDataSource.getUsers().where((element) => element.id == id).first as T,
        );
      } else if (T == Class) {
        return Result.success(
          localDataSource.getClasses().where((element) => element.id == id).first as T,
        );
      } else if (T == UserEvent) {
        return Result.success(
          localDataSource.getEvents().where((element) => element.id == id).first as T,
        );
      } else if (T == ClassMessage) {
        return Result.success(
          localDataSource.getClassMessages().where((element) => element.id == id).first as T,
        );
      } else {
        return Result.success(
          localDataSource.getUsers().where((element) => element.id == id).first as T,
        );
      }
    }
  }

  @override
  Future<Result<List<T>, String>> getObjects<T>() async {
    if (await isOnline()) {
      final jsonList = await cloudDataSource.getAllRows(typeToTable<T>());
      final list = jsonList!.map((e) {
        if (T == User) {
          return e.toUser();
        } else if (T == Class) {
          return e.toClass();
        } else if (T == UserEvent) {
          return UserEvent.fromMap(e);
        } else if (T == ClassMessage) {
          return ClassMessage.fromMap(e);
        }
        return e.toClass();
      });
      final castedList = list.map((e) => e as T);
      return Result.success(castedList.toList());
    } else {
      if (T is User) {
        return Result.success(
          localDataSource.getUsers().map((e) => e as T).toList(),
        );
      } else if (T == Class) {
        return Result.success(
          localDataSource.getClasses().map((e) => e as T).toList(),
        );
      } else if (T == UserEvent) {
        return Result.success(
          localDataSource.getEvents().map((e) => e as T).toList(),
        );
      } else if (T == ClassMessage) {
        return Result.success(
          localDataSource.getClassMessages().map((e) => e as T).toList(),
        );
      } else {
        return Result.success(
          localDataSource.getUsers().map((e) => e as T).toList(),
        );
      }
    }
  }

  T mapToData<T>(Map<String, String> map) {
    if (T == User) {
      return map.toUser() as T;
    } else if (T == Class) {
      return map.toClass() as T;
    } else if (T == UserEvent) {
      return UserEvent.fromMap(map) as T;
    } else if (T == ClassMessage) {
      return ClassMessage.fromMap(map) as T;
    } else {
      return "" as T;
    }
  }

  Map<String, dynamic> dataToMap(Object data) {
    if (data is User) {
      return data.toMap();
    } else if (data is Class) {
      return data.toMap();
    } else if (data is UserEvent) {
      return data.toMap();
    } else if (data is ClassMessage) {
      return data.toMap();
    } else {
      return {};
    }
  }

  MTable typeToTable<data>() {
    if (data is User) {
      return MTable.usersTable;
    } else if (data is Class) {
      return MTable.classesTable;
    } else if (data is UserEvent) {
      return MTable.eventsTable;
    } else if (data is ClassMessage) {
      return MTable.streamMessagesTable;
    } else {
      return MTable.usersTable;
    }
  }
}
