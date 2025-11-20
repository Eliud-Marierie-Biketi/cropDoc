import 'package:crop_doc/core/database/models/history_model.dart';
import 'package:crop_doc/core/providers/model_providers.dart';
import 'package:crop_doc/core/state/hive_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class HistoryRefreshNotifier extends StateNotifier<bool> {
  static bool shouldRefresh = false;

  final HiveStateNotifier<HistoryModel> _historyNotifier;
  final Box<HistoryModel> _box;

  HistoryRefreshNotifier(this._historyNotifier, this._box) : super(false);

  Future<void> saveHistory({
    required String imageUrl,
    required String cropName,
    required String disease,
    required double confidence,
    List<dynamic>? recommendations,
    required String date,
  }) async {
    final historyEntry = HistoryModel(
      imageUrl: imageUrl,
      cropName: cropName,
      disease: disease,
      confidence: confidence,
      recommendations: recommendations ?? [],
      timestamp: DateTime.parse(date),
    );

    await _box.add(historyEntry);

    if (_box.length > 10) {
      final sorted = _box.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final toKeep = sorted.take(10).toList();
      await _box.clear();
      for (final item in toKeep) {
        await _box.add(item);
      }
    }

    _historyNotifier.refresh();
    shouldRefresh = true;
    state = !state;
  }
}

final historyRefreshProvider =
    StateNotifierProvider<HistoryRefreshNotifier, bool>((ref) {
      final historyNotifier = ref.watch(historyProvider.notifier);
      final historyBox = ref.watch(historyBoxProvider);
      return HistoryRefreshNotifier(historyNotifier, historyBox);
    });
