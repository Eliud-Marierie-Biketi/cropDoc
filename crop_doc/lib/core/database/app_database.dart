// app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get country => text()();
  TextColumn get county => text().nullable()();
  TextColumn get role => text()();
  BoolColumn get consent => boolean()();
}

class Crops extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class CropDiseases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cropId => integer().references(Crops, #id)();
  TextColumn get name => text()();
  TextColumn get characteristics => text()();
}

class DiseaseTreatments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get diseaseId => integer().references(CropDiseases, #id)();
  IntColumn get cropId => integer().references(Crops, #id)();
  TextColumn get name => text()();
  TextColumn get instructions => text()();
}

@DriftDatabase(tables: [Users, Crops, CropDiseases, DiseaseTreatments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // 🔼 incremented version

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        // Add new column for username
        await migrator.addColumn(users, users.username);
      }
    },
    onCreate: (migrator) => migrator.createAll(),
  );

  Future<void> resetDatabase() async {
    // Delete all rows from all tables
    await delete(users).go();
    await delete(crops).go();
    await delete(cropDiseases).go();
    await delete(diseaseTreatments).go();

    // Insert default crop
    await insertCrop(CropsCompanion(name: Value('Maize')));
  }

  // ===== USERS =====
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
  Future<List<User>> getUsers() => select(users).get();
  Future<User?> getFirstUser() async => (await getUsers()).firstOrNull;
  Future<bool> updateUser(User user) => update(users).replace(user);
  Future<int> deleteUserById(int id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  // ===== CROPS =====
  Future<int> insertCrop(CropsCompanion crop) => into(crops).insert(crop);
  Future<List<Crop>> getCrops() => select(crops).get();
  Future<Crop?> getCropById(int id) =>
      (select(crops)..where((c) => c.id.equals(id))).getSingleOrNull();
  Future<bool> updateCrop(Crop crop) => update(crops).replace(crop);
  Future<int> deleteCrop(int id) =>
      (delete(crops)..where((c) => c.id.equals(id))).go();

  // ===== DISEASES =====
  Future<int> insertDisease(CropDiseasesCompanion disease) =>
      into(cropDiseases).insert(disease);
  Future<List<CropDisease>> getDiseases() => select(cropDiseases).get();
  Future<List<CropDisease>> getDiseasesByCrop(int cropId) =>
      (select(cropDiseases)..where((d) => d.cropId.equals(cropId))).get();
  Future<bool> updateDisease(CropDisease disease) =>
      update(cropDiseases).replace(disease);
  Future<int> deleteDisease(int id) =>
      (delete(cropDiseases)..where((d) => d.id.equals(id))).go();

  // ===== TREATMENTS =====
  Future<int> insertTreatment(DiseaseTreatmentsCompanion treatment) =>
      into(diseaseTreatments).insert(treatment);
  Future<List<DiseaseTreatment>> getTreatments() =>
      select(diseaseTreatments).get();
  Future<List<DiseaseTreatment>> getTreatmentsByDisease(int diseaseId) =>
      (select(
        diseaseTreatments,
      )..where((t) => t.diseaseId.equals(diseaseId))).get();
  Future<bool> updateTreatment(DiseaseTreatment treatment) =>
      update(diseaseTreatments).replace(treatment);
  Future<int> deleteTreatment(int id) =>
      (delete(diseaseTreatments)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cropdoc.sqlite'));
    return SqfliteQueryExecutor(path: file.path, logStatements: true);
  });
}
