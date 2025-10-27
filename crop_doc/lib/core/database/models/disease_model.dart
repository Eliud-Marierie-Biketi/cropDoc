import 'package:hive/hive.dart';

part 'disease_model.g.dart';

@HiveType(typeId: 2)
class DiseaseModel extends HiveObject {
  @HiveField(0)
  int diseaseId;

  @HiveField(1)
  String diseaseName;

  @HiveField(2)
  String crop;

  @HiveField(3)
  String description;

  @HiveField(4)
  bool isSynced;

  DiseaseModel({
    required this.diseaseId,
    required this.diseaseName,
    required this.crop,
    required this.description,
    this.isSynced = true,
  });
}
