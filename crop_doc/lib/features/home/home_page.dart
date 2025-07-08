import 'package:crop_doc/shared/widgets/main_shell.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainShell(
      child: Scaffold(
        extendBody: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: child,
      ),
    );
  }
}
