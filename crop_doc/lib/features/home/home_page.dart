import 'package:crop_doc/shared/widgets/main_shell.dart';
import 'package:flutter/material.dart';

/// This key allows you to programmatically switch tabs in MainShell
final GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();

class HomePage extends StatelessWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainShell(
      key: mainShellKey, // ✅ Assign key here
      child: Scaffold(
        extendBody: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: child,
      ),
    );
  }
}
