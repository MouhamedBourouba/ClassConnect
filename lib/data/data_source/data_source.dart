import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/class_message.dart';
import 'package:ClassConnect/data/model/error.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/model/user_event.dart';
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
  id: "hfds",
);
final ggClass = Class(
  id: "gg",
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
  localDB.storeObject(event);
  print((await localDB.getAllObjects<UserEvent>()).length);
  print((await localDB.getObjectById<Class>("gg")).className);

  final g = await datasource.storeData(ggClass);
  print(g.tryGetError());
}

enum MDataTable { users, classes, events, messages, emailOtp }

MDataTable dataTableFromType(Type type) {
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

String idFromObject(Object data) {
  switch (data.runtimeType) {
    case User:
      return (data as User).id;
    case Class:
      return (data as Class).id;
    case UserEvent:
      return (data as UserEvent).id;
    case ClassMessage:
      return (data as ClassMessage).id;
    default:
      throw UnsupportedError('unsupported Type ${data.runtimeType}');
  }
}

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
    return boxFromType<T>().values;
  }

  Future<bool> storeObject<T extends Object>(T data) async {
    await boxFromType<T>().put(idFromObject(data), data);
    return true;
  }

  Future<T> getObjectById<T extends Object>(String id) async {
    final data = (await getAllObjects<T>()).where((element) => idFromObject(element) == id);
    if (data.isEmpty) throw Exception("cant find object with id: $id");
    return data.first;
  }

  Future<void> deleteObject<T>(String id) async {
    await boxFromType<T>().delete(id);
  }

  Future<void> putDataToAppBox(String key, dynamic value) => appBox.put(key, value);
}

class DataBase {
  final _LocalDataSource localDataSource;
  final CloudDataSource cloudDataSource;

  DataBase(this.localDataSource, this.cloudDataSource);

  Future<Result<Unit, String>> storeData<T extends Object>(T data) async {
    if (await isOnline()) {
      final encodeData = encodeObject(data);
      final table = dataTableFromType(T);
      final success = await cloudDataSource.appendRow(encodeData, table);
      if (success) {
        await localDataSource.storeObject<T>(data);
        return Result.success(unit);
      } else {
        return Result.error(MException.unknown().errorMessage);
      }
    }
    return Result.error(
      MException.noInternetConnection().errorMessage,
    );
  }

  Future<Result<List<T>, String>> readAllObjects<T>() {
    throw UnimplementedError();
  }

  Future<Result<T, String>> readObjectById<T>(String id) {
    throw UnimplementedError();
  }

  Future<Result<Unit, String>> updateObject<T>(String id, T newObject) {
    throw UnimplementedError();
  }

  Future<Result<Unit, String>> deleteObject<T>(String id) {
    throw UnimplementedError();
  }

  Map<String, dynamic> encodeObject(Object data) {
    switch (dataTableFromType(data.runtimeType)) {
      case MDataTable.users:
        return (data as User).toMap();
      case MDataTable.classes:
        return (data as Class).toMap();
      case MDataTable.events:
        return (data as UserEvent).toMap();
      case MDataTable.messages:
        return (data as ClassMessage).toMap();
      case MDataTable.emailOtp:
        return data as Map<String, dynamic>;
    }
  }
}
