// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:crop_doc/shared/widgets/scanning_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class SamplesPage extends HookWidget {
  const SamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading = useState(true);

    final sampleImages = useState<List<String>>([]);

    useEffect(() {
      Future(() async {
        try {
          final res = await http.get(Uri.parse('$baseUrl/sample-images/'));
          if (res.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(res.body);
            final List<String> imageUrls = List<String>.from(data['images']);
            sampleImages.value = imageUrls;
          }
        } catch (e) {
          debugPrint('Error loading samples: $e');
        } finally {
          isLoading.value = false;
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 130), // <-- This line added
            // Header
            Row(
              children: [
                Icon(LucideIcons.image, color: colorScheme.primary, size: 24),
                Text(
                  t.sampleImages,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.filter, size: 20),
                  onPressed: () {},
                  tooltip: 'Filter',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid
            Expanded(
              child: isLoading.value
                  ? _buildShimmerGrid()
                  : sampleImages.value.isEmpty
                  ? _buildEmptyState()
                  : MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: sampleImages.value.length,
                      itemBuilder: (context, index) => _buildImageCard(
                        context,
                        sampleImages.value[index],
                        index,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String imagePath, int index) {
    return Hero(
      tag: 'sample-$index',
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showImageDetails(context, imagePath, index),
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                placeholder: (context, url) =>
                    Container(height: 200, color: Colors.grey[300]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(178)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.image, size: 16, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(
                        'Sample ${index + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(LucideIcons.scan, size: 20),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => simulateScanFromUrl(
                      context: context,
                      imageUrl: imagePath,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          height: 200,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.imageOff, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No sample images',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add samples to see them here',
            style: GoogleFonts.poppins(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(LucideIcons.plus, size: 16),
            label: Text('Add Sample'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDetails(BuildContext context, String imagePath, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'sample-$index',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: imagePath,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Container(height: 200, color: Colors.grey[300]),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),

                          // Scanning effect
                          const Positioned.fill(child: ScanningOverlay()),

                          // Gradient and icon bar at the bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withAlpha(178),
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.image,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sample ${index + 1}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Scan button
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(25),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(LucideIcons.scan, size: 20),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () => simulateScanFromUrl(
                                  context: context,
                                  imageUrl: imagePath,
                                ),
                              ),
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
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                await simulateScanFromUrl(
                                  context: context,
                                  imageUrl: imagePath,
                                );
                                if (context.mounted) Navigator.pop(context);
                              },
                        icon: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(LucideIcons.scan, size: 16),
                        label: Text(isLoading ? 'Scanning...' : 'Scan This'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> simulateScanFromUrl({
    required BuildContext context,
    required String imageUrl,
  }) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/sample_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await analyzeImage(context: context, imageFile: file);
      } else {
        throw Exception("Failed to download image: ${response.statusCode}");
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to process sample image: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  void simulateScan({
    required BuildContext context,
    required File imageFile,
  }) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Analyzing sample...', style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );

    try {
      final uri = Uri.parse('$baseUrl/mock-classify/');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // replace with your actual field name
          imageFile.path,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      context.pop(); // Close loading dialog

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);

        context.push('/results', extra: responseData);
      } else {
        _showErrorDialog(
          context,
          'Server responded with ${response.statusCode}',
        );
      }
    } catch (e) {
      context.pop(); // Ensure dialog is closed on error
      _showErrorDialog(context, 'Error analyzing image: $e');
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

  Future<void> analyzeImage({
    required BuildContext context,
    required File imageFile,
  }) async {
    final isProcessing = ValueNotifier(true);

    try {
      final uri = Uri.parse('$baseUrl/mock-classify/');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);

        if (context.mounted) {
          context.push(
            '/results',
            extra: {'data': responseData, 'imageFile': imageFile},
          );
        }
      } else {
        throw Exception("Failed with status code ${response.statusCode}");
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to analyze image: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } finally {
      isProcessing.value = false;
    }
  }
}
