// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiseaseModelAdapter extends TypeAdapter<DiseaseModel> {
  @override
  final int typeId = 2;

  @override
  DiseaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiseaseModel(
      diseaseId: fields[0] as int,
      diseaseName: fields[1] as String,
      crop: fields[2] as String,
      description: fields[3] as String,
      isSynced: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DiseaseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.diseaseId)
      ..writeByte(1)
      ..write(obj.diseaseName)
      ..writeByte(2)
      ..write(obj.crop)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiseaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
