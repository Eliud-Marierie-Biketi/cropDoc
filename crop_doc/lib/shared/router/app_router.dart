import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import your app pages/providers
import 'package:crop_doc/core/providers/auth_provider.dart';
import 'package:crop_doc/features/auth/presentation/onboarding.dart';
import 'package:crop_doc/features/auth/presentation/registration_page.dart';
import 'package:crop_doc/features/home/home_page.dart';
import 'package:crop_doc/features/home/tabs/history_tab.dart';
import 'package:crop_doc/features/home/tabs/profile_tab.dart';
import 'package:crop_doc/features/home/tabs/samples_tab.dart';
import 'package:crop_doc/features/home/tabs/scan_tab.dart';
import 'package:crop_doc/features/result/results_page.dart';
import 'package:crop_doc/features/settings/settings_page.dart';
import 'package:crop_doc/features/splash/splash_screen.dart';
import 'dart:async';

/// --------------------------------
/// 🔹 GoRouterRefreshStream
/// Allows GoRouter to refresh when provider changes
/// --------------------------------
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// --------------------------------
/// 🔹 Router Provider
/// --------------------------------
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isRegistration = state.matchedLocation == '/registration';

      // ⏳ On splash: decide where to go next
      if (isSplash) return isAuthenticated ? '/scan' : '/onboarding';

      // 🧭 If not logged in, block access to everything except onboarding + registration
      if (!isAuthenticated && !isOnboarding && !isRegistration) {
        return '/onboarding';
      }

      // ✅ If logged in, don’t show onboarding or registration again
      if (isAuthenticated && (isOnboarding || isRegistration)) {
        return '/scan';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(
        path: '/registration',
        builder: (_, __) => const RegistrationPage(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (_, __, child) => HomePage(child: child),
        routes: [
          GoRoute(path: '/scan', builder: (_, __) => const ScanPage()),
          GoRoute(path: '/samples', builder: (_, __) => const SamplesPage()),
          GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
          GoRoute(path: '/profiles', builder: (_, __) => const ProfilePage()),
        ],
      ),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final resultData = extras['data'];
          final imageFile = extras['imageFile'];
          return ResultsPage(resultData: resultData, imageFile: imageFile);
        },
      ),
    ],
  );
});

/// --------------------------------
/// 🔹 Onboarding Language Picker
/// --------------------------------
class LanguagePicker extends ConsumerStatefulWidget {
  const LanguagePicker({super.key});

  @override
  ConsumerState<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends ConsumerState<LanguagePicker> {
  String selectedLanguage = 'en_US'; // default language

  @override
  void initState() {
    super.initState();
    // Load from Hive or AuthProvider if needed
    // selectedLanguage = ref.read(languageProvider) ?? 'en_US';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      onChanged: (val) {
        if (val != null) {
          setState(() => selectedLanguage = val);

          // Save to Hive or update provider
          // Example: ref.read(languageProvider.notifier).setLanguage(val);
        }
      },
      items: const [
        DropdownMenuItem(value: 'en_US', child: Text("English")),
        DropdownMenuItem(value: 'sw', child: Text("Swahili")),
      ],
    );
  }
}
