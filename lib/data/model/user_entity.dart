import 'package:hive/hive.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 0)
class UserEntity extends HiveObject {
  UserEntity({
    required this.row,
    this.lastName,
    this.firstName,
    this.grade,
    this.parentPhone,
    required this.username,
    required this.email,
    required this.id,
  });

  @HiveField(0, defaultValue: "")
  String id;

  @HiveField(1, defaultValue: 0)
  int row;

  @HiveField(2, defaultValue: null)
  String? firstName;

  @HiveField(3, defaultValue: null)
  String? lastName;

  @HiveField(4, defaultValue: "")
  String email;

  @HiveField(5, defaultValue: null)
  int? grade;

  @HiveField(6, defaultValue: "")
  String username;

  @HiveField(7, defaultValue: null)
  String? parentPhone;
}
