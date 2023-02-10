// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassAdapter extends TypeAdapter<Class> {
  @override
  final int typeId = 3;

  @override
  Class read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Class(
      id: fields[0] as String,
      creatorId: fields[1] as String,
      streamMessagesId: fields[2] as String,
      studentsIds: (fields[3] as List).cast<String>(),
      homeWorkId: fields[4] as String,
      bannedStudents: (fields[5] as List).cast<String>(),
      className: fields[6] as String,
      subject: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Class obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creatorId)
      ..writeByte(2)
      ..write(obj.streamMessagesId)
      ..writeByte(3)
      ..write(obj.studentsIds)
      ..writeByte(4)
      ..write(obj.homeWorkId)
      ..writeByte(5)
      ..write(obj.bannedStudents)
      ..writeByte(6)
      ..write(obj.className)
      ..writeByte(7)
      ..write(obj.subject);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
