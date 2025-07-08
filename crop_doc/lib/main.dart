// lib/main.dart
// ignore: unused_import
import 'package:crop_doc/core/database/reset_db.dart';
import 'package:crop_doc/shared/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'app.dart';

/// Provide the singleton database instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  // await resetAndSeedDatabaseWithMaize(db);

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          return CropDocApp(router: router);
        },
      ),
    ),
  );
}
