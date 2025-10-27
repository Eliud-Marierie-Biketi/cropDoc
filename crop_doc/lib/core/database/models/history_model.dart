import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 6)
class HistoryModel extends HiveObject {
  @HiveField(0)
  String imageUrl;

  @HiveField(1)
  String cropName;

  @HiveField(2)
  String disease;

  @HiveField(3)
  double confidence;

  @HiveField(4)
  String? recommendationsJson;

  @HiveField(5)
  DateTime timestamp;

  HistoryModel({
    required this.imageUrl,
    required this.cropName,
    required this.disease,
    required this.confidence,
    this.recommendationsJson,
    required this.timestamp,
  });
}
