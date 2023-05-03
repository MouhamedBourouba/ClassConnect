import 'dart:convert';

import 'package:hive/hive.dart';

part 'class.g.dart';

@HiveType(typeId: 2)
class Class {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<String> teachers;
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
        "teachers": jsonEncode(teachers),
        "streamMessagesId": streamMessagesId,
        "studentsIds": jsonEncode(studentsIds),
        "homeWorkId": homeWorkId,
        "bannedStudents": jsonEncode(bannedStudents),
        "className": className,
        "subject": subject  ,
      };

  Class({
    required this.id,
    required this.teachers,
    required this.streamMessagesId,
    required this.studentsIds,
    required this.homeWorkId,
    required this.bannedStudents,
    required this.className,
    required this.subject,
  });
}
