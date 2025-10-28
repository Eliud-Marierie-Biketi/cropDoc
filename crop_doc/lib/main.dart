import 'package:crop_doc/app.dart';

import 'package:crop_doc/core/services/hive_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  runApp(const ProviderScope(child: CropDocApp()));
}
