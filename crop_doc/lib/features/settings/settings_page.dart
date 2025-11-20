import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/core/providers/auth_provider.dart';
// import 'package:crop_doc/core/providers/locale_provider.dart';
import 'package:crop_doc/core/providers/theme_mode_provider.dart';
import 'package:crop_doc/features/auth/presentation/onboarding.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear all data?"),
        content: const Text(
          "This will delete your data from the server and log you out. Are you sure?",
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

    if (confirm != true) return;

    try {
      // 🔐 Access auth state
      final authState = ref.read(authProvider);
      final authNotifier = ref.read(authProvider.notifier);

      final user = authState.user;

      // 🌐 Delete from the backend first
      if (user != null) {
        final url = Uri.parse("$baseUrl/api/users/${user.id}/");

        try {
          final response = await http.delete(url);

          if (response.statusCode == 200 || response.statusCode == 204) {
            debugPrint("User deleted from server");
          } else {
            debugPrint(
              "Failed to delete user on server: ${response.statusCode}",
            );
          }
        } catch (e) {
          debugPrint("Server delete error: $e");
        }
      }

      // 🧹 Local cleanup (Hive + session)
      await authNotifier.logout();

      // 🚀 Fresh navigation
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to clear data: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final localeState = ref.watch(localeProvider);
    final theme = ref.watch(themeModeProvider);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 🌍 LANGUAGE
          // Text(
          //   "🌍 ${t.languageLabel}",
          //   style: Theme.of(context).textTheme.titleMedium,
          // ),
          // const SizedBox(height: 8),
          // DropdownButton<Locale>(
          //   value: localeState.locale,
          //   onChanged: (val) {
          //     if (val != null) {
          //       ref.read(localeProvider.notifier).setLocale(val);
          //     }
          //   },
          //   items: const [
          //     DropdownMenuItem(value: Locale('en'), child: Text("English")),
          //     DropdownMenuItem(value: Locale('sw'), child: Text("Kiswahili")),
          //   ],
          // ),

          // 🎨 THEME MODE
          Text(
            "🎨 ${t.themeLabel}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButton<ThemeMode>(
            value: theme,
            onChanged: (val) {
              if (val != null) {
                // Call the notifier method to update state and persist
                ref.read(themeModeProvider.notifier).setTheme(val);
              }
            },
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
              DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
              DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
            ],
          ),

          const SizedBox(height: 40),

          // 🚪 LOGOUT / CLEAR DATA
          ElevatedButton.icon(
            onPressed: () => _clearData(context, ref),
            icon: const Icon(Icons.logout),
            label: Text('Clear Data'),
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
