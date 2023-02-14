import 'package:hive/hive.dart';

part 'class.g.dart';

@HiveType(typeId: 3)
class Class {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String creatorId;
  @HiveField(2)
  final String streamMessagesId;
  @HiveField(3)
  final List<String> studentsIds;
  @HiveField(4)
  final String homeWorkId;
  @HiveField(5)
  final List<String> bannedStudents;
  @HiveField(6)
  final String className;
  @HiveField(7)
  final String subject;

  Map<String, String> toMap() => {
        "id": id,
        "creatorId": creatorId,
        "streamMessagesId": streamMessagesId,
        "studentsIds": studentsIds.toString(),
        "homeWorkId": homeWorkId,
        "bannedStudents": bannedStudents.toString(),
        "className": className,
        "subject": subject  ,
      };

  Class({
    required this.id,
    required this.creatorId,
    required this.streamMessagesId,
    required this.studentsIds,
    required this.homeWorkId,
    required this.bannedStudents,
    required this.className,
    required this.subject,
  });
}
