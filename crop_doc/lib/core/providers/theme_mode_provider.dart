import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _themeBoxName = 'app_theme';

/// ThemeNotifier manages ThemeMode (light, dark, system)
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  /// Load saved theme mode from Hive
  Future<void> loadTheme() async {
    final box = await Hive.openBox(_themeBoxName);
    final saved = box.get('themeMode') as String?;

    switch (saved) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  /// Change theme and persist
  Future<void> setTheme(ThemeMode mode) async {
    final box = await Hive.openBox(_themeBoxName);

    await box.put('themeMode', _themeModeToString(mode));
    state = mode;
  }

  /// Convert ThemeMode enum to string for Hive storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'light';
    }
  }
}

/// Riverpod provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});
