// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CropModelAdapter extends TypeAdapter<CropModel> {
  @override
  final int typeId = 1;

  @override
  CropModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CropModel(
      id: fields[0] as int,
      cropname: fields[1] as String,
      description: fields[2] as String,
      isSynced: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CropModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cropname)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
