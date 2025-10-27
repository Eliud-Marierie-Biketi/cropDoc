import 'package:hive/hive.dart';

part 'user_stats_model.g.dart';

@HiveType(typeId: 4)
class UserStatsModel extends HiveObject {
  @HiveField(0)
  String country;

  @HiveField(1)
  int totalByCountry;

  @HiveField(2)
  String county;

  @HiveField(3)
  int totalByCounty;

  @HiveField(4)
  bool isSynced;

  UserStatsModel({
    required this.country,
    required this.totalByCountry,
    required this.county,
    required this.totalByCounty,
    this.isSynced = true,
  });
}
