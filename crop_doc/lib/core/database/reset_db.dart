import 'package:crop_doc/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

Future<void> resetAndSeedDatabaseWithMaize(AppDatabase db) async {
  try {
    // Clear all rows
    await db.delete(db.users).go();
    await db.delete(db.cropDiseases).go();
    await db.delete(db.diseaseTreatments).go();
    await db.delete(db.crops).go();

    // Insert "Maize"
    await db.insertCrop(CropsCompanion(name: const Value('Maize')));

    debugPrint('🌱 Database cleared and "Maize" inserted.');
  } catch (e) {
    debugPrint('❌ Failed to reset database: $e');
  }
}
