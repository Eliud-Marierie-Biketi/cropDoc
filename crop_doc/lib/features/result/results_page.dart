// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:crop_doc/core/state/history_refresh_notifier.dart';
import 'package:crop_doc/features/home/home_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
    // ignore: unused_local_variable
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
                        // --- Two images side-by-side ---
                        if (imageFile != null || limeImageUrl != null) ...[
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // User Image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: imageFile != null
                                      ? Image.file(
                                          imageFile!,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 120,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Lime Image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: limeImageUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: limeImageUrl,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                height: 120,
                                                color: Colors.grey[300],
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : Container(
                                          height: 120,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                        ],
                        // --- Result Details ---
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
                              SizedBox(height: 12),
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

                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: recommendations.length,
                                  itemBuilder: (_, index) {
                                    final rec = recommendations[index];

                                    final symptoms =
                                        rec["symptoms"] ??
                                        "No symptoms provided";
                                    final treatment = rec["drug_name"] ?? "N/A";
                                    final instructions =
                                        rec["instructions"] ??
                                        rec["drug_administration_instructions"] ??
                                        "No instructions";
                                    final prevention =
                                        rec["prevention"] ??
                                        "No prevention info";

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildSectionHeader("Symptoms"),
                                            Text(
                                              symptoms,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 10),

                                            _buildSectionHeader("Treatment"),
                                            Text(
                                              treatment,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 6),

                                            _buildSectionHeader("Instructions"),
                                            Text(
                                              instructions,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 10),

                                            _buildSectionHeader("Prevention"),
                                            Text(
                                              prevention,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                  onPressed: () => _downloadPdf(context),
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

  Future<void> _downloadPdf(BuildContext context) async {
    final file = await _generatePdf(context);
    if (file == null) return;

    await Printing.sharePdf(
      bytes: await file.readAsBytes(),
      filename: file.path.split('/').last,
    );
  }

  Future<File?> _generatePdf(BuildContext context) async {
    try {
      final pdf = pw.Document();

      final imageBytes = imageFile != null
          ? await imageFile!.readAsBytes()
          : null;

      final result = resultData?['result'] ?? "Unknown";
      final confidence = (resultData?['confidence'] as num?)?.toDouble() ?? 0.0;

      final List<dynamic> recommendations =
          resultData?['recommendations'] ?? [];

      final date = DateTime.now();
      final formattedDate =
          "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";

      pdf.addPage(
        pw.Page(
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Crop Disease Diagnosis Report",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text("Generated on: $formattedDate"),
                pw.SizedBox(height: 20),

                if (imageBytes != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(imageBytes),
                      width: 300,
                      height: 200,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                pw.SizedBox(height: 20),

                pw.Text("Disease: $result", style: pw.TextStyle(fontSize: 16)),
                pw.Text("Confidence: ${confidence.toStringAsFixed(2)}%"),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Recommendations:",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),

                if (recommendations.isEmpty)
                  pw.Text("No treatment needed.")
                else
                  ...recommendations.map((rec) {
                    final symptoms = rec["symptoms"] ?? "No symptoms provided";
                    final treatmentName = rec["drug_name"] ?? "N/A";
                    final instructions =
                        rec["instructions"] ??
                        rec["drug_administration_instructions"] ??
                        "No instructions";
                    final prevention =
                        rec["prevention"] ?? "No prevention info";

                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 16),
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // --- Symptoms ---
                          pw.Text(
                            "Symptoms:",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(symptoms),
                          pw.SizedBox(height: 10),

                          // --- Treatment ---
                          pw.Text(
                            "Treatment:",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(treatmentName),
                          pw.SizedBox(height: 4),
                          pw.Text(instructions),
                          pw.SizedBox(height: 10),

                          // --- Prevention ---
                          pw.Text(
                            "Prevention:",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(prevention),
                        ],
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File(
        "${output.path}/result_${DateTime.now().millisecondsSinceEpoch}.pdf",
      );
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      _showErrorDialog(context, "Failed to generate PDF: $e");
      return null;
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
        date: DateTime.now().toIso8601String(), // <--- Add this
      );

      if (context.mounted) {
        // Pop back to MainShell first if ResultsPage was pushed on top
        context.pop();

        // Switch to History tab
        mainShellKey.currentState?.switchTab(3);
      }
    } catch (e) {
      _showErrorDialog(context, "Failed to save result: $e");
    }
  }
}

Widget _buildSectionHeader(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.teal[800],
    ),
  );
}
