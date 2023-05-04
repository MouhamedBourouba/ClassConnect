// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEventAdapter extends TypeAdapter<UserEvent> {
  @override
  final int typeId = 3;

  @override
  UserEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEvent(
      seen: fields[4] as bool,
      eventType: fields[0] as EventType,
      eventReceiverId: fields[1] as String,
      eventSenderId: fields[2] as String,
      encodedContent: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserEvent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.eventType)
      ..writeByte(1)
      ..write(obj.eventReceiverId)
      ..writeByte(2)
      ..write(obj.eventSenderId)
      ..writeByte(3)
      ..write(obj.encodedContent)
      ..writeByte(4)
      ..write(obj.seen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 4;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.classMemberShipInvitation;
      case 1:
        return EventType.classMemberShipAccepted;
      default:
        return EventType.classMemberShipInvitation;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.classMemberShipInvitation:
        writer.writeByte(0);
        break;
      case EventType.classMemberShipAccepted:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
