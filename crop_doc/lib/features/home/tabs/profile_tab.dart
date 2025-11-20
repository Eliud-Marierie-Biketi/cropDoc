import 'package:crop_doc/core/constants/app_strings.dart';
import 'package:crop_doc/core/providers/model_providers.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  // Convert raw DB role to localized label
  String roleToLabel(String role, AppLocalizations t) {
    role = role.trim().toLowerCase();
    if (role == "farmer") return t.farmer;
    if (role == "extension officer") return t.extensionOfficer;
    if (role == "researcher") return t.researcher;
    return t.farmer; // default
  }

  // Convert localized label -> raw DB role
  String labelToRole(String label, AppLocalizations t) {
    if (label == t.farmer) return "farmer";
    if (label == t.extensionOfficer) return "extension officer";
    if (label == t.researcher) return "researcher";
    return "farmer";
  }

  // Normalize DB value (in case future users store weird formats)
  String normalizeRole(String? rawRole) {
    if (rawRole == null) return "farmer";
    rawRole = rawRole.trim().toLowerCase();

    if (rawRole.contains("farmer")) return "farmer";
    if (rawRole.contains("extension")) return "extension officer";
    if (rawRole.contains("research")) return "researcher";

    return "farmer";
  }

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear all data?"),
        content: const Text("This will delete your data. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Clear Data"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final userList = ref.read(userProvider);
    final user = userList.isNotEmpty ? userList.first : null;

    if (user != null) {
      final url = Uri.parse("$baseUrl/api/users/${user.id}/");

      try {
        final response = await http.delete(url);
        debugPrint("Delete status: ${response.statusCode}");
      } catch (e) {
        debugPrint("Delete error: $e");
      }
    }

    await ref.read(userBoxProvider).clear();
    if (context.mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final userList = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);
    final user = userList.isNotEmpty ? userList.first : null;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.profileDetails)),
        body: Center(
          child: Text(
            "No profile found. Please register.",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    // ---- Normalize then convert to UI label
    final normalized = normalizeRole(user.role);
    final roleLabel = useState(roleToLabel(normalized, t));

    final name = useState(user.name);
    final country = useState(user.country);
    final county = useState(user.county);
    final isSaving = useState(false);

    Future<void> saveProfile() async {
      isSaving.value = true;

      final updatedUser = user.copyWith(
        name: name.value,
        country: country.value,
        county: county.value,
        role: labelToRole(roleLabel.value, t),
        isSynced: false,
      );

      final box = ref.read(userBoxProvider);
      final index = box.values.toList().indexOf(user);
      userNotifier.updateItem(index, updatedUser);

      isSaving.value = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profileSaved),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.profileDetails), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header Profile Card
            GlassmorphicContainer(
              width: double.infinity,
              height: 180,
              borderRadius: 20,
              blur: 20,
              border: 1,
              alignment: Alignment.center,
              linearGradient: LinearGradient(
                colors: [
                  colorScheme.surface.withAlpha(150),
                  colorScheme.surface.withAlpha(80),
                ],
              ),
              borderGradient: LinearGradient(
                colors: [
                  Colors.white.withAlpha(120),
                  Colors.white.withAlpha(40),
                ],
              ),
              child: Center(
                child: Text(
                  name.value,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Info Card
            Card(
              elevation: 0,
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: colorScheme.outline.withAlpha(150)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.profileDetails,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Name
                    _buildProfileField(
                      context: context,
                      icon: LucideIcons.user,
                      label: t.nameLabel,
                      value: name.value,
                      isEditable: true,
                      onChanged: (v) => name.value = v,
                    ),

                    const SizedBox(height: 16),

                    /// Country
                    _buildDropdownField(
                      context: context,
                      icon: LucideIcons.globe,
                      label: t.countryLabel,
                      value: country.value,
                      options: const ["Kenya", "Other"],
                      onChanged: (v) => country.value = v,
                    ),

                    const SizedBox(height: 16),

                    /// County (if Kenya)
                    if (country.value == "Kenya")
                      _buildDropdownField(
                        context: context,
                        icon: LucideIcons.mapPin,
                        label: t.countyLabel,
                        value: county.value,
                        options: _kenyaCounties,
                        onChanged: (v) => county.value = v,
                      ),

                    const SizedBox(height: 24),

                    /// Role — FIXED
                    _buildDropdownField(
                      context: context,
                      icon: LucideIcons.badge,
                      label: t.roleLabel,

                      // must match one of localized options
                      value: roleLabel.value,

                      options: [t.farmer, t.extensionOfficer, t.researcher],

                      onChanged: (newLabel) {
                        roleLabel.value = newLabel;

                        final box = ref.read(userBoxProvider);
                        final index = box.values.toList().indexOf(user);

                        // Save raw role (lowercase)
                        userNotifier.updateItem(
                          index,
                          user.copyWith(
                            role: labelToRole(newLabel, t),
                            isSynced: false,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    /// Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving.value ? null : saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: isSaving.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.save, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    t.saveProfile,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ).animate().shimmer(
                      duration: 1500.ms,
                      color: colorScheme.secondary.withAlpha(50),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),

            /// Logout / Clear Data
            ElevatedButton.icon(
              onPressed: () => _clearData(context, ref),
              icon: const Icon(Icons.logout),
              label: Text(t.logoutButton),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kenya Counties
const _kenyaCounties = [
  "Baringo",
  "Bomet",
  "Bungoma",
  "Busia",
  "Diaspora",
  "Elgeyo/Marakwet",
  "Embu",
  "Garissa",
  "Homa Bay",
  "Isiolo",
  "Kajiado",
  "Kakamega",
  "Kericho",
  "Kiambu",
  "Kilifi",
  "Kirinyaga",
  "Kisii",
  "Kisumu",
  "Kitui",
  "Kwale",
  "Laikipia",
  "Lamu",
  "Machakos",
  "Makueni",
  "Mandera",
  "Marsabit",
  "Meru",
  "Migori",
  "Mombasa",
  "Murang'a",
  "Nairobi",
  "Nakuru",
  "Nandi",
  "Narok",
  "Nyamira",
  "Nyandarua",
  "Nyeri",
  "Samburu",
  "Siaya",
  "Taita",
  "Tana River",
  "Tharaka-Nithi",
  "Trans Nzoia",
  "Turkana",
  "Uasin Gishu",
  "Vihiga",
  "Wajir",
  "West Pokot",
];

Widget _buildProfileField({
  required BuildContext context,
  required IconData icon,
  required String label,
  required String value,
  required bool isEditable,
  ValueChanged<String>? onChanged,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: colorScheme.onSurface.withAlpha(150), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(200),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isEditable
            ? TextFormField(
                initialValue: value,
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: const InputDecoration.collapsed(hintText: ''),
                onChanged: onChanged,
              )
            : Text(value, style: GoogleFonts.poppins(fontSize: 16)),
      ),
    ],
  );
}

/// FIXED Dropdown Widget
Widget _buildDropdownField({
  required BuildContext context,
  required IconData icon,
  required String label,
  required String value,
  required List<String> options,
  required ValueChanged<String> onChanged,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  // Prevent crash if value not found
  final safeValue = options.contains(value) ? value : null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: colorScheme.onSurface.withAlpha(150), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(200),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          value: safeValue,
          decoration: const InputDecoration(border: InputBorder.none),
          items: options
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: GoogleFonts.poppins(fontSize: 16)),
                ),
              )
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    ],
  );
}
