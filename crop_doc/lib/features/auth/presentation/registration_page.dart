import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/database/app_database.dart';
import '../../home/home_page.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String country = 'Kenya';
  String? county;
  String role = 'Farmer';
  bool consent = false;

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

  void _submit() async {
    if (!_formKey.currentState!.validate() || !consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.completeFormMessage),
        ),
      );
      return;
    }

    final db = ref.read(appDatabaseProvider);

    await db.insertUser(
      UsersCompanion.insert(
        username: Value(username),
        country: country,
        county: Value(country == "Kenya" ? county : null),
        role: role,
        consent: true,
      ),
    );

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final showCounty = country == "Kenya";

    return Scaffold(
      appBar: AppBar(title: Text(t.registerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: t.nameLabel),
                validator: (val) =>
                    (val == null || val.isEmpty) ? t.nameLabel : null,
                onChanged: (val) => setState(() => username = val),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: country,
                decoration: InputDecoration(labelText: t.countryLabel),
                items: ["Kenya", t.otherLabel]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => country = val!),
              ),
              if (showCounty)
                DropdownButtonFormField<String>(
                  value: county,
                  decoration: InputDecoration(labelText: t.countyLabel),
                  items: counties
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => county = val!),
                  validator: (val) =>
                      showCounty && val == null ? t.countyLabel : null,
                ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: roleToLabel(role, t),
                decoration: InputDecoration(labelText: t.roleLabel),
                items: roleCodes
                    .map(
                      (code) => DropdownMenuItem(
                        value: roleToLabel(code, t),
                        child: Text(roleToLabel(code, t)),
                      ),
                    )
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
                onChanged: (val) => setState(() => consent = val ?? false),
                title: Text(t.consentText),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: Text(t.registerButton),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
