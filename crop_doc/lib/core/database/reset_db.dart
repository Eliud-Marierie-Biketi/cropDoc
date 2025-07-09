import 'package:crop_doc/core/database/app_database.dart';
import 'package:flutter/material.dart';

Future<void> resetAndSeedDatabaseWithMaize(AppDatabase db) async {
  try {
    // Clear all rows
    await db.delete(db.users).go();

    debugPrint('🌱 Database cleared and "Maize" inserted.');
  } catch (e) {
    debugPrint('❌ Failed to reset database: $e');
  }
}
