import 'package:crop_doc/features/home/floating_nav_item.dart';
import 'package:crop_doc/features/home/tabs/history_tab.dart';
import 'package:crop_doc/features/home/tabs/profile_tab.dart';
import 'package:crop_doc/features/home/tabs/samples_tab.dart';
import 'package:crop_doc/features/home/tabs/scan_tab.dart';
import 'package:crop_doc/features/settings/settings_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/home_nav_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static final tabs = [ScanTab(), SampleTab(), HistoryTab(), ProfileTab()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeNavIndexProvider);
    final t = AppLocalizations.of(context)!;

    final navItems = [
      {'icon': Icons.camera_alt, 'label': t.scanTab},
      {'icon': Icons.image, 'label': t.samplesTab},
      {'icon': Icons.history, 'label': t.historyTab},
      {'icon': Icons.person, 'label': t.profileTab},
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.sync)),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: tabs[currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 5,
          height: 80,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isActive = index == currentIndex;
              final item = navItems[index];

              return FloatingNavItem(
                icon: item['icon'] as IconData,
                label: item['label'] as String,
                isActive: isActive,
                onTap: () {
                  ref.read(homeNavIndexProvider.notifier).state = index;
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
