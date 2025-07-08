import 'package:crop_doc/core/database/app_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Assumes your AppDatabase is already provided via Provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(); // Override this in your main.dart
});

final userProvider = FutureProvider<User?>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return await db.getFirstUser();
});
