import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/class_message.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:hive_flutter/hive_flutter.dart';

final user = User.defaultUser();

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
  final localDB = LocalDataSource();
  await localDB.init();
  print((await localDB.getAllObjects<Class>()).length);
  print((await localDB.getObjectById<Class>("gg")).className);
}

enum MDataTable {
  users,
  classes,
  events,
  messages,
}

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

class LocalDataSource {
  late Box appBox;
  late Box<User> usersBox;
  late Box<Class> classesBox;
  late Box<ClassMessage> classMessagesBox;
  late Box<UserEvent> eventBox;
  final User? currentUser = null;

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

  Box<T> boxFromType<T>(Type type) {
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
    return boxFromType<T>(T).values;
  }

  Future<bool> storeObject<T extends Object>(T data) async {
    await boxFromType<T>(T).put(idFromObject(data), data);
    return true;
  }

  Future<T> getObjectById<T extends Object>(String id) async {
    final data = (await getAllObjects<T>()).where((element) => idFromObject(element) == id);
    if (data.isEmpty) throw Exception("cant find object with id: $id");
    return data.first;
  }

  Future<void> putDataToAppBox(String key, dynamic value) => appBox.put(key, value);
}
