// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreatmentModelAdapter extends TypeAdapter<TreatmentModel> {
  @override
  final int typeId = 3;

  @override
  TreatmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreatmentModel(
      id: fields[0] as int,
      disease: fields[1] as String,
      treatmentMethod: fields[2] as String,
      additionalInfo: fields[3] as String,
      isSynced: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TreatmentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.disease)
      ..writeByte(2)
      ..write(obj.treatmentMethod)
      ..writeByte(3)
      ..write(obj.additionalInfo)
      ..writeByte(4)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreatmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
