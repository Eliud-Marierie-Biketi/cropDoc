import 'dart:convert';
import 'dart:math' as Math;

import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../core/database/app_database.dart';

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
  String role = 'Farmer';
  bool consent = false;
  bool _isSubmitting = false;

  final List<String> roleCodes = ['Farmer', 'Extension Officer', 'Researcher'];

  final List<String> counties = [
    "Mombasa County (01)",
    "Kwale County (02)",
    "Kilifi County (03)",
    "Tana River County (04)",
    "Lamu County (05)",
    "Taita/Taveta County (06)",
    "Garissa County (07)",
    "Wajir County (08)",
    "Mandera County (09)",
    "Marsabit County (10)",
    "Isiolo County (11)",
    "Meru County (12)",
    "Tharaka-Nithi County (13)",
    "Embu County (14)",
    "Kitui County (15)",
    "Machakos County (16)",
    "Makueni County (17)",
    "Nyandarua County (18)",
    "Nyeri County (19)",
    "Kirinyaga County (20)",
    "Murang'a County (21)",
    "Kiambu County (22)",
    "Turkana County (23)",
    "West Pokot County (24)",
    "Samburu County (25)",
    "Trans Nzoia County (26)",
    "Uasin Gishu County (27)",
    "Elgeyo/Marakwet County (28)",
    "Nandi County (29)",
    "Baringo County (30)",
    "Laikipia County (31)",
    "Nakuru County (32)",
    "Narok County (33)",
    "Kajiado County (34)",
    "Kericho County (35)",
    "Bomet County (36)",
    "Kakamega County (37)",
    "Vihiga County (38)",
    "Bungoma County (39)",
    "Busia County (40)",
    "Siaya County (41)",
    "Kisumu County (42)",
    "Homa Bay County (43)",
    "Migori County (44)",
    "Kisii County (45)",
    "Nyamira County (46)",
    "Nairobi City County (47)",
    "Diaspora",
  ];

  @override
  void initState() {
    super.initState();
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
      case 'Farmer':
        return t.farmer;
      case 'Extension Officer':
        return t.extensionOfficer;
      case 'Researcher':
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
    if (!_formKey.currentState!.validate() || !consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.completeFormMessage),
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
      final db = getDatabaseInstance();
      bool isSynced = false;
      // ignore: unused_local_variable
      String? serverId;

      // --- Try registering with backend ---
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/users/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'country': country,
            'county': country == "Kenya" ? county : null,
            'role': role,
            'consent': true,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          serverId = data['user_id']; // 👈 This is saved as server_id
          isSynced = true;
        }
      } catch (e) {
        print("⚠️ Server unreachable, will register offline: $e");
      }

      // --- Save user locally ---
      await db.insertUser(
        UsersCompanion.insert(
          username: Value(username),
          country: country,
          county: Value(country == "Kenya" ? county : null),
          role: role,
          consent: true,
          isSynced: Value(isSynced),
          serverId: Value(null),
        ),
      );

      if (!mounted) return;
      context.go('/scan');
    } catch (e, stack) {
      if (kDebugMode) {
        print("❌ Local save failed: $e\n$stack");
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Could not complete registration."),
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
                0.5 + 0.2 * Math.sin(_animationController.value * 3.14),
                0.5 + 0.2 * Math.cos(_animationController.value * 3.14),
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
          // Animated background
          _buildBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header with icon
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

                  // Form in glass card
                  GlassmorphicContainer(
                    width: double.infinity,
                    height:
                        600, // Set to null to allow the container to size itself automatically, or provide a fixed value like 600
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
                            // Name field
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
                            ).animate(delay: 500.ms).slideX(begin: 0.2, end: 0),

                            const SizedBox(height: 20),

                            // Country dropdown
                            _buildDropdown(
                              context: context,
                              label: t.countryLabel,
                              icon: LucideIcons.globe,
                              value: country,
                              items: ["Kenya", t.otherLabel],
                              onChanged: (val) =>
                                  setState(() => country = val!),
                            ).animate(delay: 600.ms).slideX(begin: 0.2, end: 0),

                            if (showCounty) ...[
                              const SizedBox(height: 20),
                              // County dropdown
                              _buildDropdown(
                                    context: context,
                                    label: t.countyLabel,
                                    icon: LucideIcons.mapPin,
                                    value: county,
                                    items: counties,
                                    validator: (val) =>
                                        showCounty && val == null
                                        ? t.countyRequired
                                        : null,
                                    onChanged: (val) =>
                                        setState(() => county = val!),
                                  )
                                  .animate(delay: 700.ms)
                                  .slideX(begin: 0.2, end: 0),
                            ],

                            const SizedBox(height: 20),

                            // Role dropdown
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
                            ).animate(delay: 800.ms).slideX(begin: 0.2, end: 0),

                            const SizedBox(height: 20),

                            // Consent checkbox
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withAlpha(77),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CheckboxListTile(
                                value: consent,
                                onChanged: (val) =>
                                    setState(() => consent = val ?? false),
                                title: Text(
                                  t.consentText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ).animate(delay: 900.ms).fadeIn(),

                            const SizedBox(height: 32),

                            // Submit button
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
                                    onPressed: _isSubmitting ? null : _submit,
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
                                      shadowColor: colorScheme.primary
                                          .withAlpha(77),
                                    ),
                                  ),
                                )
                                .animate(delay: 1000.ms)
                                .fadeIn()
                                .shimmer(
                                  delay: 1100.ms,
                                  duration: 1500.ms,
                                  color: colorScheme.secondary.withAlpha(25),
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
}

// Add this to your AppLocalizations.dart file
extension RegistrationLocalization on AppLocalizations {
  String get registerSubtitle => 'Create your account to get started';
  String get nameRequired => 'Name is required';
  String get countyRequired => 'County is required';
}
