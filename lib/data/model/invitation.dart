import 'package:ClassConnect/data/repository/classes_data_source.dart';

class Invitation {
  final String senderId;
  final String receiverId;
  final String classId;
  final Role role;

  Invitation({
    required this.senderId,
    required this.receiverId,
    required this.classId,
    required this.role,
  });

  Map<String, String> toMap() => {
        "senderId": senderId,
        "receiverId": receiverId,
        "classId": classId,
        "role": role.toString(),
      };
}
