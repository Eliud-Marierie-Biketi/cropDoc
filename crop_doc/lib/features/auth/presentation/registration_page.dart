import 'dart:math' as math;
import 'package:crop_doc/core/providers/auth_provider.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  final _focusNode = FocusNode();

  String username = '';
  String country = 'Kenya';
  String? county;
  String role = 'farmer';
  bool consent = false;
  bool _isSubmitting = false;

  final List<String> roleCodes = ['farmer', 'extension_officer', 'researcher'];

  final List<String> counties = [
    "Mombasa",
    "Kwale",
    "Kilifi",
    "Tana River",
    "Lamu",
    "Taita",
    "Garissa",
    "Wajir",
    "Mandera",
    "Marsabit",
    "Isiolo",
    "Meru",
    "Tharaka-Nithi",
    "Embu",
    "Kitui",
    "Machakos",
    "Makueni",
    "Nyandarua",
    "Nyeri",
    "Kirinyaga",
    "Murang'a",
    "Kiambu",
    "Turkana",
    "West Pokot",
    "Samburu",
    "Trans Nzoia",
    "Uasin Gishu",
    "Elgeyo/Marakwet",
    "Nandi",
    "Baringo",
    "Laikipia",
    "Nakuru",
    "Narok",
    "Kajiado",
    "Kericho",
    "Bomet",
    "Kakamega",
    "Vihiga",
    "Bungoma",
    "Busia",
    "Siaya",
    "Kisumu",
    "Homa Bay",
    "Migori",
    "Kisii",
    "Nyamira",
    "Nairobi",
    "Diaspora",
  ];

  @override
  void initState() {
    super.initState();

    // Sort counties alphabetically
    counties.sort();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String roleToLabel(String code, AppLocalizations t) {
    switch (code) {
      case 'farmer':
        return t.farmer;
      case 'extension_officer':
        return t.extensionOfficer;
      case 'researcher':
        return t.researcher;
      default:
        return code;
    }
  }

  String labelToRole(String label, AppLocalizations t) {
    if (label == t.farmer) return 'Farmer';
    if (label == t.extensionOfficer) return 'Extension Officer';
    if (label == t.researcher) return 'Researcher';
    return label;
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context)!;

    // Validate form + consent
    if (!_formKey.currentState!.validate() || !consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.completeFormMessage),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Capture notifier BEFORE await
      final authNotifier = ref.read(authProvider.notifier);

      // Await register (completes on success, throws on failure)
      await authNotifier.register(
        name: username,
        email: '$username@cropdoc.com',
        country: country,
        county: country == "Kenya" ? county ?? '' : '',
        role: role,
      );

      if (!mounted) return;

      // registration completed successfully
      context.go('/scan');
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ Registration failed: $e\n$stack");
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text("Could not complete registration.\n$e"),
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
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                0.5 + 0.2 * math.sin(_animationController.value * 3.14),
                0.5 + 0.2 * math.cos(_animationController.value * 3.14),
              ),
              radius: 1.2,
              colors: [
                Colors.lightBlue.shade100.withAlpha(204),
                Colors.green.shade100.withAlpha(204),
                Colors.yellow.shade100.withAlpha(204),
                Colors.orange.shade100.withAlpha(204),
              ],
              stops: const [25, 0.4, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showCounty = country == "Kenya";

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withAlpha(25),
                    ),
                    child: Icon(
                      LucideIcons.userPlus,
                      size: 48,
                      color: colorScheme.primary,
                    ),
                  ).animate().scale(delay: 200.ms),

                  const SizedBox(height: 16),
                  Text(
                    t.registerTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  Text(
                    t.registerSubtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.onSurface.withAlpha(178),
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 32),
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 600,
                    borderRadius: 24,
                    blur: 20,
                    border: 1,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(77),
                        Colors.white.withAlpha(25),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(127),
                        Colors.white.withAlpha(51),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              context: context,
                              label: t.nameLabel,
                              icon: LucideIcons.user,
                              validator: (val) => (val == null || val.isEmpty)
                                  ? t.nameRequired
                                  : null,
                              onChanged: (val) =>
                                  setState(() => username = val),
                              value: username,
                            ),
                            const SizedBox(height: 20),
                            _buildDropdown(
                              context: context,
                              label: t.countryLabel,
                              icon: LucideIcons.globe,
                              value: country,
                              items: ["Kenya", t.otherLabel],
                              onChanged: (val) =>
                                  setState(() => country = val!),
                            ),
                            if (showCounty) ...[
                              const SizedBox(height: 20),
                              _buildDropdown(
                                context: context,
                                label: t.countyLabel,
                                icon: LucideIcons.mapPin,
                                value: county,
                                items: counties,
                                validator: (val) => showCounty && val == null
                                    ? t.countyRequired
                                    : null,
                                onChanged: (val) =>
                                    setState(() => county = val!),
                              ),
                            ],
                            const SizedBox(height: 20),
                            _buildDropdown(
                              context: context,
                              label: t.roleLabel,
                              icon: LucideIcons.badge,
                              value: roleToLabel(role, t),
                              items: roleCodes
                                  .map((code) => roleToLabel(code, t))
                                  .toList(),
                              onChanged: (label) {
                                if (label != null) {
                                  setState(() => role = labelToRole(label, t));
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            CheckboxListTile(
                              value: consent,
                              onChanged: (val) =>
                                  setState(() => consent = val ?? false),
                              controlAffinity: ListTileControlAffinity.leading,

                              // 👇 Title now has preview text + More button
                              title: GestureDetector(
                                onTap: () =>
                                    _showConsentDialog(context, t.consentText),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: t.consentText.length > 80
                                            ? t.consentText.substring(0, 80) +
                                                  "..."
                                            : t.consentText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " More",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: _isSubmitting
                                    ? const SizedBox()
                                    : const Icon(
                                        LucideIcons.userPlus,
                                        size: 20,
                                      ),
                                label: _isSubmitting
                                    ? CircularProgressIndicator(
                                        color: colorScheme.onPrimary,
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        t.registerButton,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  shadowColor: colorScheme.primary.withAlpha(
                                    77,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String) onChanged,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: colorScheme.onSurface.withAlpha(204),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isFocused ? colorScheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode,
                    initialValue: value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: validator,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: colorScheme.onSurface.withAlpha(204),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: value,
                    isExpanded: true,
                    icon: Icon(
                      LucideIcons.chevronDown,
                      size: 20,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                    items: items
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: onChanged,
                    validator: validator,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showConsentDialog(BuildContext context, String fullText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Full Consent Text",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Text(fullText, style: GoogleFonts.poppins(fontSize: 14)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}

// Add this to your AppLocalizations.dart file
extension RegistrationLocalization on AppLocalizations {
  String get registerSubtitle => 'Create your account to get started';
  String get nameRequired => 'Name is required';
  String get countyRequired => 'County is required';
}
