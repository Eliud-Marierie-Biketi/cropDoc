// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:crop_doc/core/state/history_refresh_notifier.dart';
import 'package:crop_doc/features/home/home_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final confidence = (resultData?['confidence'] as num?)?.toDouble() ?? 0.0;
    final limeImageUrl = resultData?['lime_image'] as String?;
    final savedImageUrl = resultData?['saved_image'] as String?;
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
            Expanded(
              child: SingleChildScrollView(
                child: Screenshot(
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
                        if (limeImageUrl != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CachedNetworkImage(
                              imageUrl: limeImageUrl,
                              height: 180,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 180,
                                color: Colors.grey[300],
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildResultRow("Disease", result),
                              _buildResultRow(
                                "Confidence",
                                "${(confidence).toStringAsFixed(2)}%",
                              ),
                              if (savedImageUrl != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: savedImageUrl,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 180,
                                      color: Colors.grey[300],
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
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
                                                rec['drug_name'] ?? 'N/A',
                                              ),
                                              _buildResultRow(
                                                "Info",
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

      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      await _screenshotController.captureAndSave(
        directory.path,
        fileName: fileName,
      );
      final filePath = '${directory.path}/$fileName';

      final disease = resultData?['result'] ?? "Unknown";
      final confidence = (resultData?['confidence'] as num?)?.toDouble() ?? 0.0;

      // Normalize recommendations
      final rawRecommendations = resultData?['recommendations'];
      List<Map<String, dynamic>> recommendations = [];

      if (rawRecommendations is List) {
        // ✅ Expected format: List<Map<String, dynamic>> (or List of maps with dynamic keys)
        recommendations = rawRecommendations
            .where((e) => e is Map)
            .map(
              (e) =>
                  Map<String, dynamic>.from((e as Map).cast<String, dynamic>()),
            )
            .toList();
      } else if (rawRecommendations is Map) {
        // ✅ Handle case where API mistakenly sends a single map
        recommendations = [
          Map<String, dynamic>.from(
            (rawRecommendations).cast<String, dynamic>(),
          ),
        ];
      } else if (rawRecommendations is String &&
          rawRecommendations.isNotEmpty) {
        // ⚠️ Handle case where backend sends a string description
        recommendations = [
          {
            "drug_name": rawRecommendations,
            "drug_administration_instructions": "",
          },
        ];
      } else {
        // 💤 Fallback if null or unexpected type
        recommendations = [
          {
            "drug_name": "No Recommendations",
            "drug_administration_instructions": "None available.",
          },
        ];
      }

      await notifier.saveHistory(
        imageUrl: filePath,
        cropName: "Maize",
        disease: disease,
        confidence: confidence,
        recommendations: recommendations,
      );

      if (context.mounted) {
        // Pop back to MainShell first if ResultsPage was pushed on top
        context.pop();

        // Switch to History tab
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
