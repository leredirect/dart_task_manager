// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagsAdapter extends TypeAdapter<Tags> {
  @override
  final int typeId = 1;

  @override
  Tags read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Tags.DART;
      case 1:
        return Tags.FLUTTER;
      case 2:
        return Tags.ALGORITHMS;
      case 3:
        return Tags.CLEAR;
      case 4:
        return Tags.EXPIRED;
      default:
        return Tags.DART;
    }
  }

  @override
  void write(BinaryWriter writer, Tags obj) {
    switch (obj) {
      case Tags.DART:
        writer.writeByte(0);
        break;
      case Tags.FLUTTER:
        writer.writeByte(1);
        break;
      case Tags.ALGORITHMS:
        writer.writeByte(2);
        break;
      case Tags.CLEAR:
        writer.writeByte(3);
        break;
      case Tags.EXPIRED:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrioritiesAdapter extends TypeAdapter<Priorities> {
  @override
  final int typeId = 2;

  @override
  Priorities read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priorities.HIGH;
      case 1:
        return Priorities.MEDIUM;
      case 2:
        return Priorities.LOW;
      default:
        return Priorities.HIGH;
    }
  }

  @override
  void write(BinaryWriter writer, Priorities obj) {
    switch (obj) {
      case Priorities.HIGH:
        writer.writeByte(0);
        break;
      case Priorities.MEDIUM:
        writer.writeByte(1);
        break;
      case Priorities.LOW:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrioritiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List)?.cast<Tags>(),
      fields[7] as User,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
      fields[6] as Priorities,
      fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.tags)
      ..writeByte(3)
      ..write(obj.taskCreateTime)
      ..writeByte(4)
      ..write(obj.taskDeadline)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.creator)
      ..writeByte(8)
      ..write(obj.isPushed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
