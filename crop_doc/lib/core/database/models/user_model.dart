import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String country;

  @HiveField(4)
  String county;

  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  String role; // 👈 NEW FIELD

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.country,
    required this.county,
    required this.role, // 👈 add here
    this.isSynced = true,
  });

  // 👇 CLEAN COPYWITH
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? country,
    String? county,
    String? role,
    bool? isSynced,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      country: country ?? this.country,
      county: county ?? this.county,
      role: role ?? this.role,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
