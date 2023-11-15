// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationCacheModelAdapter
    extends TypeAdapter<NotificationCacheModel> {
  @override
  final int typeId = 0;

  @override
  NotificationCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationCacheModel(
      uuid: fields[0] as String,
      notification: fields[1] as NotificationModel,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.notification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
