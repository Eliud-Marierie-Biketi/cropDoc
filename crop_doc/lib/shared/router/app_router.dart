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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      ShellRoute(
        navigatorKey:
            GlobalKey<
              NavigatorState
            >(), // optional, can help with nested navigation
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
        path: '/registration',
        builder: (_, __) => const RegistrationPage(),
      ),
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
