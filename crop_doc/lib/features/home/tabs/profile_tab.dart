import 'package:crop_doc/core/database/app_database.dart';
import 'package:crop_doc/core/database/app_database_provider.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ProfileTab extends HookConsumerWidget {
  const ProfileTab({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final db = ref.read(appDatabaseProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Hook states
    final name = useState<String>('Loading...');
    final country = useState<String>('Kenya');
    final county = useState<String>('Nairobi');
    final role = useState<String>('Farmer');
    final loading = useState<bool>(true);
    final userId = useState<int?>(null);
    final isSaving = useState<bool>(false);

    // Load user data from Drift
    useEffect(() {
      Future.microtask(() async {
        final user = await db.getFirstUser();
        if (user != null) {
          name.value = user.username;
          country.value = user.country;
          county.value = user.county ?? '';
          role.value = user.role;
          userId.value = user.id;
        }
        loading.value = false;
      });
      return null;
    }, []);

    Future<void> saveProfile() async {
      if (userId.value == null) return;

      isSaving.value = true;

      final updatedUser = User(
        id: userId.value!,
        username: name.value,
        country: country.value,
        county: county.value,
        role: role.value,
        consent: true,
      );

      await db.updateUser(updatedUser);

      isSaving.value = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profileSaved),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

    if (loading.value) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile header with glass effect
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
              colors: [Colors.white.withAlpha(102), Colors.white.withAlpha(51)],
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
                Text(
                  roleToLabel(role.value, t),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              ],
            ),
          ),

          // Profile form
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: colorScheme.outline.withAlpha(153),
                style: BorderStyle.solid,
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
                    t.profileSaved,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name field
                  _buildProfileField(
                    icon: LucideIcons.user,
                    label: t.nameLabel,
                    value: name.value,
                    onChanged: (val) => name.value = val,
                    isEditable: true,
                    context: context,
                  ),

                  const SizedBox(height: 16),

                  // Country field
                  _buildProfileField(
                    icon: LucideIcons.globe,
                    label: t.countryLabel,
                    value: country.value,
                    isEditable: false,
                    context: context,
                  ),

                  if (country.value == 'Kenya') ...[
                    const SizedBox(height: 16),
                    _buildProfileField(
                      icon: LucideIcons.mapPin,
                      label: t.countyLabel,
                      value: county.value,
                      isEditable: false,
                      context: context,
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Role selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        child: DropdownButton<String>(
                          value: roleToLabel(role.value, t),
                          isExpanded: true,
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(12),
                          dropdownColor: colorScheme.surfaceContainerHighest,
                          style: GoogleFonts.poppins(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          items: ['Farmer', 'Extension Officer', 'Researcher']
                              .map(
                                (code) => DropdownMenuItem(
                                  value: roleToLabel(code, t),
                                  child: Text(roleToLabel(code, t)),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              role.value = labelToRole(val, t);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Save button
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
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        duration: 1500.ms,
                        color: colorScheme.secondary.withAlpha(51),
                        angle: 0.0,
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required BuildContext context, // Add this
    required IconData icon,
    required String label,
    required String value,
    required bool isEditable,
    ValueChanged<String>? onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
