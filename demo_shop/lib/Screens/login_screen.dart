import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Helper/design_helper.dart';
import 'package:demo_shop/Services/localization_service.dart';
import 'package:demo_shop/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  bool _obscurePassword = true;
  bool _isLoading = false;

  /// The last failed login attempt, or null if there is nothing to show.
  LoginResult? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_error != null) setState(() => _error = null);
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ref
        .read(authProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

    // Guard: if login succeeded, authProvider's state just changed, which
    // causes MyApp to swap this screen out for AppShell. This widget may
    // already be disposed, and calling setState then would throw.
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _error = result == LoginResult.success ? null : result;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authProvider);

    final errorText = switch (_error) {
      LoginResult.missingCredentials =>
        getIt<LocalizationService>().localizations.login_screen_error_missing,
      LoginResult.invalidCredentials =>
        getIt<LocalizationService>().localizations.login_screen_error_creds,
      LoginResult.unexpectedError =>
        getIt<LocalizationService>().localizations.login_screen_error_generic,
      _ => null,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getIt<LocalizationService>().localizations.login_screen_header,
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ShimmerText(
                baseColor: AppColors.primary,
                highlightColor: Colors.white,
                child: Text(
                  getIt<LocalizationService>().localizations.login_screen_text,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _usernameController,
                onChanged: (_) => _clearError(),
                decoration: InputDecoration(
                  labelText: getIt<LocalizationService>()
                      .localizations
                      .login_screen_username,
                  labelStyle: GoogleFonts.montserrat(
                    color: AppColors.primaryDark,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryDark),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_) => _clearError(),
                decoration: InputDecoration(
                  labelText: getIt<LocalizationService>()
                      .localizations
                      .login_screen_password,
                  labelStyle: GoogleFonts.montserrat(
                    color: AppColors.primaryDark,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryDark),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              if (errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorText,
                  style: GoogleFonts.montserrat(
                    color: AppColors.error,
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceElevated,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          getIt<LocalizationService>()
                              .localizations
                              .login_screen_login_btn,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'INFORMATION: Test-Login: emilys / emilyspass\n(or any other login data from dummyjson.com/users)',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
