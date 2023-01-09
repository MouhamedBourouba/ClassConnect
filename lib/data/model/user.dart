import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    this.firstName,
    this.lastName,
    this.grade,
    this.parentPhone,
    this.classes,
    this.teachingClasses
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String password;
  @HiveField(3)
  String email;
  @HiveField(4)
  String? firstName;
  @HiveField(5)
  String? lastName;
  @HiveField(6)
  int? grade;
  @HiveField(7)
  String? parentPhone;
  @HiveField(8)
  List<String>? classes;
  @HiveField(9)
  List<String>? teachingClasses;

  User.defaultUser()
      : id = "",
        username = "",
        password = "",
        email = "";

  List<dynamic> toList() => [id, username, email, password, grade, parentPhone, firstName, lastName, classes];

  Map<String, dynamic>? toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "hashedPassword": password,
        "grade": grade,
        "parentPhone": parentPhone,
        "firstName": firstName,
        "lastName": lastName,
        "teachingClasses": teachingClasses,
        "classes": classes
      };
}
