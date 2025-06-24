import 'package:crop_doc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:crop_doc/core/database/app_database.dart';

class ProfileTab extends HookConsumerWidget {
  const ProfileTab({super.key});

  /// Maps role code (stored in DB) to localized label
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

  /// Maps localized label back to internal role code
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

    // Hook states
    final name = useState<String>('Loading...');
    final country = useState<String>('Kenya');
    final county = useState<String>('Nairobi');
    final role = useState<String>('Farmer'); // internal code
    final loading = useState<bool>(true);
    final userId = useState<int?>(null);

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

    if (loading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.profileTab, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: name.value,
            decoration: InputDecoration(labelText: t.nameLabel),
            onChanged: (val) => name.value = val,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: country.value,
            readOnly: true,
            decoration: InputDecoration(labelText: t.countryLabel),
          ),
          if (country.value == 'Kenya') ...[
            const SizedBox(height: 10),
            TextFormField(
              initialValue: county.value,
              readOnly: true,
              decoration: InputDecoration(labelText: t.countyLabel),
            ),
          ],
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: roleToLabel(role.value, t), // show localized value
            items: ['Farmer', 'Extension Officer', 'Researcher']
                .map(
                  (code) => DropdownMenuItem(
                    value: roleToLabel(code, t),
                    child: Text(roleToLabel(code, t)),
                  ),
                )
                .toList(),
            decoration: InputDecoration(labelText: t.roleLabel),
            onChanged: (val) {
              if (val != null) {
                role.value = labelToRole(val, t); // convert label back to code
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              if (userId.value == null) return;

              final updatedUser = User(
                id: userId.value!,
                username: name.value,
                country: country.value,
                county: county.value,
                role: role.value, // store raw code
                consent: true,
              );

              await db.updateUser(updatedUser);

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(t.saveProfile)));
            },
            icon: const Icon(Icons.save),
            label: Text(t.saveProfile),
          ),
        ],
      ),
    );
  }
}
