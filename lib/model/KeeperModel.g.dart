// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KeeperModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KeeperModelAdapter extends TypeAdapter<KeeperModel> {
  @override
  final int typeId = 0;

  @override
  KeeperModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeeperModel()
      ..noteDelta = fields[0] as String
      ..dayMonthYear = fields[1] as String
      ..createdAt = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, KeeperModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.noteDelta)
      ..writeByte(1)
      ..write(obj.dayMonthYear)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeeperModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
