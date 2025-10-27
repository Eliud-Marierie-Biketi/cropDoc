// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:crop_doc/core/state/history_refresh_notifier.dart';
import 'package:crop_doc/features/home/home_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screenshot/screenshot.dart';

class ResultsPage extends HookConsumerWidget {
  final Map<String, dynamic>? resultData;
  final File? imageFile;

  ResultsPage({super.key, this.resultData, this.imageFile}) {
    debugPrint("🔍 resultData: $resultData");
    debugPrint("📸 imageFile path: ${imageFile?.path}");
  }

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final result = resultData?['result'] ?? "Unknown";
    final confidence = (resultData?['confidence'] ?? 0.0) as double;
    final List<dynamic>? recommendations =
        resultData?['recommendations'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.results),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
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
                              height: 180,
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
                                            "Treatment",
                                            rec['treatment_method'] ?? 'N/A',
                                          ),
                                          _buildResultRow(
                                            "Info",
                                            rec['additional_info'] ?? 'N/A',
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
                  onPressed: () => _saveAndGoToHistory(context, ref),
                  icon: const Icon(Icons.download),
                  label: const Text("Download"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _saveAndGoToHistory(context, ref),
                  icon: const Icon(Icons.screenshot),
                  label: const Text("Save"),
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

  Future<void> _saveAndGoToHistory(BuildContext context, WidgetRef ref) async {
    try {
      final notifier = ref.read(historyRefreshProvider.notifier);

      final disease = resultData?['result'] as String? ?? "Unknown";
      final confidence = (resultData?['confidence'] as num?)?.toDouble() ?? 0.0;
      final limeImage = resultData?['lime_image'] as String? ?? '';
      final recommendations = resultData?['recommendations'] as List<dynamic>?;

      await notifier.saveHistory(
        imageUrl: limeImage,
        cropName: "Crop", // TODO: replace with selected crop
        disease: disease,
        confidence: confidence,
        recommendations: recommendations,
      );

      if (context.mounted) {
        context.pop(true);
        mainShellKey.currentState?.switchTab(2);
      }
    } catch (e) {
      _showErrorDialog(context, "Failed to save result: $e");
    }
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
