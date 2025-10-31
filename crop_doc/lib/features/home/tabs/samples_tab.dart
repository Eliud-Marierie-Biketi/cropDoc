// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class SampleImage {
  final String name;
  final String url;

  SampleImage({required this.name, required this.url});

  factory SampleImage.fromJson(Map<String, dynamic> json) {
    return SampleImage(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

class SamplesPage extends HookWidget {
  const SamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading = useState(true);

    final sampleImages = useState<List<SampleImage>>([]);

    useEffect(() {
      Future(() async {
        try {
          final res = await http.get(Uri.parse('$baseUrl/api/sample-images/'));
          if (res.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(res.body);
            final List<dynamic> images = data['images'] ?? [];

            sampleImages.value = images
                .map((item) => SampleImage.fromJson(item))
                .toList();
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
            const SizedBox(height: 130),
            Row(
              children: [
                Icon(LucideIcons.image, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  t.sampleImages,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(LucideIcons.filter, size: 20),
                  onPressed: () {},
                  tooltip: 'Filter',
                ),
              ],
            ),
            const SizedBox(height: 16),
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

  Widget _buildImageCard(BuildContext context, SampleImage image, int index) {
    return Hero(
      tag: 'sample-$index',
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showImageDetails(context, image, index),
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: image.url,
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
                      Expanded(
                        child: Text(
                          image.name, // show actual name
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                      imageUrl: image.url,
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
        ],
      ),
    );
  }

  void _showImageDetails(BuildContext context, SampleImage image, int index) {
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
                            imageUrl: image.url,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Container(height: 200, color: Colors.grey[300]),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withAlpha(178),
                                  ],
                                ),
                              ),
                              child: Text(
                                image.name, // show actual name
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                  imageUrl: image.url,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Future<void> analyzeImage({
    required BuildContext context,
    required File imageFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/classify/');
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
    }
  }
}
