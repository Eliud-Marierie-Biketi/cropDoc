// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countyMeta = const VerificationMeta('county');
  @override
  late final GeneratedColumn<String> county = GeneratedColumn<String>(
    'county',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consentMeta = const VerificationMeta(
    'consent',
  );
  @override
  late final GeneratedColumn<bool> consent = GeneratedColumn<bool>(
    'consent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("consent" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    country,
    county,
    role,
    consent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('county')) {
      context.handle(
        _countyMeta,
        county.isAcceptableOrUnknown(data['county']!, _countyMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('consent')) {
      context.handle(
        _consentMeta,
        consent.isAcceptableOrUnknown(data['consent']!, _consentMeta),
      );
    } else if (isInserting) {
      context.missing(_consentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      county: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}county'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      consent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}consent'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String country;
  final String? county;
  final String role;
  final bool consent;
  const User({
    required this.id,
    required this.username,
    required this.country,
    this.county,
    required this.role,
    required this.consent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['country'] = Variable<String>(country);
    if (!nullToAbsent || county != null) {
      map['county'] = Variable<String>(county);
    }
    map['role'] = Variable<String>(role);
    map['consent'] = Variable<bool>(consent);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      country: Value(country),
      county: county == null && nullToAbsent
          ? const Value.absent()
          : Value(county),
      role: Value(role),
      consent: Value(consent),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      country: serializer.fromJson<String>(json['country']),
      county: serializer.fromJson<String?>(json['county']),
      role: serializer.fromJson<String>(json['role']),
      consent: serializer.fromJson<bool>(json['consent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'country': serializer.toJson<String>(country),
      'county': serializer.toJson<String?>(county),
      'role': serializer.toJson<String>(role),
      'consent': serializer.toJson<bool>(consent),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? country,
    Value<String?> county = const Value.absent(),
    String? role,
    bool? consent,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    country: country ?? this.country,
    county: county.present ? county.value : this.county,
    role: role ?? this.role,
    consent: consent ?? this.consent,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      country: data.country.present ? data.country.value : this.country,
      county: data.county.present ? data.county.value : this.county,
      role: data.role.present ? data.role.value : this.role,
      consent: data.consent.present ? data.consent.value : this.consent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('country: $country, ')
          ..write('county: $county, ')
          ..write('role: $role, ')
          ..write('consent: $consent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, country, county, role, consent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.country == this.country &&
          other.county == this.county &&
          other.role == this.role &&
          other.consent == this.consent);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> country;
  final Value<String?> county;
  final Value<String> role;
  final Value<bool> consent;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.country = const Value.absent(),
    this.county = const Value.absent(),
    this.role = const Value.absent(),
    this.consent = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    required String country,
    this.county = const Value.absent(),
    required String role,
    required bool consent,
  }) : country = Value(country),
       role = Value(role),
       consent = Value(consent);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? country,
    Expression<String>? county,
    Expression<String>? role,
    Expression<bool>? consent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (country != null) 'country': country,
      if (county != null) 'county': county,
      if (role != null) 'role': role,
      if (consent != null) 'consent': consent,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? country,
    Value<String?>? county,
    Value<String>? role,
    Value<bool>? consent,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      country: country ?? this.country,
      county: county ?? this.county,
      role: role ?? this.role,
      consent: consent ?? this.consent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (county.present) {
      map['county'] = Variable<String>(county.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (consent.present) {
      map['consent'] = Variable<bool>(consent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('country: $country, ')
          ..write('county: $county, ')
          ..write('role: $role, ')
          ..write('consent: $consent')
          ..write(')'))
        .toString();
  }
}

class $CropsTable extends Crops with TableInfo<$CropsTable, Crop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CropsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crops';
  @override
  VerificationContext validateIntegrity(
    Insertable<Crop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Crop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Crop(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CropsTable createAlias(String alias) {
    return $CropsTable(attachedDatabase, alias);
  }
}

class Crop extends DataClass implements Insertable<Crop> {
  final int id;
  final String name;
  const Crop({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CropsCompanion toCompanion(bool nullToAbsent) {
    return CropsCompanion(id: Value(id), name: Value(name));
  }

  factory Crop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Crop(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Crop copyWith({int? id, String? name}) =>
      Crop(id: id ?? this.id, name: name ?? this.name);
  Crop copyWithCompanion(CropsCompanion data) {
    return Crop(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Crop(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Crop && other.id == this.id && other.name == this.name);
}

class CropsCompanion extends UpdateCompanion<Crop> {
  final Value<int> id;
  final Value<String> name;
  const CropsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CropsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Crop> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  CropsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return CropsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CropsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CropDiseasesTable extends CropDiseases
    with TableInfo<$CropDiseasesTable, CropDisease> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CropDiseasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<int> cropId = GeneratedColumn<int>(
    'crop_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characteristicsMeta = const VerificationMeta(
    'characteristics',
  );
  @override
  late final GeneratedColumn<String> characteristics = GeneratedColumn<String>(
    'characteristics',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cropId, name, characteristics];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crop_diseases';
  @override
  VerificationContext validateIntegrity(
    Insertable<CropDisease> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cropIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('characteristics')) {
      context.handle(
        _characteristicsMeta,
        characteristics.isAcceptableOrUnknown(
          data['characteristics']!,
          _characteristicsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characteristicsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CropDisease map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CropDisease(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crop_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      characteristics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}characteristics'],
      )!,
    );
  }

  @override
  $CropDiseasesTable createAlias(String alias) {
    return $CropDiseasesTable(attachedDatabase, alias);
  }
}

class CropDisease extends DataClass implements Insertable<CropDisease> {
  final int id;
  final int cropId;
  final String name;
  final String characteristics;
  const CropDisease({
    required this.id,
    required this.cropId,
    required this.name,
    required this.characteristics,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crop_id'] = Variable<int>(cropId);
    map['name'] = Variable<String>(name);
    map['characteristics'] = Variable<String>(characteristics);
    return map;
  }

  CropDiseasesCompanion toCompanion(bool nullToAbsent) {
    return CropDiseasesCompanion(
      id: Value(id),
      cropId: Value(cropId),
      name: Value(name),
      characteristics: Value(characteristics),
    );
  }

  factory CropDisease.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CropDisease(
      id: serializer.fromJson<int>(json['id']),
      cropId: serializer.fromJson<int>(json['cropId']),
      name: serializer.fromJson<String>(json['name']),
      characteristics: serializer.fromJson<String>(json['characteristics']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cropId': serializer.toJson<int>(cropId),
      'name': serializer.toJson<String>(name),
      'characteristics': serializer.toJson<String>(characteristics),
    };
  }

  CropDisease copyWith({
    int? id,
    int? cropId,
    String? name,
    String? characteristics,
  }) => CropDisease(
    id: id ?? this.id,
    cropId: cropId ?? this.cropId,
    name: name ?? this.name,
    characteristics: characteristics ?? this.characteristics,
  );
  CropDisease copyWithCompanion(CropDiseasesCompanion data) {
    return CropDisease(
      id: data.id.present ? data.id.value : this.id,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      name: data.name.present ? data.name.value : this.name,
      characteristics: data.characteristics.present
          ? data.characteristics.value
          : this.characteristics,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CropDisease(')
          ..write('id: $id, ')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('characteristics: $characteristics')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cropId, name, characteristics);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CropDisease &&
          other.id == this.id &&
          other.cropId == this.cropId &&
          other.name == this.name &&
          other.characteristics == this.characteristics);
}

class CropDiseasesCompanion extends UpdateCompanion<CropDisease> {
  final Value<int> id;
  final Value<int> cropId;
  final Value<String> name;
  final Value<String> characteristics;
  const CropDiseasesCompanion({
    this.id = const Value.absent(),
    this.cropId = const Value.absent(),
    this.name = const Value.absent(),
    this.characteristics = const Value.absent(),
  });
  CropDiseasesCompanion.insert({
    this.id = const Value.absent(),
    required int cropId,
    required String name,
    required String characteristics,
  }) : cropId = Value(cropId),
       name = Value(name),
       characteristics = Value(characteristics);
  static Insertable<CropDisease> custom({
    Expression<int>? id,
    Expression<int>? cropId,
    Expression<String>? name,
    Expression<String>? characteristics,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cropId != null) 'crop_id': cropId,
      if (name != null) 'name': name,
      if (characteristics != null) 'characteristics': characteristics,
    });
  }

  CropDiseasesCompanion copyWith({
    Value<int>? id,
    Value<int>? cropId,
    Value<String>? name,
    Value<String>? characteristics,
  }) {
    return CropDiseasesCompanion(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      name: name ?? this.name,
      characteristics: characteristics ?? this.characteristics,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<int>(cropId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (characteristics.present) {
      map['characteristics'] = Variable<String>(characteristics.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CropDiseasesCompanion(')
          ..write('id: $id, ')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('characteristics: $characteristics')
          ..write(')'))
        .toString();
  }
}

class $DiseaseTreatmentsTable extends DiseaseTreatments
    with TableInfo<$DiseaseTreatmentsTable, DiseaseTreatment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiseaseTreatmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _diseaseIdMeta = const VerificationMeta(
    'diseaseId',
  );
  @override
  late final GeneratedColumn<int> diseaseId = GeneratedColumn<int>(
    'disease_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crop_diseases (id)',
    ),
  );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<int> cropId = GeneratedColumn<int>(
    'crop_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diseaseId,
    cropId,
    name,
    instructions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'disease_treatments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiseaseTreatment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('disease_id')) {
      context.handle(
        _diseaseIdMeta,
        diseaseId.isAcceptableOrUnknown(data['disease_id']!, _diseaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diseaseIdMeta);
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cropIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiseaseTreatment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiseaseTreatment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diseaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disease_id'],
      )!,
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crop_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      )!,
    );
  }

  @override
  $DiseaseTreatmentsTable createAlias(String alias) {
    return $DiseaseTreatmentsTable(attachedDatabase, alias);
  }
}

class DiseaseTreatment extends DataClass
    implements Insertable<DiseaseTreatment> {
  final int id;
  final int diseaseId;
  final int cropId;
  final String name;
  final String instructions;
  const DiseaseTreatment({
    required this.id,
    required this.diseaseId,
    required this.cropId,
    required this.name,
    required this.instructions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['disease_id'] = Variable<int>(diseaseId);
    map['crop_id'] = Variable<int>(cropId);
    map['name'] = Variable<String>(name);
    map['instructions'] = Variable<String>(instructions);
    return map;
  }

  DiseaseTreatmentsCompanion toCompanion(bool nullToAbsent) {
    return DiseaseTreatmentsCompanion(
      id: Value(id),
      diseaseId: Value(diseaseId),
      cropId: Value(cropId),
      name: Value(name),
      instructions: Value(instructions),
    );
  }

  factory DiseaseTreatment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiseaseTreatment(
      id: serializer.fromJson<int>(json['id']),
      diseaseId: serializer.fromJson<int>(json['diseaseId']),
      cropId: serializer.fromJson<int>(json['cropId']),
      name: serializer.fromJson<String>(json['name']),
      instructions: serializer.fromJson<String>(json['instructions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diseaseId': serializer.toJson<int>(diseaseId),
      'cropId': serializer.toJson<int>(cropId),
      'name': serializer.toJson<String>(name),
      'instructions': serializer.toJson<String>(instructions),
    };
  }

  DiseaseTreatment copyWith({
    int? id,
    int? diseaseId,
    int? cropId,
    String? name,
    String? instructions,
  }) => DiseaseTreatment(
    id: id ?? this.id,
    diseaseId: diseaseId ?? this.diseaseId,
    cropId: cropId ?? this.cropId,
    name: name ?? this.name,
    instructions: instructions ?? this.instructions,
  );
  DiseaseTreatment copyWithCompanion(DiseaseTreatmentsCompanion data) {
    return DiseaseTreatment(
      id: data.id.present ? data.id.value : this.id,
      diseaseId: data.diseaseId.present ? data.diseaseId.value : this.diseaseId,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      name: data.name.present ? data.name.value : this.name,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiseaseTreatment(')
          ..write('id: $id, ')
          ..write('diseaseId: $diseaseId, ')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diseaseId, cropId, name, instructions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiseaseTreatment &&
          other.id == this.id &&
          other.diseaseId == this.diseaseId &&
          other.cropId == this.cropId &&
          other.name == this.name &&
          other.instructions == this.instructions);
}

class DiseaseTreatmentsCompanion extends UpdateCompanion<DiseaseTreatment> {
  final Value<int> id;
  final Value<int> diseaseId;
  final Value<int> cropId;
  final Value<String> name;
  final Value<String> instructions;
  const DiseaseTreatmentsCompanion({
    this.id = const Value.absent(),
    this.diseaseId = const Value.absent(),
    this.cropId = const Value.absent(),
    this.name = const Value.absent(),
    this.instructions = const Value.absent(),
  });
  DiseaseTreatmentsCompanion.insert({
    this.id = const Value.absent(),
    required int diseaseId,
    required int cropId,
    required String name,
    required String instructions,
  }) : diseaseId = Value(diseaseId),
       cropId = Value(cropId),
       name = Value(name),
       instructions = Value(instructions);
  static Insertable<DiseaseTreatment> custom({
    Expression<int>? id,
    Expression<int>? diseaseId,
    Expression<int>? cropId,
    Expression<String>? name,
    Expression<String>? instructions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diseaseId != null) 'disease_id': diseaseId,
      if (cropId != null) 'crop_id': cropId,
      if (name != null) 'name': name,
      if (instructions != null) 'instructions': instructions,
    });
  }

  DiseaseTreatmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? diseaseId,
    Value<int>? cropId,
    Value<String>? name,
    Value<String>? instructions,
  }) {
    return DiseaseTreatmentsCompanion(
      id: id ?? this.id,
      diseaseId: diseaseId ?? this.diseaseId,
      cropId: cropId ?? this.cropId,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diseaseId.present) {
      map['disease_id'] = Variable<int>(diseaseId.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<int>(cropId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiseaseTreatmentsCompanion(')
          ..write('id: $id, ')
          ..write('diseaseId: $diseaseId, ')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CropsTable crops = $CropsTable(this);
  late final $CropDiseasesTable cropDiseases = $CropDiseasesTable(this);
  late final $DiseaseTreatmentsTable diseaseTreatments =
      $DiseaseTreatmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    crops,
    cropDiseases,
    diseaseTreatments,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      required String country,
      Value<String?> county,
      required String role,
      required bool consent,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> country,
      Value<String?> county,
      Value<String> role,
      Value<bool> consent,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get county => $composableBuilder(
    column: $table.county,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get consent => $composableBuilder(
    column: $table.consent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get county => $composableBuilder(
    column: $table.county,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get consent => $composableBuilder(
    column: $table.consent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get county =>
      $composableBuilder(column: $table.county, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get consent =>
      $composableBuilder(column: $table.consent, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String?> county = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> consent = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                country: country,
                county: county,
                role: role,
                consent: consent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                required String country,
                Value<String?> county = const Value.absent(),
                required String role,
                required bool consent,
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                country: country,
                county: county,
                role: role,
                consent: consent,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$CropsTableCreateCompanionBuilder =
    CropsCompanion Function({Value<int> id, required String name});
typedef $$CropsTableUpdateCompanionBuilder =
    CropsCompanion Function({Value<int> id, Value<String> name});

final class $$CropsTableReferences
    extends BaseReferences<_$AppDatabase, $CropsTable, Crop> {
  $$CropsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CropDiseasesTable, List<CropDisease>>
  _cropDiseasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cropDiseases,
    aliasName: $_aliasNameGenerator(db.crops.id, db.cropDiseases.cropId),
  );

  $$CropDiseasesTableProcessedTableManager get cropDiseasesRefs {
    final manager = $$CropDiseasesTableTableManager(
      $_db,
      $_db.cropDiseases,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cropDiseasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DiseaseTreatmentsTable, List<DiseaseTreatment>>
  _diseaseTreatmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.diseaseTreatments,
        aliasName: $_aliasNameGenerator(
          db.crops.id,
          db.diseaseTreatments.cropId,
        ),
      );

  $$DiseaseTreatmentsTableProcessedTableManager get diseaseTreatmentsRefs {
    final manager = $$DiseaseTreatmentsTableTableManager(
      $_db,
      $_db.diseaseTreatments,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _diseaseTreatmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CropsTableFilterComposer extends Composer<_$AppDatabase, $CropsTable> {
  $$CropsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cropDiseasesRefs(
    Expression<bool> Function($$CropDiseasesTableFilterComposer f) f,
  ) {
    final $$CropDiseasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cropDiseases,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropDiseasesTableFilterComposer(
            $db: $db,
            $table: $db.cropDiseases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diseaseTreatmentsRefs(
    Expression<bool> Function($$DiseaseTreatmentsTableFilterComposer f) f,
  ) {
    final $$DiseaseTreatmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diseaseTreatments,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiseaseTreatmentsTableFilterComposer(
            $db: $db,
            $table: $db.diseaseTreatments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CropsTableOrderingComposer
    extends Composer<_$AppDatabase, $CropsTable> {
  $$CropsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CropsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CropsTable> {
  $$CropsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> cropDiseasesRefs<T extends Object>(
    Expression<T> Function($$CropDiseasesTableAnnotationComposer a) f,
  ) {
    final $$CropDiseasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cropDiseases,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropDiseasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cropDiseases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> diseaseTreatmentsRefs<T extends Object>(
    Expression<T> Function($$DiseaseTreatmentsTableAnnotationComposer a) f,
  ) {
    final $$DiseaseTreatmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.diseaseTreatments,
          getReferencedColumn: (t) => t.cropId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiseaseTreatmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.diseaseTreatments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CropsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CropsTable,
          Crop,
          $$CropsTableFilterComposer,
          $$CropsTableOrderingComposer,
          $$CropsTableAnnotationComposer,
          $$CropsTableCreateCompanionBuilder,
          $$CropsTableUpdateCompanionBuilder,
          (Crop, $$CropsTableReferences),
          Crop,
          PrefetchHooks Function({
            bool cropDiseasesRefs,
            bool diseaseTreatmentsRefs,
          })
        > {
  $$CropsTableTableManager(_$AppDatabase db, $CropsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CropsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CropsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CropsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => CropsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  CropsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CropsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({cropDiseasesRefs = false, diseaseTreatmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cropDiseasesRefs) db.cropDiseases,
                    if (diseaseTreatmentsRefs) db.diseaseTreatments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cropDiseasesRefs)
                        await $_getPrefetchedData<
                          Crop,
                          $CropsTable,
                          CropDisease
                        >(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._cropDiseasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(
                                db,
                                table,
                                p0,
                              ).cropDiseasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diseaseTreatmentsRefs)
                        await $_getPrefetchedData<
                          Crop,
                          $CropsTable,
                          DiseaseTreatment
                        >(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._diseaseTreatmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(
                                db,
                                table,
                                p0,
                              ).diseaseTreatmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CropsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CropsTable,
      Crop,
      $$CropsTableFilterComposer,
      $$CropsTableOrderingComposer,
      $$CropsTableAnnotationComposer,
      $$CropsTableCreateCompanionBuilder,
      $$CropsTableUpdateCompanionBuilder,
      (Crop, $$CropsTableReferences),
      Crop,
      PrefetchHooks Function({
        bool cropDiseasesRefs,
        bool diseaseTreatmentsRefs,
      })
    >;
typedef $$CropDiseasesTableCreateCompanionBuilder =
    CropDiseasesCompanion Function({
      Value<int> id,
      required int cropId,
      required String name,
      required String characteristics,
    });
typedef $$CropDiseasesTableUpdateCompanionBuilder =
    CropDiseasesCompanion Function({
      Value<int> id,
      Value<int> cropId,
      Value<String> name,
      Value<String> characteristics,
    });

final class $$CropDiseasesTableReferences
    extends BaseReferences<_$AppDatabase, $CropDiseasesTable, CropDisease> {
  $$CropDiseasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CropsTable _cropIdTable(_$AppDatabase db) => db.crops.createAlias(
    $_aliasNameGenerator(db.cropDiseases.cropId, db.crops.id),
  );

  $$CropsTableProcessedTableManager get cropId {
    final $_column = $_itemColumn<int>('crop_id')!;

    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DiseaseTreatmentsTable, List<DiseaseTreatment>>
  _diseaseTreatmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.diseaseTreatments,
        aliasName: $_aliasNameGenerator(
          db.cropDiseases.id,
          db.diseaseTreatments.diseaseId,
        ),
      );

  $$DiseaseTreatmentsTableProcessedTableManager get diseaseTreatmentsRefs {
    final manager = $$DiseaseTreatmentsTableTableManager(
      $_db,
      $_db.diseaseTreatments,
    ).filter((f) => f.diseaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _diseaseTreatmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CropDiseasesTableFilterComposer
    extends Composer<_$AppDatabase, $CropDiseasesTable> {
  $$CropDiseasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get characteristics => $composableBuilder(
    column: $table.characteristics,
    builder: (column) => ColumnFilters(column),
  );

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> diseaseTreatmentsRefs(
    Expression<bool> Function($$DiseaseTreatmentsTableFilterComposer f) f,
  ) {
    final $$DiseaseTreatmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diseaseTreatments,
      getReferencedColumn: (t) => t.diseaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiseaseTreatmentsTableFilterComposer(
            $db: $db,
            $table: $db.diseaseTreatments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CropDiseasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CropDiseasesTable> {
  $$CropDiseasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get characteristics => $composableBuilder(
    column: $table.characteristics,
    builder: (column) => ColumnOrderings(column),
  );

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CropDiseasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CropDiseasesTable> {
  $$CropDiseasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get characteristics => $composableBuilder(
    column: $table.characteristics,
    builder: (column) => column,
  );

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> diseaseTreatmentsRefs<T extends Object>(
    Expression<T> Function($$DiseaseTreatmentsTableAnnotationComposer a) f,
  ) {
    final $$DiseaseTreatmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.diseaseTreatments,
          getReferencedColumn: (t) => t.diseaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiseaseTreatmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.diseaseTreatments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CropDiseasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CropDiseasesTable,
          CropDisease,
          $$CropDiseasesTableFilterComposer,
          $$CropDiseasesTableOrderingComposer,
          $$CropDiseasesTableAnnotationComposer,
          $$CropDiseasesTableCreateCompanionBuilder,
          $$CropDiseasesTableUpdateCompanionBuilder,
          (CropDisease, $$CropDiseasesTableReferences),
          CropDisease,
          PrefetchHooks Function({bool cropId, bool diseaseTreatmentsRefs})
        > {
  $$CropDiseasesTableTableManager(_$AppDatabase db, $CropDiseasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CropDiseasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CropDiseasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CropDiseasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cropId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> characteristics = const Value.absent(),
              }) => CropDiseasesCompanion(
                id: id,
                cropId: cropId,
                name: name,
                characteristics: characteristics,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cropId,
                required String name,
                required String characteristics,
              }) => CropDiseasesCompanion.insert(
                id: id,
                cropId: cropId,
                name: name,
                characteristics: characteristics,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CropDiseasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cropId = false, diseaseTreatmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (diseaseTreatmentsRefs) db.diseaseTreatments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cropId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cropId,
                                    referencedTable:
                                        $$CropDiseasesTableReferences
                                            ._cropIdTable(db),
                                    referencedColumn:
                                        $$CropDiseasesTableReferences
                                            ._cropIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (diseaseTreatmentsRefs)
                        await $_getPrefetchedData<
                          CropDisease,
                          $CropDiseasesTable,
                          DiseaseTreatment
                        >(
                          currentTable: table,
                          referencedTable: $$CropDiseasesTableReferences
                              ._diseaseTreatmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropDiseasesTableReferences(
                                db,
                                table,
                                p0,
                              ).diseaseTreatmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diseaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CropDiseasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CropDiseasesTable,
      CropDisease,
      $$CropDiseasesTableFilterComposer,
      $$CropDiseasesTableOrderingComposer,
      $$CropDiseasesTableAnnotationComposer,
      $$CropDiseasesTableCreateCompanionBuilder,
      $$CropDiseasesTableUpdateCompanionBuilder,
      (CropDisease, $$CropDiseasesTableReferences),
      CropDisease,
      PrefetchHooks Function({bool cropId, bool diseaseTreatmentsRefs})
    >;
typedef $$DiseaseTreatmentsTableCreateCompanionBuilder =
    DiseaseTreatmentsCompanion Function({
      Value<int> id,
      required int diseaseId,
      required int cropId,
      required String name,
      required String instructions,
    });
typedef $$DiseaseTreatmentsTableUpdateCompanionBuilder =
    DiseaseTreatmentsCompanion Function({
      Value<int> id,
      Value<int> diseaseId,
      Value<int> cropId,
      Value<String> name,
      Value<String> instructions,
    });

final class $$DiseaseTreatmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DiseaseTreatmentsTable,
          DiseaseTreatment
        > {
  $$DiseaseTreatmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CropDiseasesTable _diseaseIdTable(_$AppDatabase db) =>
      db.cropDiseases.createAlias(
        $_aliasNameGenerator(
          db.diseaseTreatments.diseaseId,
          db.cropDiseases.id,
        ),
      );

  $$CropDiseasesTableProcessedTableManager get diseaseId {
    final $_column = $_itemColumn<int>('disease_id')!;

    final manager = $$CropDiseasesTableTableManager(
      $_db,
      $_db.cropDiseases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diseaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CropsTable _cropIdTable(_$AppDatabase db) => db.crops.createAlias(
    $_aliasNameGenerator(db.diseaseTreatments.cropId, db.crops.id),
  );

  $$CropsTableProcessedTableManager get cropId {
    final $_column = $_itemColumn<int>('crop_id')!;

    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiseaseTreatmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DiseaseTreatmentsTable> {
  $$DiseaseTreatmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  $$CropDiseasesTableFilterComposer get diseaseId {
    final $$CropDiseasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diseaseId,
      referencedTable: $db.cropDiseases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropDiseasesTableFilterComposer(
            $db: $db,
            $table: $db.cropDiseases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiseaseTreatmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiseaseTreatmentsTable> {
  $$DiseaseTreatmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  $$CropDiseasesTableOrderingComposer get diseaseId {
    final $$CropDiseasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diseaseId,
      referencedTable: $db.cropDiseases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropDiseasesTableOrderingComposer(
            $db: $db,
            $table: $db.cropDiseases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiseaseTreatmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiseaseTreatmentsTable> {
  $$DiseaseTreatmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  $$CropDiseasesTableAnnotationComposer get diseaseId {
    final $$CropDiseasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diseaseId,
      referencedTable: $db.cropDiseases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropDiseasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cropDiseases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiseaseTreatmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiseaseTreatmentsTable,
          DiseaseTreatment,
          $$DiseaseTreatmentsTableFilterComposer,
          $$DiseaseTreatmentsTableOrderingComposer,
          $$DiseaseTreatmentsTableAnnotationComposer,
          $$DiseaseTreatmentsTableCreateCompanionBuilder,
          $$DiseaseTreatmentsTableUpdateCompanionBuilder,
          (DiseaseTreatment, $$DiseaseTreatmentsTableReferences),
          DiseaseTreatment,
          PrefetchHooks Function({bool diseaseId, bool cropId})
        > {
  $$DiseaseTreatmentsTableTableManager(
    _$AppDatabase db,
    $DiseaseTreatmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiseaseTreatmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiseaseTreatmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiseaseTreatmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> diseaseId = const Value.absent(),
                Value<int> cropId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> instructions = const Value.absent(),
              }) => DiseaseTreatmentsCompanion(
                id: id,
                diseaseId: diseaseId,
                cropId: cropId,
                name: name,
                instructions: instructions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int diseaseId,
                required int cropId,
                required String name,
                required String instructions,
              }) => DiseaseTreatmentsCompanion.insert(
                id: id,
                diseaseId: diseaseId,
                cropId: cropId,
                name: name,
                instructions: instructions,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiseaseTreatmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diseaseId = false, cropId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diseaseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diseaseId,
                                referencedTable:
                                    $$DiseaseTreatmentsTableReferences
                                        ._diseaseIdTable(db),
                                referencedColumn:
                                    $$DiseaseTreatmentsTableReferences
                                        ._diseaseIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (cropId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cropId,
                                referencedTable:
                                    $$DiseaseTreatmentsTableReferences
                                        ._cropIdTable(db),
                                referencedColumn:
                                    $$DiseaseTreatmentsTableReferences
                                        ._cropIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiseaseTreatmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiseaseTreatmentsTable,
      DiseaseTreatment,
      $$DiseaseTreatmentsTableFilterComposer,
      $$DiseaseTreatmentsTableOrderingComposer,
      $$DiseaseTreatmentsTableAnnotationComposer,
      $$DiseaseTreatmentsTableCreateCompanionBuilder,
      $$DiseaseTreatmentsTableUpdateCompanionBuilder,
      (DiseaseTreatment, $$DiseaseTreatmentsTableReferences),
      DiseaseTreatment,
      PrefetchHooks Function({bool diseaseId, bool cropId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CropsTableTableManager get crops =>
      $$CropsTableTableManager(_db, _db.crops);
  $$CropDiseasesTableTableManager get cropDiseases =>
      $$CropDiseasesTableTableManager(_db, _db.cropDiseases);
  $$DiseaseTreatmentsTableTableManager get diseaseTreatments =>
      $$DiseaseTreatmentsTableTableManager(_db, _db.diseaseTreatments);
}
