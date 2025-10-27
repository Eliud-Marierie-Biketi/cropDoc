// lib/core/state/hive_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class HiveStateNotifier<T> extends StateNotifier<List<T>> {
  final Box<T> box;

  HiveStateNotifier(this.box) : super(box.values.toList());

  /// Add a single item (sync)
  void addItem(T item) {
    box.add(item);
    state = box.values.toList();
  }

  /// Add a batch of items (async-friendly)
  Future<void> addItems(List<T> items) async {
    // Box.addAll can be synchronous, but keep async for consistency
    box.addAll(items);
    state = box.values.toList();
  }

  /// Update item at a given index
  void updateItem(int index, T item) {
    box.putAt(index, item);
    state = box.values.toList();
  }

  /// Async-safe alias for update
  Future<void> putAtIndex(int index, T item) async {
    box.putAt(index, item);
    state = box.values.toList();
  }

  /// Delete item at index
  void deleteItem(int index) {
    box.deleteAt(index);
    state = box.values.toList();
  }

  /// Replace entire box contents with new list (clears then inserts)
  Future<void> replaceAll(List<T> items) async {
    // clear returns Future<int> for Hive so await it
    await box.clear();
    // addAll may be sync; using it is fine
    box.addAll(items);
    state = box.values.toList();
  }

  /// Refresh state from box
  void refresh() {
    state = box.values.toList();
  }
}
