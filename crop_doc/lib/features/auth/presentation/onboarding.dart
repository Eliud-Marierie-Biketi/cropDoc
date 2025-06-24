// lib/features/onboarding/presentation/onboarding_page.dart
import 'package:crop_doc/features/auth/presentation/registration_page.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void _continue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)), // "CropDoc"
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👋 ${t.welcomeTitle}", // "Welcome!"
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              t.welcomeDescription, // Localized onboarding message
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: Text(t.continueButton), // "Continue"
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
