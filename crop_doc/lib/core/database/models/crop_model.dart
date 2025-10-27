import 'package:hive/hive.dart';

part 'crop_model.g.dart';

@HiveType(typeId: 1)
class CropModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String cropname;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isSynced;

  CropModel({
    required this.id,
    required this.cropname,
    required this.description,
    this.isSynced = true,
  });
}
