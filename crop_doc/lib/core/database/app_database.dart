import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crop_doc/core/services/sync_service.dart';
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ========== TABLE ==========
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get country => text()();
  TextColumn get county => text().nullable()();
  TextColumn get role => text()();
  BoolColumn get consent => boolean()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// ============ TABLE ============
class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagePath => text()();
  TextColumn get cropName => text().withDefault(const Constant(''))();
  TextColumn get disease => text().nullable()();
  TextColumn get confidence => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get recommendationsJson =>
      text().nullable()(); // NEW: store recommendations
}

// ========== DATABASE ==========
@DriftDatabase(tables: [Users, History])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
  );

  // ========== USER OPERATIONS ==========
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<List<User>> getUsers() => select(users).get();

  Future<User?> getFirstUser() async => (await getUsers()).firstOrNull;

  Future<User?> getUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  Future<bool> updateUser(User user) => update(users).replace(user);

  Future<int> deleteUserById(int id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> deleteAllUsers() async => delete(users).go();

  // ========== HISTORY OPERATIONS ==========

  Future<int> insertHistory(HistoryCompanion entry) =>
      into(history).insert(entry);

  Future<List<HistoryData>> getAllHistory() {
    return (select(history)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Future<void> deleteHistoryById(int id) {
    return (delete(history)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteHistory(int id) =>
      (delete(history)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> clearAllHistory() async => await delete(history).go();

  // ========== SYNC HELPERS ==========
  Future<List<User>> getUnsyncedUsers() =>
      (select(users)..where((u) => u.isSynced.equals(false))).get();

  Future<void> markUserAsSynced(int id, String serverId) async {
    final existing = await getUserById(id);
    if (existing != null &&
        (existing.serverId == null || existing.serverId!.isEmpty)) {
      await (update(users)..where((u) => u.id.equals(id))).write(
        UsersCompanion(isSynced: const Value(true), serverId: Value(serverId)),
      );
      if (kDebugMode) {
        print("✅ markUserAsSynced: userId=$id → serverId=$serverId");
      }
    } else {
      await (update(users)..where((u) => u.id.equals(id))).write(
        const UsersCompanion(isSynced: Value(true)),
      );
      if (kDebugMode) {
        print("ℹ️ markUserAsSynced: user already has serverId");
      }
    }
  }

  Future<void> deleteAllData() async {
    await batch((batch) {
      batch.deleteAll(users);
    });
  }
}

// ========== SINGLETON DATABASE ==========
AppDatabase? _dbInstance;

AppDatabase getDatabaseInstance() {
  _dbInstance ??= AppDatabase();
  return _dbInstance!;
}

void disposeDatabaseInstance() {
  _dbInstance?.close();
  _dbInstance = null;
}

// ========== DATABASE CONNECTION ==========
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cropdoc.sqlite'));
    return SqfliteQueryExecutor(path: file.path, logStatements: true);
  });
}

// ========== CONNECTIVITY CHECK ==========
Future<bool> isConnectedToInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) return false;

  try {
    final response = await http
        .get(Uri.parse('https://www.google.com'))
        .timeout(const Duration(seconds: 7));
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

// ========== SYNC TRIGGER ==========
Future<void> trySyncWithBackend(AppDatabase db) async {
  final hasInternet = await isConnectedToInternet();
  if (!hasInternet) return;

  final localUser = await db.getFirstUser();
  if (localUser == null) return;

  await syncToServer(db);
  await syncFromServer(db);

  if (kDebugMode) {
    print("✅ Sync completed from reconnect.");
  }
}
