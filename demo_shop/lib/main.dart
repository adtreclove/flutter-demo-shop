import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Screens/LoginScreen.dart';
import 'package:demo_shop/Widgets/Globals/AppShell.dart';
import 'package:demo_shop/appTheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Demo Shop',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const LoginScreen(), // invalid token
        data: (user) => user != null ? const AppShell() : const LoginScreen(),
      ),
    );
  }
}
