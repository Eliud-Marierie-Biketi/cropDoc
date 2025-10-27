import 'package:crop_doc/core/database/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crop_doc/core/database/models/crop_model.dart';
import 'package:crop_doc/core/database/models/disease_model.dart';
import 'package:crop_doc/core/database/models/treatment_model.dart';
import 'package:crop_doc/core/database/models/user_stats_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CropModelAdapter());
  Hive.registerAdapter(DiseaseModelAdapter());
  Hive.registerAdapter(TreatmentModelAdapter());
  Hive.registerAdapter(UserStatsModelAdapter());

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<CropModel>('crops');
  await Hive.openBox<DiseaseModel>('diseases');
  await Hive.openBox<TreatmentModel>('treatments');
  await Hive.openBox<UserStatsModel>('userStats');
}
