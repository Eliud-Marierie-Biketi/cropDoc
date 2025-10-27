import 'dart:async';
import 'package:crop_doc/core/providers/model_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:crop_doc/core/database/models/user_model.dart';
import 'package:crop_doc/core/database/models/crop_model.dart';
import 'package:crop_doc/core/database/models/disease_model.dart';
import 'package:crop_doc/core/database/models/treatment_model.dart';
import '../services/sync_service.dart';

final autoSyncProvider = Provider<AutoSyncService>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return AutoSyncService(syncService);
});

class AutoSyncService {
  final SyncService syncService;
  Timer? _timer;

  AutoSyncService(this.syncService);

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 15), (_) async {
      await _runSync();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _runSync() async {
    final online = await syncService.checkOnline();
    if (!online) return;

    await _syncBox<UserModel>('users', syncService.syncUser);
    await _syncBox<CropModel>('crops', syncService.syncCrop);
    await _syncBox<DiseaseModel>('diseases', syncService.syncDisease);
    await _syncBox<TreatmentModel>('treatments', syncService.syncTreatment);
  }

  Future<void> _syncBox<T>(
    String boxName,
    Future<bool> Function(T) syncFn,
  ) async {
    final box = Hive.box<T>(boxName);
    final unsynced = box.values.where((e) {
      final dynamic d = e;
      return d.isSynced == false;
    }).toList();

    for (var item in unsynced) {
      try {
        final ok = await syncFn(item);
        if (ok) {
          final index = box.values.toList().indexOf(item);
          if (index != -1) {
            final dynamic d = item;
            d.isSynced = true;
            await box.putAt(index, d);
          }
        }
      } catch (e) {
        // swallow errors — next cycle will retry
      }
    }
  }
}
