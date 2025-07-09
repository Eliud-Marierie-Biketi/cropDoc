import 'package:crop_doc/dev_tools_page.dart';
import 'package:flutter/material.dart';

class GoToDevToolsButton extends StatelessWidget {
  const GoToDevToolsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DevToolsPage()),
        );
      },
      icon: const Icon(Icons.developer_mode),
      label: const Text('Open Dev Tools'),
    );
  }
}
