import 'package:hive/hive.dart';

part 'class_message.g.dart';

@HiveType(typeId: 5)
class ClassMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String streamMessagesId;
  @HiveField(2)
  final String senderId;
  @HiveField(3)
  final String senderName;
  @HiveField(4)
  final String sentTimeMS;
  @HiveField(5)
  final String title;
  @HiveField(6)
  final String? content;

  ClassMessage({
    required this.id,
    required this.streamMessagesId,
    required this.senderId,
    required this.senderName,
    required this.sentTimeMS,
    required this.title,
    this.content,
  });

  Map<String, String> toMap() => {
        "id": id,
        "streamMessagesId": streamMessagesId,
        "senderId": senderId,
        "senderName": senderName,
        "sentTimeMS": sentTimeMS.toString(),
        "title": title,
        "content": content ?? "",
      };

  ClassMessage.fromMap(Map<String, String> classMessageMap)
      : id = classMessageMap["id"]!,
        senderName = classMessageMap["senderName"]!,
        senderId = classMessageMap["senderId"]!,
        sentTimeMS = classMessageMap["sentTimeMS"]!,
        streamMessagesId = classMessageMap["streamMessagesId"]!,
        content = classMessageMap["content"] ?? "",
        title = classMessageMap["title"]!;
}
