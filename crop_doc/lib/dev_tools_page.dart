// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DevToolsPage extends StatelessWidget {
  const DevToolsPage({super.key});

  Future<void> exportDatabase(BuildContext context) async {
    try {
      final dbPath =
          '/data/user/0/com.example.crop_doc/app_flutter/cropdoc.sqlite';
      final outputDir = await getExternalStorageDirectory();

      if (outputDir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get export directory.')),
        );
        return;
      }

      final outFile = File('${outputDir.path}/cropdoc_export.sqlite');
      await File(dbPath).copy(outFile.path);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exported to: ${outFile.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev Tools')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => exportDatabase(context),
          child: const Text('Export Database'),
        ),
      ),
    );
  }
}
