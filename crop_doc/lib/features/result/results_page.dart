// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:crop_doc/core/database/app_database.dart';
import 'package:crop_doc/features/home/home_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic>? resultData;
  final File? imageFile;

  ResultsPage({super.key, this.resultData, this.imageFile}) {
    debugPrint("🔍 resultData: $resultData");
    debugPrint("📸 imageFile path: ${imageFile?.path}");
  }

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final result = resultData?['result'] ?? "Unknown";
    final confidence = (resultData?['confidence'] ?? 0.0) as double;
    final List<dynamic>? recommendations =
        resultData?['recommendation'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.results),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context, true), // ✅ returns true to trigger refresh
        ),
      ),

      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (imageFile != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.file(
                          imageFile!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildResultRow("Result", result),
                          _buildResultRow(
                            "Confidence",
                            "${(confidence * 100).toStringAsFixed(1)}%",
                          ),
                          const SizedBox(height: 12),

                          if (recommendations != null &&
                              recommendations.isNotEmpty) ...[
                            Text(
                              "Recommendations",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 180, // adjust if needed
                              child: ListView.builder(
                                itemCount: recommendations.length,
                                itemBuilder: (_, index) {
                                  final rec = recommendations[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildResultRow(
                                            "Drug",
                                            rec['drug_name'] ?? 'N/A',
                                          ),
                                          _buildResultRow(
                                            "Instructions",
                                            rec['drug_administration_instructions'] ??
                                                'N/A',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ] else
                            Text(
                              "No treatment needed",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.green[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _downloadCard(context),
                  icon: const Icon(Icons.download),
                  label: const Text("Download"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _screenshotAndSave(context),
                  icon: const Icon(Icons.screenshot),
                  label: const Text("Screenshot"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.poppins(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<void> _screenshotAndSave(BuildContext context) async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final path = await _saveImage(image, "screenshot_result");

      await _saveToHistory(path);

      // Optional confirmation dialog (remove if unnecessary)
      // _showSavedDialog(context, path);

      if (context.mounted) {
        context.pop(); // Close /results page
        mainShellKey.currentState?.switchTab(2);
      }
    } catch (e) {
      _showErrorDialog(context, "Screenshot failed: $e");
    }
  }

  Future<void> _downloadCard(BuildContext context) async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final path = await _saveImage(image, "result_card");

      await _saveToHistory(path);

      if (context.mounted) {
        context.pop(); // Close /results page
        mainShellKey.currentState?.switchTab(2);
      }
    } catch (e) {
      _showErrorDialog(context, "Download failed: $e");
    }
  }

  Future<void> _saveToHistory(String imagePath) async {
    final db = getDatabaseInstance();

    // Get current count
    final allHistory = await db.getAllHistory();
    if (allHistory.length >= 9) {
      // Sort by timestamp and delete the oldest
      allHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      await db.deleteHistoryById(allHistory.first.id);
    }

    await db.insertHistory(
      HistoryCompanion(
        imagePath: Value(imagePath),
        cropName: const Value("Crop"), // or actual crop name
        disease: const Value("Detected Disease"),
        confidence: const Value("93%"),
        timestamp: Value(DateTime.now()),
        recommendationsJson: const Value(null), // or actual value
      ),
    );
  }

  Future<String> _saveImage(Uint8List imageBytes, String filenamePrefix) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        "${directory.path}/${filenamePrefix}_${DateTime.now().millisecondsSinceEpoch}.png";

    await compute(_writeFile, {'path': filePath, 'bytes': imageBytes});
    return filePath;
  }

  void _writeFile(Map<String, dynamic> data) {
    final file = File(data['path']);
    file.writeAsBytesSync(data['bytes']);
  }

  // ignore: unused_element
  void _showSavedDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Saved"),
        content: Text("File saved at:\n$path"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
