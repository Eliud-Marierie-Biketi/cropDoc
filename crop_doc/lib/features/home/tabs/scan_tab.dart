import 'dart:io';
import 'package:crop_doc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:crop_doc/core/database/app_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ScanTab extends HookConsumerWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final db = ref.read(appDatabaseProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageFile = useState<File?>(null);
    final isProcessing = useState(false);
    final crops = useState<List<Crop>>([]);
    final selectedCrop = useState<Crop?>(null);
    final controller = useAnimationController();

    // Load crops from local database
    useEffect(() {
      Future.microtask(() async {
        final allCrops = await db.getCrops();
        crops.value = allCrops;
        if (allCrops.isNotEmpty) {
          selectedCrop.value = allCrops.first;
        }
      });
      return null;
    }, []);

    Future<void> pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        imageFile.value = File(picked.path);
        controller.reset();
        controller.forward();
      }
    }

    Future<void> analyzeImage() async {
      if (imageFile.value == null || isProcessing.value) return;

      isProcessing.value = true;

      try {
        // Simulate processing delay
        await Future.delayed(2.seconds);

        // Navigate to result screen
        if (context.mounted) {
          Navigator.of(context).pushNamed(
            '/results',
            arguments: {'image': imageFile.value!, 'crop': selectedCrop.value},
          );
        }
      } finally {
        isProcessing.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Crop selection card
          GlassmorphicContainer(
            width: double.infinity,
            height: 80,
            borderRadius: 20,
            blur: 20,
            border: 1,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface.withAlpha(153),
                colorScheme.surface.withAlpha(77),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withAlpha(128), Colors.white.withAlpha(51)],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.sprout,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<Crop>(
                      value: selectedCrop.value,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                      items: crops.value.map((crop) {
                        return DropdownMenuItem(
                          value: crop,
                          child: Text(crop.name, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (value) => selectedCrop.value = value,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Image preview section
          AnimatedSwitcher(
            duration: 500.ms,
            child: imageFile.value != null
                ? _buildImagePreview(imageFile.value!, controller)
                : _buildPlaceholder(context, t, theme, pickImage),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context: context,
                icon: LucideIcons.camera,
                label: t.camera,
                onPressed: () => pickImage(ImageSource.camera),
                color: colorScheme.primary,
              ),
              _buildActionButton(
                context: context,
                icon: LucideIcons.image,
                label: t.gallery,
                onPressed: () => pickImage(ImageSource.gallery),
                color: colorScheme.secondary,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Analyze button
          SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: imageFile.value == null || isProcessing.value
                      ? null
                      : analyzeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: colorScheme.primary.withAlpha(77),
                  ),
                  child: isProcessing.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              t.processing,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.scan, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              t.analyze,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 1500.ms,
                color: colorScheme.primary.withAlpha(51),
                angle: (imageFile.value != null && !isProcessing.value)
                    ? 0.0
                    : null,
              ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(File imageFile, AnimationController controller) {
    return Hero(
          tag: 'scan-image',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                height: 280,
                width: double.infinity,
              ),
            ),
          ),
        )
        .animate(controller: controller)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildPlaceholder(
    BuildContext context,
    AppLocalizations t,
    ThemeData theme,
    Future<void> Function(ImageSource) pickImage,
  ) {
    final colorScheme = theme.colorScheme;

    return Center(
      child: GestureDetector(
        onTap: () => pickImage(ImageSource.camera), // 📷 Open camera on tap
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.green, width: 2),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 280,
            borderRadius: 24,
            blur: 20,
            border: 0,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface.withAlpha(153),
                colorScheme.surface.withAlpha(77),
              ],
            ),
            borderGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.transparent, Colors.transparent],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.image,
                  size: 64,
                  color: colorScheme.onSurface.withAlpha(77),
                ),
                const SizedBox(height: 16),
                Text(
                  t.noImageSelected,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: colorScheme.onSurface.withAlpha(128),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.camera, // Optional label
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: 140,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          shadowColor: Colors.black.withAlpha(25),
        ),
      ),
    );
  }
}
