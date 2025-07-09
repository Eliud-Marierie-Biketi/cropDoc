import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crop_doc/app.dart';
import 'package:crop_doc/core/database/app_database.dart';
import 'package:crop_doc/core/services/connectivity_sync_listener.dart';
// ignore: unused_import
import 'package:crop_doc/shared/providers/global_providers.dart';
import 'package:crop_doc/shared/router/app_router.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();

  // Trigger sync if internet is available at launch
  final hasInternet = await isConnectedToInternet();
  if (hasInternet) {
    await trySyncWithBackend(db);
  }

  // ✅ Start listening to connectivity changes
  listenForConnectivity(db);

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // ✅ You don't need to override userServiceProvider since it's not dynamic
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          return CropDocApp(router: router);
        },
      ),
    ),
  );
}
