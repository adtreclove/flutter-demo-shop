import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Controler/locale_controller.dart';
import 'package:demo_shop/Screens/login_screen.dart';
import 'package:demo_shop/Services/localization_service.dart';
import 'package:demo_shop/Services/shared_preferences_service.dart';
import 'package:demo_shop/Widgets/Globals/app_shell.dart';
import 'package:demo_shop/app_theme.dart';
import 'package:demo_shop/l10n/generated/intl_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.instance.init();

  final settings = await SharedPreferencesService.instance.tryLoadSettings();
  await setupLocalizationService(preferredLanguage: settings?.language.name);
  getIt.registerSingleton<LocaleController>(
    LocaleController(getIt<LocalizationService>()),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return ListenableBuilder(
      listenable: getIt<LocaleController>(),
      builder: (context, _) => MaterialApp(
        title: 'Demo Shop',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        locale: getIt<LocaleController>().locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: authState.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, __) => const LoginScreen(), // invalid token
          data: (user) => user != null ? const AppShell() : const LoginScreen(),
        ),
      ),
    );
  }
}
