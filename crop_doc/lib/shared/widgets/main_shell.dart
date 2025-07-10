// ignore_for_file: deprecated_member_use

import 'package:crop_doc/core/database/app_database.dart';
import 'package:crop_doc/core/database/app_database_provider.dart';
import 'package:crop_doc/core/services/sync_service.dart';
import 'package:crop_doc/features/home/tabs/history_tab.dart';
import 'package:crop_doc/features/home/tabs/profile_tab.dart';
import 'package:crop_doc/features/home/tabs/samples_tab.dart';
import 'package:crop_doc/features/home/tabs/scan_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global key to control tab switching from anywhere (e.g., after navigation)
final GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();

class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => MainShellState();
}

class MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  static const navItems = [
    {'label': 'Scan', 'icon': LucideIcons.scan},
    {'label': 'Samples', 'icon': LucideIcons.image},
    {'label': 'History', 'icon': LucideIcons.history},
    {'label': 'Profile', 'icon': LucideIcons.user},
  ];

  final List<Widget> _pages = const [
    ScanPage(),
    SamplesPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  /// Allows switching tabs programmatically from outside
  void switchTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        } else {
          SystemNavigator.pop();
          return false;
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 100,
          title: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/logo.png',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 63, 238, 87),
          elevation: 0,
          actions: [
            _buildBubbleIcon(
              context,
              icon: LucideIcons.settings,
              onTap: () => context.push('/settings'),
            ),
            _buildBubbleIcon(
              context,
              icon: LucideIcons.refreshCcw,
              onTap: () async {
                final db = ref.read(appDatabaseProvider);
                await runSync(db);
              },
            ),
          ],
        ),
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomAppBar(
            color: const Color.fromARGB(255, 63, 238, 87),
            elevation: 0,
            height: 80,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final isActive = index == _currentIndex;
                final item = navItems[index];

                return FloatingNavItem(
                  icon: item['icon'] as IconData,
                  label: item['label'] as String,
                  isActive: isActive,
                  onTap: () {
                    if (!isActive) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    double size = 20,
    double padding = 10,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border.all(color: theme.colorScheme.onSurface, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(padding),
          child: Icon(
            icon,
            size: size,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

Future<void> runSync(AppDatabase db, {VoidCallback? onSyncComplete}) async {
  try {
    await syncToServer(db);
    await syncFromServer(db);

    if (kDebugMode) {
      print('✅ Sync complete');
    }

    if (onSyncComplete != null) {
      onSyncComplete(); // 🔁 notify UI
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Sync failed: $e');
    }
  }
}

class FloatingNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FloatingNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final Color activeColor = isDarkMode ? Colors.white : Colors.black;
    final Color inactiveIconColor = isDarkMode
        ? Colors.white.withAlpha(90)
        : Colors.black.withAlpha(90);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? theme.colorScheme.primary.withAlpha(10)
                  : Colors.transparent,
              border: Border.all(color: theme.colorScheme.outline, width: 1),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive ? activeColor : inactiveIconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
