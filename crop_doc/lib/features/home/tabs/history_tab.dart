import 'dart:io';
import 'dart:convert';
import 'package:crop_doc/core/database/app_database.dart';
import 'package:crop_doc/shared/notifiers/history_refresh_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late AppDatabase db;
  late Future<List<HistoryData>> _historyFuture;

  @override
  void initState() {
    super.initState();
    db = getDatabaseInstance();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (HistoryRefreshNotifier.shouldRefresh) {
      HistoryRefreshNotifier.shouldRefresh = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHistory();
      });
    }
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = db.getAllHistory();
    });
  }

  Future<void> _navigateToDetection(BuildContext context) async {
    final shouldRefresh = await Navigator.pushNamed(context, '/detect');
    if (shouldRefresh == true) {
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('history-tab'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _loadHistory();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detection History'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadHistory,
              tooltip: 'Refresh',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToDetection(context),
          tooltip: 'New Detection',
          child: const Icon(Icons.add_a_photo),
        ),
        body: FutureBuilder<List<HistoryData>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final historyList = snapshot.data ?? [];

            if (historyList.isEmpty) {
              return const Center(child: Text('No detection history found.'));
            }

            return RefreshIndicator(
              onRefresh: () async => _loadHistory(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final item = historyList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.file(
                        File(item.imagePath),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                      title: Text(
                        '${item.cropName} - ${item.disease ?? "Unknown"}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confidence: ${_confidencePercent(item.confidence)}',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          Text(
                            'Date: ${item.timestamp.toLocal().toString().split('.').first}',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          if (item.recommendationsJson != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                _formatRecommendations(
                                  item.recommendationsJson!,
                                ),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        _showHistoryDialog(context, item);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _confidencePercent(String? raw) {
    final parsed = double.tryParse(raw ?? '');
    if (parsed == null) return "N/A";
    return "${(parsed * 100).toStringAsFixed(1)}%";
  }

  String _formatRecommendations(String jsonStr) {
    try {
      final List<dynamic> recs = jsonDecode(jsonStr);
      return recs.map((r) => '• ${r["drug_name"]}').join('\n');
    } catch (_) {
      return '';
    }
  }

  void _showHistoryDialog(BuildContext context, HistoryData item) {
    final List<dynamic> recommendations = item.recommendationsJson != null
        ? jsonDecode(item.recommendationsJson!)
        : [];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(item.imagePath),
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 16),
                _dialogRow("Result", item.disease ?? "Unknown"),
                _dialogRow("Confidence", _confidencePercent(item.confidence)),
                const SizedBox(height: 12),
                if (recommendations.isNotEmpty) ...[
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recommendations.length,
                    itemBuilder: (_, index) {
                      final rec = recommendations[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _dialogRow("Drug", rec['drug_name'] ?? 'N/A'),
                              _dialogRow(
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _dialogRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value, style: GoogleFonts.poppins())),
        ],
      ),
    );
  }
}
