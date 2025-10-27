import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Box name for storing locale preference
const String _localeBoxName = 'app_locale';

/// State class to hold current locale
class LocaleState {
  final Locale? locale;

  const LocaleState({this.locale});

  LocaleState copyWith({Locale? locale}) =>
      LocaleState(locale: locale ?? this.locale);
}

/// Notifier to manage locale changes
class LocaleNotifier extends StateNotifier<LocaleState> {
  LocaleNotifier() : super(const LocaleState());

  /// Initialize locale from Hive or fallback to system locale
  Future<void> loadLocale() async {
    final box = await Hive.openBox(_localeBoxName);
    final String? localeCode = box.get('localeCode');

    if (localeCode != null && localeCode.isNotEmpty) {
      state = state.copyWith(locale: Locale(localeCode));
    } else {
      // Fallback to system locale
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      state = state.copyWith(locale: systemLocale);
    }
  }

  /// Set and persist locale
  Future<void> setLocale(Locale locale) async {
    final box = await Hive.openBox(_localeBoxName);
    await box.put('localeCode', locale.languageCode);
    state = state.copyWith(locale: locale);
  }

  /// Clear locale preference (reset to system)
  Future<void> resetLocale() async {
    final box = await Hive.openBox(_localeBoxName);
    await box.delete('localeCode');
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    state = state.copyWith(locale: systemLocale);
  }
}

/// Riverpod provider for locale management
final localeProvider = StateNotifierProvider<LocaleNotifier, LocaleState>((
  ref,
) {
  return LocaleNotifier();
});
