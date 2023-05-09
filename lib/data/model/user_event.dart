import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_event.g.dart';

@HiveType(typeId: 4)
enum EventType {
  @HiveField(0)
  classMemberShipInvitation,
  @HiveField(1)
  classMemberShipAccepted,
}

class ClassInvitationEventData {
  final Role role;
  final String senderName;
  final String classId;
  final String className;

  Map<String, String> toMap() => {"role": _encodeRole(role).toString(), "senderName": senderName, "classId": classId, "className": className};

  ClassInvitationEventData({required this.role, required this.senderName, required this.classId, required this.className});

  ClassInvitationEventData.fromMap(Map<String, String> classInvitationMap)
      : role = _decodeRole(int.parse(classInvitationMap["role"]!)),
        classId = classInvitationMap["classId"]!,
        senderName = classInvitationMap["senderName"]!,
        className = classInvitationMap["className"]!;

  int _encodeRole(Role role) {
    switch (role) {
      case Role.classMate:
        return 0;
      case Role.teacher:
        return 1;
    }
  }

  static Role _decodeRole(int role) {
    switch (role) {
      case 0:
        return Role.classMate;
      case 1:
        return Role.teacher;
      default:
        return Role.classMate;
    }
  }
}

@HiveType(typeId: 3)
class UserEvent {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final EventType eventType;
  @HiveField(2)
  final String eventReceiverId;
  @HiveField(3)
  final String eventSenderId;
  @HiveField(4)
  final String? encodedContent;
  @HiveField(5)
  final bool seen;

  Map<String, String> toMap() => {
        "eventType": _encodeEventType(),
        "eventReceiverId": eventReceiverId,
        "eventSenderId": eventSenderId,
        "encodedContent": encodedContent ?? "",
        "seen": seen.toString(),
        "id": id,
      };

  UserEvent({required this.seen, required this.eventType, required this.eventReceiverId, required this.eventSenderId, this.encodedContent, required this.id});

  UserEvent.fromMap(Map<String, String> userEventJson)
      : seen = userEventJson["seen"] == "true",
        id = userEventJson["id"].toString(),
        eventType = decodeEventType(userEventJson["eventType"].toString()),
        eventReceiverId = userEventJson["eventReceiverId"].toString(),
        encodedContent = userEventJson["encodedContent"],
        eventSenderId = userEventJson["eventSenderId"].toString();

  String _encodeEventType() {
    switch (eventType) {
      case EventType.classMemberShipInvitation:
        return "0";
      case EventType.classMemberShipAccepted:
        return "1";
    }
  }

  static EventType decodeEventType(String eventType) {
    switch (eventType) {
      case "0":
        return EventType.classMemberShipInvitation;
      case "1":
        return EventType.classMemberShipAccepted;
      default:
        return EventType.classMemberShipAccepted;
    }
  }
}
