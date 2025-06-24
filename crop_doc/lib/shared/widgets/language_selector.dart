// lib/shared/widgets/language_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return DropdownButton<Locale>(
      value: locale ?? const Locale('en'),
      onChanged: (Locale? selected) {
        if (selected != null) {
          ref.read(localeProvider.notifier).setLocale(selected);
        }
      },
      items: const [
        DropdownMenuItem(value: Locale('en'), child: Text("English")),
        DropdownMenuItem(value: Locale('sw'), child: Text("Kiswahili")),
      ],
    );
  }
}
