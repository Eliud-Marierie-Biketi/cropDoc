import 'package:crop_doc/features/home/floating_nav_item.dart';
import 'package:crop_doc/features/home/tabs/history_tab.dart';
import 'package:crop_doc/features/home/tabs/profile_tab.dart';
import 'package:crop_doc/features/home/tabs/samples_tab.dart';
import 'package:crop_doc/features/home/tabs/scan_tab.dart';
import 'package:crop_doc/features/settings/settings_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'providers/home_nav_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static final tabs = [
    const ScanTab(),
    const SampleTab(),
    const HistoryTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homeNavIndexProvider);
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final navItems = [
      {'icon': LucideIcons.scan, 'label': t.scanTab},
      {'icon': LucideIcons.image, 'label': t.samplesTab},
      {'icon': LucideIcons.history, 'label': t.historyTab},
      {'icon': LucideIcons.user, 'label': t.profileTab},
    ];

    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(context, t, theme),
      body: AnimatedSwitcher(
        duration: 500.ms,
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: IndexedStack(index: currentIndex, children: tabs),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(
        navItems,
        currentIndex,
        ref,
        context,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations t,
    ThemeData theme,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: const Border(
              bottom: BorderSide(color: Colors.green, width: 2.0),
            ),
          ),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                t.appTitle,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            centerTitle: false, // Move title to the left
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: GlassmorphicContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 0,
              blur: 20,
              alignment: Alignment.center,
              border: 0,
              linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface.withAlpha(230),
                  theme.colorScheme.surface.withAlpha(180),
                ],
              ),
              borderGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.transparent],
              ),
              child: const SizedBox.expand(),
            ),
            actions: [
              IconButton(
                    icon: Icon(
                      LucideIcons.refreshCw,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: t.analyze,
                    onPressed: () => _showSyncAnimation(context),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: theme.colorScheme.secondary.withAlpha(77),
                  ),
              IconButton(
                icon: Icon(
                  LucideIcons.settings,
                  color: theme.colorScheme.primary,
                ),
                tooltip: t.samplesTab,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSyncAnimation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphicContainer(
        width: double.infinity,
        height: 200,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface.withAlpha(128),
            Theme.of(context).colorScheme.surface.withAlpha(77),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(128), Colors.white.withAlpha(77)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.refreshCw, size: 48, color: Colors.white)
                .animate()
                .rotate(duration: 1000.ms, curve: Curves.linear)
                .fadeIn(),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.analyze,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    // ignore: use_build_context_synchronously
    Future.delayed(2.seconds, () => Navigator.pop(context));
  }

  Widget _buildBottomNavBar(
    List<Map<String, dynamic>> navItems,
    int currentIndex,
    WidgetRef ref,
    BuildContext context, // Add this to access theme
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 70,
          borderRadius: 24,
          blur: 20,
          alignment: Alignment.center,
          border: 2, // Make border thicker to show green
          borderGradient: const LinearGradient(
            colors: [Colors.green, Colors.green], // Solid green
          ),
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withAlpha(128), Colors.white.withAlpha(77)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isActive = index == currentIndex;
              final item = navItems[index];

              final iconColor = isDark ? Colors.white : Colors.black;

              return FloatingNavItem(
                icon: item['icon'] as IconData,
                label: item['label'] as String,
                isActive: isActive,
                iconColor: iconColor,
                onTap: () {
                  if (index != currentIndex) {
                    ref.read(homeNavIndexProvider.notifier).state = index;
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
