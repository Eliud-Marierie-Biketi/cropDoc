import 'package:crop_doc/core/state/hive_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../services/sync_service.dart';
import 'package:crop_doc/core/database/models/user_model.dart';
import 'package:crop_doc/core/database/models/crop_model.dart';
import 'package:crop_doc/core/database/models/disease_model.dart';
import 'package:crop_doc/core/database/models/treatment_model.dart';
import 'package:crop_doc/core/database/models/user_stats_model.dart';
import 'package:crop_doc/core/database/models/history_model.dart';

// ----------------------
// HIVE BOX PROVIDERS
// ----------------------

final userBoxProvider = Provider<Box<UserModel>>(
  (ref) => Hive.box<UserModel>('users'),
);

final cropBoxProvider = Provider<Box<CropModel>>(
  (ref) => Hive.box<CropModel>('crops'),
);

final diseaseBoxProvider = Provider<Box<DiseaseModel>>(
  (ref) => Hive.box<DiseaseModel>('diseases'),
);

final treatmentBoxProvider = Provider<Box<TreatmentModel>>(
  (ref) => Hive.box<TreatmentModel>('treatments'),
);

final userStatsBoxProvider = Provider<Box<UserStatsModel>>(
  (ref) => Hive.box<UserStatsModel>('userStats'),
);

final historyBoxProvider = Provider<Box<HistoryModel>>(
  (ref) => Hive.box<HistoryModel>('history'),
);

// ----------------------
// STATE NOTIFIERS
// ----------------------

final userProvider =
    StateNotifierProvider<HiveStateNotifier<UserModel>, List<UserModel>>(
      (ref) => HiveStateNotifier(ref.watch(userBoxProvider)),
    );

final cropProvider =
    StateNotifierProvider<HiveStateNotifier<CropModel>, List<CropModel>>(
      (ref) => HiveStateNotifier(ref.watch(cropBoxProvider)),
    );

final historyProvider =
    StateNotifierProvider<HiveStateNotifier<HistoryModel>, List<HistoryModel>>(
      (ref) => HiveStateNotifier(ref.watch(historyBoxProvider)),
    );

final treatmentsProvider =
    StateNotifierProvider<
      HiveStateNotifier<TreatmentModel>,
      List<TreatmentModel>
    >((ref) => HiveStateNotifier(ref.watch(treatmentBoxProvider)));

final userStatsProvider =
    StateNotifierProvider<
      HiveStateNotifier<UserStatsModel>,
      List<UserStatsModel>
    >((ref) => HiveStateNotifier(ref.watch(userStatsBoxProvider)));

// ----------------------
// SYNC SERVICE
// ----------------------

final syncServiceProvider = Provider(
  (ref) => SyncService('http://127.0.0.1:8000'),
);
