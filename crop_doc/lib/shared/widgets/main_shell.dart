import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const navItems = [
    {'label': 'Scan', 'icon': LucideIcons.scan, 'route': '/scan'},
    {'label': 'Samples', 'icon': LucideIcons.image, 'route': '/samples'},
    {'label': 'History', 'icon': LucideIcons.history, 'route': '/history'},
    {'label': 'Profile', 'icon': LucideIcons.user, 'route': '/profiles'},
  ];

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = MainShell.navItems.indexWhere(
      (item) => location.startsWith(item['route']! as String),
    );

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (!location.startsWith('/scan')) {
          context.go('/scan');
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
            borderRadius: BorderRadius.circular(20), // Rounded corners
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
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
              icon: LucideIcons.user,
              onTap: () => context.push('/profiles'),
              size: 40,
              padding: 10,
            ),
          ],
        ),
        body: widget.child,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomAppBar(
            color: const Color.fromARGB(255, 63, 238, 87),
            elevation: 0,
            height: 80,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(MainShell.navItems.length, (index) {
                final isActive = index == currentIndex;
                final item = MainShell.navItems[index];

                return FloatingNavItem(
                  icon: item['icon'] as IconData,
                  label: item['label'] as String,
                  isActive: isActive,
                  onTap: () {
                    final targetRoute = item['route']! as String;
                    if (targetRoute != location) {
                      context.go(targetRoute);
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
            boxShadow: [
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
            color: isDarkMode ? Colors.white : Colors.black, // 🔥 Main Change
          ),
        ),
      ),
    );
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
                  ? theme.colorScheme.primary.withAlpha(2)
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
              color: isDarkMode
                  ? Colors.white
                  : Colors.black, // 💪 Always strong
            ),
          ),
        ],
      ),
    );
  }
}
