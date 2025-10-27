import 'dart:io';
import 'package:crop_doc/core/database/models/treatment_model.dart';
import 'package:crop_doc/core/providers/model_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Example assumes each item in history represents
/// a disease detection with stored imagePath or imageUrl

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  bool _isLoading = false;

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final syncService = ref.read(syncServiceProvider);

    try {
      // Example: sync treatments and user stats when visible
      final treatments = await syncService.fetchTreatments();
      final stats = await syncService.fetchUserStats();

      final treatmentNotifier = ref.read(treatmentsProvider.notifier);
      final statsNotifier = ref.read(userStatsProvider.notifier);

      await treatmentNotifier.replaceAll(treatments);
      await statsNotifier.replaceAll(stats);
    } catch (e) {
      debugPrint("⚠️ Sync failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final treatments = ref.watch(treatmentsProvider);

    return VisibilityDetector(
      key: const Key('history-tab'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.6) {
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadHistory,
                child: treatments.isEmpty
                    ? const Center(child: Text('No detection history found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: treatments.length,
                        itemBuilder: (context, index) {
                          final t = treatments[index];
                          return _buildHistoryCard(context, t);
                        },
                      ),
              ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, TreatmentModel treatment) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildNetworkImage(
            treatment.additionalInfo, // suppose this field holds an image URL
          ),
        ),
        title: Text(
          treatment.disease,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          treatment.treatmentMethod,
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        trailing: Icon(Icons.chevron_right, color: colorScheme.primary),
        onTap: () => _showDetailsDialog(context, treatment),
      ),
    );
  }

  Widget _buildNetworkImage(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.broken_image, size: 50);
    }
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    } else if (File(url).existsSync()) {
      return Image.file(
        File(url),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    }
    return const Icon(Icons.image_not_supported, size: 50);
  }

  void _showDetailsDialog(BuildContext context, TreatmentModel t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.disease),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Method: ${t.treatmentMethod}",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "Info: ${t.additionalInfo}",
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ],
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
}
