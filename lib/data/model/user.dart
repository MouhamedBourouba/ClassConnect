import 'dart:convert';

import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User {
  User({
    required this.id,
    required this.fullName,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.classes,
    required this.teachingClasses,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String fullName;
  @HiveField(2)
  String password;
  @HiveField(3)
  String email;
  @HiveField(4)
  String phoneNumber;
  @HiveField(5)
  List<String> classes;
  @HiveField(6)
  List<String> teachingClasses;

  User.defaultUser()
      : id = "",
        fullName = "",
        password = "",
        phoneNumber = "",
        email = "",
        classes = [],
        teachingClasses = [];

  Map<String, dynamic> toMap() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "hashedPassword": password,
        "phoneNumber": phoneNumber,
        "teachingClasses": jsonEncode(teachingClasses),
        "classes": jsonEncode(classes)
      };
}
