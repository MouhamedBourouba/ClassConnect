import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user.dart';
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

  ValueListenable<Box<Class>> getClassesValueListener();

  Future<void> updateCurrentUser({
    String username,
    String firstName,
    String lastName,
    String email,
    String grade,
    String parentPhone,
    List<String> classes,
    List<String> teachingClasses,
  });

  List<Class> getClasses();

  void setValueToAppBox(String key, dynamic value);

  dynamic getValueFromAppBox(String key, {dynamic defaultValue});
  Stream<BoxEvent> getCurrentUserUpdates();
}

@Singleton(as: LocalDataSource)
class HiveLocalDataBase implements LocalDataSource {
  late Box appBox;
  late Box<User> usersBox;
  late Box<Class> classesBox;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ClassAdapter());
    appBox = await Hive.openBox("app_box");
    usersBox = await Hive.openBox("users");
    classesBox = await Hive.openBox("classes");
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
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? grade,
    String? parentPhone,
    List<String>? classes,
    List<String>? teachingClasses,
  }) {
    final currentUser = getCurrentUser()!;
    currentUser
      ..username = username ?? currentUser.username
      ..firstName = firstName ?? currentUser.firstName
      ..lastName = lastName ?? currentUser.lastName
      ..email = email ?? currentUser.email
      ..grade = grade ?? currentUser.grade
      ..parentPhone = parentPhone ?? currentUser.parentPhone
      ..classes = classes ?? currentUser.classes
      ..teachingClasses = teachingClasses ?? currentUser.teachingClasses;
    return appBox.put("current_user", currentUser);
  }

  @override
  ValueListenable<Box<Class>> getClassesValueListener() => classesBox.listenable();

  @override
  Stream<BoxEvent> getCurrentUserUpdates() => appBox.watch();
}