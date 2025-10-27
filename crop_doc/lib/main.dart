import 'package:crop_doc/core/providers/auth_provider.dart';
import 'package:crop_doc/core/providers/locale_provider.dart';
import 'package:crop_doc/core/services/hive_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crop_doc/shared/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crop_doc/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  runApp(const ProviderScope(child: CropDocApp()));
}

class CropDocApp extends ConsumerStatefulWidget {
  const CropDocApp({super.key});

  @override
  ConsumerState<CropDocApp> createState() => _CropDocAppState();
}

class _CropDocAppState extends ConsumerState<CropDocApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load persisted user + locale
      await ref.read(authProvider.notifier).loadFromHive();
      await ref.read(localeProvider.notifier).loadLocale();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final localeState = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: localeState.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    );
  }
}
