// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassMessageAdapter extends TypeAdapter<ClassMessage> {
  @override
  final int typeId = 5;

  @override
  ClassMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassMessage(
      id: fields[0] as String,
      streamMessagesId: fields[1] as String,
      senderId: fields[2] as String,
      senderName: fields[3] as String,
      sentTimeMS: fields[4] as String,
      title: fields[5] as String,
      content: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassMessage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.streamMessagesId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.senderName)
      ..writeByte(4)
      ..write(obj.sentTimeMS)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
