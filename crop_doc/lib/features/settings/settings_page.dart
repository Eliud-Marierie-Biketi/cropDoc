// lib/features/settings/settings_page.dart
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profileTab)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text("🌍 Language"),
          DropdownButton<Locale>(
            value: locale ?? const Locale('en'),
            onChanged: (val) {
              if (val != null) {
                ref.read(localeProvider.notifier).setLocale(val);
              }
            },
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text("English")),
              DropdownMenuItem(value: Locale('sw'), child: Text("Kiswahili")),
            ],
          ),
          const SizedBox(height: 32),
          const Text("🎨 Theme"),
          DropdownButton<ThemeMode>(
            value: theme,
            onChanged: (val) {
              if (val != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(val);
              }
            },
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
              DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
              DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
            ],
          ),
        ],
      ),
    );
  }
}
