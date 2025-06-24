import 'package:crop_doc/core/database/app_database_provider.dart';
import 'package:crop_doc/features/auth/presentation/onboarding.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final db = ref.read(appDatabaseProvider);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear all data?"),
        content: const Text(
          "This will delete all local app data. Are you sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Clear Data"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await db
          .deleteAllData(); // <-- You must implement this in your AppDatabase
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeModeProvider);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            "🌍 ${t.languageLabel}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
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
          Text(
            "🎨 ${t.themeLabel}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 40),

          // Clear data / logout button
          ElevatedButton.icon(
            onPressed: () => _clearData(context, ref),
            icon: const Icon(Icons.logout),
            label: Text(t.logoutButton),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
