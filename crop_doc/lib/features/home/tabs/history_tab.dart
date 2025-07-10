import 'dart:io';
import 'dart:convert';
import 'package:crop_doc/core/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _loadHistory() {
    setState(() {
      _historyFuture = db.getAllHistory();
    });
  }

  Future<void> _navigateToDetection(BuildContext context) async {
    final shouldRefresh = await Navigator.pushNamed(
      context,
      '/detect',
    ); // or context.push('/detect')
    if (shouldRefresh == true) {
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          final historyList = (snapshot.data ?? []).take(5).toList();

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
                          'Confidence: ${item.confidence ?? "N/A"}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        Text(
                          'Date: ${item.timestamp.toLocal()}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        if (item.recommendationsJson != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              _formatRecommendations(item.recommendationsJson!),
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // Optional: Navigate to detailed view
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatRecommendations(String jsonStr) {
    try {
      final List<dynamic> recs = jsonDecode(jsonStr);
      return recs.map((r) => '• ${r["drug_name"]}').join('\n');
    } catch (_) {
      return '';
    }
  }
}
