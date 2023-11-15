// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseModelAdapter extends TypeAdapter<BaseModel> {
  @override
  final int typeId = 2;

  @override
  BaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseModel(
      raporverileri: (fields[0] as List?)?.cast<Raporverileri>(),
    );
  }

  @override
  void write(BinaryWriter writer, BaseModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.raporverileri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RaporverileriAdapter extends TypeAdapter<Raporverileri> {
  @override
  final int typeId = 3;

  @override
  Raporverileri read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Raporverileri(
      kararanabaslik: fields[0] as Kararanabaslik?,
      kararbaslik: fields[1] as Kararbaslik?,
      karartarih: fields[2] as Karartarih?,
      kararno: fields[3] as Karartarih?,
      esasno: fields[4] as Karartarih?,
      karardosyayolu: fields[5] as Karartarih?,
      karardosya: fields[6] as Karardosya?,
    );
  }

  @override
  void write(BinaryWriter writer, Raporverileri obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.kararanabaslik)
      ..writeByte(1)
      ..write(obj.kararbaslik)
      ..writeByte(2)
      ..write(obj.karartarih)
      ..writeByte(3)
      ..write(obj.kararno)
      ..writeByte(4)
      ..write(obj.esasno)
      ..writeByte(5)
      ..write(obj.karardosyayolu)
      ..writeByte(6)
      ..write(obj.karardosya);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RaporverileriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KararanabaslikAdapter extends TypeAdapter<Kararanabaslik> {
  @override
  final int typeId = 4;

  @override
  Kararanabaslik read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Kararanabaslik(
      label: fields[0] as String?,
      veri: fields[1] as String?,
      deger: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Kararanabaslik obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.veri)
      ..writeByte(2)
      ..write(obj.deger);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KararanabaslikAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KararbaslikAdapter extends TypeAdapter<Kararbaslik> {
  @override
  final int typeId = 5;

  @override
  Kararbaslik read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Kararbaslik(
      label: fields[0] as String?,
      listedegoster: fields[1] as bool?,
      veri: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Kararbaslik obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.listedegoster)
      ..writeByte(2)
      ..write(obj.veri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KararbaslikAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KarartarihAdapter extends TypeAdapter<Karartarih> {
  @override
  final int typeId = 6;

  @override
  Karartarih read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Karartarih(
      label: fields[0] as String?,
      veri: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Karartarih obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.veri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KarartarihAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KarardosyaAdapter extends TypeAdapter<Karardosya> {
  @override
  final int typeId = 7;

  @override
  Karardosya read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Karardosya(
      label: fields[0] as String?,
      veri: fields[1] as String?,
      url: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Karardosya obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.veri)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KarardosyaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
