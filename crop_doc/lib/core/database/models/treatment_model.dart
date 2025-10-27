import 'package:hive/hive.dart';

part 'treatment_model.g.dart';

@HiveType(typeId: 3)
class TreatmentModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String disease;

  @HiveField(2)
  String treatmentMethod;

  @HiveField(3)
  String additionalInfo;

  @HiveField(4)
  bool isSynced;

  TreatmentModel({
    required this.id,
    required this.disease,
    required this.treatmentMethod,
    required this.additionalInfo,
    this.isSynced = true,
  });
}
