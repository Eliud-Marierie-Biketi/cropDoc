import 'package:crop_doc/core/database/models/user_model.dart';
import 'package:crop_doc/core/providers/model_providers.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  String roleToLabel(String role, AppLocalizations t) {
    switch (role) {
      case 'Farmer':
        return t.farmer;
      case 'Extension Officer':
        return t.extensionOfficer;
      case 'Researcher':
        return t.researcher;
      default:
        return role;
    }
  }

  String labelToRole(String label, AppLocalizations t) {
    if (label == t.farmer) return 'Farmer';
    if (label == t.extensionOfficer) return 'Extension Officer';
    if (label == t.researcher) return 'Researcher';
    return label;
  }

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear all data?"),
        content: const Text(
          "This will delete all local app data. Are you sure?",
        ),
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

    if (confirm == true) {
      // Delete local Hive data
      await ref.read(userBoxProvider).clear();
      if (context.mounted) context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // 👇 Watch user list (in most cases there’s only one user entry)
    final userList = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final user = userList.isNotEmpty ? userList.first : null;

    final name = useState(user?.name ?? '');
    final country = useState(user?.country ?? 'Kenya');
    final county = useState(user?.county ?? 'Nairobi');
    final isSaving = useState(false);

    Future<void> saveProfile() async {
      if (user == null) return;
      isSaving.value = true;

      final updatedUser = UserModel(
        id: user.id,
        name: name.value,
        email: user.email,
        country: country.value,
        county: county.value,
        isSynced: false,
      );

      // Update Hive
      final index = ref.read(userBoxProvider).values.toList().indexOf(user);
      userNotifier.updateItem(index, updatedUser);
      isSaving.value = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profileDetails),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

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

    return Scaffold(
      appBar: AppBar(title: Text(t.profileDetails), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -- HEADER
            GlassmorphicContainer(
              width: double.infinity,
              height: 180,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.center,
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
                colors: [
                  Colors.white.withAlpha(102),
                  Colors.white.withAlpha(51),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name.value,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // -- FORM
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: colorScheme.outline.withAlpha(153),
                  width: 1,
                ),
              ),
              color: colorScheme.surface,
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
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildProfileField(
                      context: context,
                      icon: LucideIcons.user,
                      label: t.nameLabel,
                      value: name.value,
                      onChanged: (val) => name.value = val,
                      isEditable: true,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileField(
                      context: context,
                      icon: LucideIcons.globe,
                      label: t.countryLabel,
                      value: country.value,
                      isEditable: false,
                    ),
                    if (country.value == 'Kenya') ...[
                      const SizedBox(height: 16),
                      _buildProfileField(
                        context: context,
                        icon: LucideIcons.mapPin,
                        label: t.countyLabel,
                        value: county.value,
                        isEditable: false,
                      ),
                    ],
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.badge,
                          color: colorScheme.onSurface.withAlpha(153),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          t.roleLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: colorScheme.onSurface.withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving.value ? null : saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isSaving.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
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
                      color: colorScheme.secondary.withAlpha(51),
                      angle: 0.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => _clearData(context, ref),
              icon: const Icon(Icons.logout),
              label: Text(t.logoutButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
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
            Icon(icon, color: colorScheme.onSurface.withAlpha(153), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(204),
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
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  onChanged: onChanged,
                )
              : Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
        ),
      ],
    );
  }
}
