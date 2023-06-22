import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/class_message.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multiple_result/multiple_result.dart';

final user = User.defaultUser()..fullName = "fdshfd";

final message = ClassMessage(
  id: "dshg",
  streamMessagesId: "gsd",
  senderId: "dhq",
  senderName: "gg seznder",
  sentTimeMS: "df",
  title: "fdsh",
);
final event = UserEvent(
  seen: false,
  eventType: EventType.classMemberShipInvitation,
  eventReceiverId: "dfh",
  eventSenderId: "fdhs",
  id: "hfdfdhs",
);
final ggClass = Class(
  id: "ggh",
  teachers: [],
  streamMessagesId: "dsh",
  studentsIds: ["fdqd", "sdgs"],
  homeWorkId: "sdgq",
  bannedStudents: ["dsg"],
  className: "gg class",
  subject: "fdhfsd",
);

void TestingFun() async {
  final localDB = _LocalDataSource();
  await localDB.init();
  final clouddb = GoogleSheetsCloudDataSource();
  await clouddb.init();
  final datasource = DataBase(localDB, clouddb);

  final o = await isOnline();
  final f = await localDB.getAllObjects<User>();
  final g = await datasource.storeData(event);
  final g1 = await datasource.readObjectById<User>("4882e1e0-ddf0-11ed-9f83-6fb8daa1cc4d");
  final g2 = await datasource.readAllObjects<User>();
  final g4 = await datasource.overwriteObject(
    message,
    oldObjectId: "c8b050e0-0961-11ee-ab38-41bd732d2ffd",
  );
  await localDB.storeObject(g1.tryGetSuccess()!);
  final g3 = await localDB.getAllObjects<User>();
}

enum MDataTable { users, classes, events, messages, emailOtp }

class _LocalDataSource {
  late Box appBox;
  late Box<User> usersBox;
  late Box<Class> classesBox;
  late Box<ClassMessage> classMessagesBox;
  late Box<UserEvent> eventBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ClassAdapter());
    Hive.registerAdapter(ClassMessageAdapter());
    Hive.registerAdapter(EventTypeAdapter());
    Hive.registerAdapter(UserEventAdapter());
    appBox = await Hive.openBox("app_box");
    usersBox = await Hive.openBox("users");
    classesBox = await Hive.openBox("classes");
    classMessagesBox = await Hive.openBox("class_messages");
    eventBox = await Hive.openBox("events");
  }

  Box<T> boxFromType<T>() {
    switch (T) {
      case User:
        return usersBox as Box<T>;
      case Class:
        return classesBox as Box<T>;
      case UserEvent:
        return eventBox as Box<T>;
      case ClassMessage:
        return classMessagesBox as Box<T>;
      default:
        throw UnsupportedError("Unsupported type: $T");
    }
  }

  Future<Iterable<T>> getAllObjects<T>() async {
    assert(T != dynamic);
    return boxFromType<T>().values;
  }

  Future<bool> storeObject<T>(T data) async {
    await boxFromType<T>().put(idFromObject(data), data);
    return true;
  }

  Future<T> getObjectById<T>(String id) async {
    assert(T != dynamic);
    final data = boxFromType<T>().get(id);
    if (data == null) throw Exception("cant find object with id: $id");
    return data;
  }

  Future<void> deleteObject<T>(String id) async {
    assert(T != dynamic);
    await boxFromType<T>().delete(id);
  }

  Future<void> putDataToAppBox(String key, dynamic value) => appBox.put(key, value);
}

class DataBase {
  final _LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;

  MDataTable _dataTableFromType(Type type) {
    if (type == User) {
      return MDataTable.users;
    } else if (type == Class) {
      return MDataTable.classes;
    } else if (type == UserEvent) {
      return MDataTable.events;
    } else if (type == ClassMessage) {
      return MDataTable.messages;
    } else {
      throw UnsupportedError("Unsupported type");
    }
  }

  DataBase(this.localDataSource, this.cloudDataSource);

  Future<Result<Unit, String>> storeData<T>(T data) async {
    if (await isOnline()) {
      final encodeData = encodeObject(data);
      final table = _dataTableFromType(T);
      final success = await cloudDataSource.appendRow(encodeData, table);
      if (success) {
        await localDataSource.storeObject<T>(data);
        return Result.success(unit);
      } else {
        return Result.error(
          MException.unknown().errorMessage,
        );
      }
    }
    return Result.error(
      MException.noInternetConnection().errorMessage,
    );
  }

  Future<Result<Iterable<T>, String>> readAllObjects<T>() async {
    assert(T != dynamic);
    if (await isOnline()) {
      final objectList =
          (await cloudDataSource.getAllRows(_dataTableFromType(T)))?.map((e) => decodeObject<T>(e));
      if (objectList == null) return Result.error("NO DATA FOUND");
      await _storeDataToLocalDB(objectList);
      return Result.success(objectList);
    } else {
      return Result.success(await localDataSource.getAllObjects<T>());
    }
  }

  Future<Result<T, String>> readObjectById<T>(String id) async {
    assert(T != dynamic);
    if (await isOnline()) {
      final objectList = await readAllObjects<T>();
      final wantedObject =
          objectList.tryGetSuccess()!.where((element) => idFromObject(element) == id);
      if (wantedObject.isEmpty) return Result.error("NO DATA FOUND");
      return Result.success(wantedObject.first);
    } else {
      return Result.success(await localDataSource.getObjectById<T>(id));
    }
  }

  Future<Result<Unit, String>> overwriteObject<T>(T newObject, {String? oldObjectId}) async {
    if (await isOnline()) {
      final success = await cloudDataSource.overwriteRow(
        _dataTableFromType(T),
        rowKey: oldObjectId ?? idFromObject(newObject),
        newRow: encodeObject(newObject),
      );
      if (!success) return Result.error(MException.unknown().errorMessage);
      localDataSource.storeObject(newObject);
      return Result.success(unit);
    } else {
      return Result.error(MException.noInternetConnection().errorMessage);
    }
  }

  Future<Result<Unit, String>> deleteObject<T>(String id) async {
    assert(T != dynamic);
    if (await isOnline()) {
      await cloudDataSource.deleteRow(_dataTableFromType(T), rowKey: id);
      await localDataSource.deleteObject<T>(id);
      return Result.success(unit);
    } else {
      return Result.error(MException.noInternetConnection().errorMessage);
    }
  }

  Map<String, String> encodeObject<T>(T data) {
    switch (_dataTableFromType(data.runtimeType)) {
      case MDataTable.users:
        return (data as User).toMap();
      case MDataTable.classes:
        return (data as Class).toMap();
      case MDataTable.events:
        return (data as UserEvent).toMap();
      case MDataTable.messages:
        return (data as ClassMessage).toMap();
      case MDataTable.emailOtp:
        return data as Map<String, String>;
    }
  }

  T decodeObject<T>(Map<String, String> map) {
    switch (_dataTableFromType(T)) {
      case MDataTable.users:
        return map.toUser() as T;
      case MDataTable.classes:
        return map.toClass() as T;
      case MDataTable.events:
        return UserEvent.fromMap(map) as T;
      case MDataTable.messages:
        return ClassMessage.fromMap(map) as T;
      case MDataTable.emailOtp:
        throw UnsupportedError("unsupported type");
    }
  }

  Future<void> _storeDataToLocalDB<T>(Iterable<T> values) async {
    for (final object in values) {
      await localDataSource.storeObject<T>(object);
    }
  }
}
