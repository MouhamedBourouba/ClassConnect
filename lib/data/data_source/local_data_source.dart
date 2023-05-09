import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class LocalDataSource {
  Future<void> putDataToAppBox(String key, dynamic value);

  //returns user index
  Future<int> addUserToUsersBox(User user);

  List<User> getUsers();

  User? getCurrentUser();

  Future<void> addClass(Class class_);

  Future<void> addEvent(UserEvent userEvent);

  ValueListenable<Box<Class>> getClassesValueListener();

  Future<void> updateCurrentUser({
    String fullName,
    String email,
    String phoneNumber,
  });

  List<Class> getClasses();

  Future<void> clearAllData();

  void setValueToAppBox(String key, dynamic value);

  dynamic getValueFromAppBox(String key, {dynamic defaultValue});

  Stream<BoxEvent> getCurrentUserUpdates();

  List<UserEvent> getEvents();

  void removeEvent(String eventId);
}

@Singleton(as: LocalDataSource)
class HiveLocalDataBase implements LocalDataSource {
  late Box appBox;
  late Box<User> usersBox;
  late Box<Class> classesBox;
  late Box<UserEvent> eventBox;
  final User? currentUser = null;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ClassAdapter());
    Hive.registerAdapter(EventTypeAdapter());
    Hive.registerAdapter(UserEventAdapter());
    appBox = await Hive.openBox("app_box");
    usersBox = await Hive.openBox("users");
    classesBox = await Hive.openBox("classes");
    eventBox = await Hive.openBox("events");
  }

  @override
  dynamic getValueFromAppBox(String key, {dynamic defaultValue}) => appBox.get(key, defaultValue: defaultValue);

  @override
  void setValueToAppBox(String key, dynamic value) => appBox.put(key, value);

  @override
  User? getCurrentUser() => appBox.get("current_user") as User?;

  @override
  Future<void> putDataToAppBox(String key, dynamic value) => appBox.put(key, value);

  @override
  Future<int> addUserToUsersBox(User user) => usersBox.add(user);

  @override
  List<User> getUsers() => usersBox.toMap().values.toList();

  @override
  Future<void> addClass(Class class_) => classesBox.add(class_);

  @override
  List<Class> getClasses() => classesBox.values.toList();

  @override
  Future<void> updateCurrentUser({
    String? fullName,
    String? email,
    String? phoneNumber,
  }) {
    final currentUser = getCurrentUser()!;
    currentUser
      ..fullName = fullName ?? currentUser.fullName
      ..email = email ?? currentUser.email
      ..phoneNumber = phoneNumber ?? currentUser.phoneNumber;
    return appBox.put("current_user", currentUser);
  }

  @override
  ValueListenable<Box<Class>> getClassesValueListener() => classesBox.listenable();

  @override
  Stream<BoxEvent> getCurrentUserUpdates() => appBox.watch();

  @override
  Future<void> clearAllData() async {
    await appBox.clear();
    await classesBox.clear();
    await usersBox.clear();
  }

  @override
  Future<void> addEvent(UserEvent userEvent) => eventBox.add(userEvent);

  @override
  List<UserEvent> getEvents() => eventBox.toMap().values.toList();

  @override
  Future<void> removeEvent(String eventId) async {
    final updatedList = List<UserEvent>.from(eventBox.values)..removeWhere((element) => element.id == eventId);
    await eventBox.clear();
    await eventBox.putAll(Map.fromIterable(updatedList));

  }
}
