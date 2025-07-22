import 'dart:convert';
import 'dart:io';
import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/core/database/models/crops.dart';
import 'package:crop_doc/core/services/crop_service.dart';
import 'package:crop_doc/shared/widgets/go_to_dev_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:crop_doc/l10n/app_localizations.dart';

class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  // Custom green colors for light and dark modes
  static const Color _lightGreenBackground = Color(0xFFD0F0C0);

  // Strong green border color for both modes
  static const Color _strongGreenBorder = Color(0xFF1B5E20);

  // Safely get color with opacity; clamps opacity between 0 and 1
  Color _safeWithOpacity(Color color, double opacity) {
    final clamped = opacity.clamp(0.0, 1.0);
    // ignore: deprecated_member_use
    return color.withOpacity(clamped);
  }

  Color _cardBackground(Brightness brightness) => brightness == Brightness.light
      ? _lightGreenBackground
      : const Color.fromARGB(255, 119, 190, 106);

  Color _borderColor(Brightness brightness) =>
      const Color.fromARGB(255, 10, 50, 12);

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final imageFile = useState<File?>(null);
    final isProcessing = useState<bool>(false);
    final crops = useState<List<Crop>>([]);
    final selectedCrop = useState<Crop?>(null);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Load crops from API
    useEffect(() {
      Future.microtask(() async {
        try {
          final allCrops = await fetchCropsFromServer();
          crops.value = allCrops;
          if (allCrops.isNotEmpty) {
            selectedCrop.value = allCrops.first;
          }
        } catch (_) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Error"),
                content: const Text(
                  "Failed to load crops. Check your connection.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      });
      return null;
    }, []);

    Future<void> pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        controller.reset();
        controller.forward();
      }
    }

    Future<void> analyzeImage() async {
      if (imageFile.value == null || isProcessing.value) return;

      isProcessing.value = true;

      try {
        final uri = Uri.parse('$baseUrl/mock-classify/');
        final request = http.MultipartRequest('POST', uri);

        // Add the image file
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.value!.path),
        );

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final responseData = jsonDecode(responseBody);

          if (context.mounted) {
            context.push(
              '/results',
              extra: {'data': responseData, 'imageFile': imageFile.value},
            );
            debugPrint("✅ Response data: $responseData");
          }
        } else {
          throw Exception("Failed with status code ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("❌ analyzeImage error: $e");
        if (context.mounted) {
          await showDialog(
            // ✅ Use await here
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Error"),
              content: Text("Failed to analyze image: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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

    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? const Color(0xFFF1F9F0)
          : const Color(0xFF142B17),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- Crop dropdown ---
              GlassmorphicContainer(
                width: double.infinity,
                height: 80,
                borderRadius: 20,
                blur: 20,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _safeWithOpacity(_cardBackground(brightness), 0.9),
                    _safeWithOpacity(_cardBackground(brightness), 0.75),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _safeWithOpacity(_borderColor(brightness), 0.9),
                    _safeWithOpacity(_borderColor(brightness), 0.6),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.sprout,
                        color: brightness == Brightness.light
                            ? _borderColor(brightness)
                            : Colors.lightGreenAccent.shade400,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<Crop>(
                          value: selectedCrop.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: _cardBackground(brightness),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: brightness == Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                          ),
                          items: crops.value.map((crop) {
                            return DropdownMenuItem(
                              value: crop,
                              child: Text(
                                crop.name,
                                style: GoogleFonts.poppins(),
                              ),
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

              // --- Image preview / placeholder ---
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: imageFile.value != null
                    ? _buildImagePreview(
                        imageFile.value!,
                        controller,
                        brightness,
                      )
                    : _buildPlaceholder(
                        context,
                        t,
                        theme,
                        pickImage,
                        brightness,
                      ),
              ),

              const SizedBox(height: 24),

              // --- Camera & Gallery buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: LucideIcons.camera,
                    label: t.camera,
                    onPressed: () => pickImage(ImageSource.camera),
                    color: _borderColor(brightness),
                    brightness: brightness,
                  ),
                  _buildActionButton(
                    context: context,
                    icon: LucideIcons.image,
                    label: t.gallery,
                    onPressed: () => pickImage(ImageSource.gallery),
                    color: _borderColor(brightness),
                    brightness: brightness,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- Analyze button ---
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: imageFile.value == null || isProcessing.value
                          ? null
                          : analyzeImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _borderColor(brightness),
                        foregroundColor: brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.green.shade900,
                            width: 2,
                          ),
                        ),
                        elevation: 6,
                        shadowColor: _borderColor(brightness).withAlpha(120),
                      ),
                      child: isProcessing.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black,
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
                                Icon(LucideIcons.scan, size: 24),
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
                    duration: const Duration(milliseconds: 1500),
                    color: _safeWithOpacity(_borderColor(brightness), 0.35),
                    angle: imageFile.value != null && !isProcessing.value
                        ? 0.0
                        : null,
                  ),
              const SizedBox(height: 90),
              GoToDevToolsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(
    File imageFile,
    AnimationController controller,
    Brightness brightness,
  ) {
    return Hero(
          tag: 'scan-image',
          child: Container(
            decoration: BoxDecoration(
              color: _cardBackground(brightness),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _strongGreenBorder, width: 3),
              boxShadow: [
                BoxShadow(
                  color: brightness == Brightness.light
                      ? Colors.green.withAlpha(80)
                      : Colors.black.withAlpha(150),
                  blurRadius: 20,
                  spreadRadius: 3,
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
        .fadeIn(duration: const Duration(milliseconds: 500))
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildPlaceholder(
    BuildContext context,
    AppLocalizations t,
    ThemeData theme,
    Future<void> Function(ImageSource) pickImage,
    Brightness brightness,
  ) {
    final colorScheme = theme.colorScheme;

    return Center(
      child: GestureDetector(
        onTap: () => pickImage(ImageSource.camera),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBackground(brightness),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _strongGreenBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: brightness == Brightness.light
                    ? Colors.green.withAlpha(50)
                    : Colors.black.withAlpha(150),
                blurRadius: 12,
                offset: const Offset(0, 5),
                spreadRadius: 1,
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 280,
            borderRadius: 24,
            blur: 22,
            border: 0,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _safeWithOpacity(_cardBackground(brightness), 0.7),
                _safeWithOpacity(_cardBackground(brightness), 0.55),
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
                  color: colorScheme.onSurface.withAlpha(90),
                ),
                const SizedBox(height: 16),
                Text(
                  t.noImageSelected,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: colorScheme.onSurface.withAlpha(140),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.camera,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: brightness == Brightness.light
                        ? _strongGreenBorder
                        : Colors.lightGreenAccent.shade400,
                    fontWeight: FontWeight.w600,
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
    required Brightness brightness,
  }) {
    final isLight = brightness == Brightness.light;
    return SizedBox(
      width: 140,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight
              ? Colors.white
              : const Color.fromARGB(255, 10, 10, 10),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: const Color.fromARGB(255, 10, 10, 10),
              width: 2,
            ),
          ),
          elevation: 4,
          shadowColor: isLight
              ? Colors.black.withAlpha(25)
              : Colors.black.withAlpha(150),
        ),
      ),
    );
  }
}
