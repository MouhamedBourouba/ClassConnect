import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  User({
    required this.id,
    required this.fullName,
    required this.password,
    required this.email,
    required this.phoneNumber,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  String fullName;
  @HiveField(2)
  final String password;
  @HiveField(3)
  String email;
  @HiveField(4)
  String phoneNumber;

  User.defaultUser()
      : id = "",
        fullName = "",
        password = "",
        phoneNumber = "",
        email = "";

  Map<String, String> toMap() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      };
}
