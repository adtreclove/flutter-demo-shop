import 'package:demo_shop/Controler/locale_controller.dart';
import 'package:demo_shop/Models/settings_model.dart';
import 'package:demo_shop/Services/localization_service.dart';
import 'package:demo_shop/Services/shared_preferences_service.dart';
import 'package:demo_shop/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  /// Derived from the current locale, so it always matches what the app
  /// is actually showing.
  Language get _language =>
      Language.values
          .asNameMap()[getIt<LocaleController>().locale.languageCode] ??
      Language.en;

  String _languageLabel(Language language) => switch (language) {
    Language.de => 'Deutsch',
    Language.en => 'English',
  };

  Future<void> _onLanguageChanged(Language? language) async {
    if (language == null || language == _language) return;

    await getIt<LocaleController>().setLanguage(language);
    if (mounted) setState(() {});

    // Re-read before saving so other settings (e.g. mode) aren't overwritten.
    final prefs = SharedPreferencesService.instance;
    final settings = await prefs.loadSettings();
    settings.language = language;
    await prefs.saveSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          getIt<LocalizationService>().localizations.settings_screen_header,
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        children: [
          _SectionHeader(
            getIt<LocalizationService>()
                .localizations
                .settings_screen_notifications,
          ),
          SwitchListTile(
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
            title: Text(
              getIt<LocalizationService>()
                  .localizations
                  .settings_screen_push_noti,
              style: GoogleFonts.montserrat(),
            ),
            activeThumbColor: AppColors.primary,
          ),
          SwitchListTile(
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            title: Text(
              getIt<LocalizationService>()
                  .localizations
                  .settings_screen_email_noti,
              style: GoogleFonts.montserrat(),
            ),
            activeThumbColor: AppColors.primary,
          ),

          const SizedBox(height: 12),
          const _SectionHeader('General'),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              getIt<LocalizationService>()
                  .localizations
                  .settings_screen_language,
              style: GoogleFonts.montserrat(),
            ),
            trailing: DropdownButton<Language>(
              value: _language,
              underline: const SizedBox.shrink(),
              onChanged: _onLanguageChanged,
              items: [
                for (final language in Language.values)
                  DropdownMenuItem(
                    value: language,
                    child: Text(
                      _languageLabel(language),
                      style: GoogleFonts.montserrat(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              getIt<LocalizationService>()
                  .localizations
                  .settings_screen_version,
              style: GoogleFonts.montserrat(),
            ),
            trailing: Text(
              '1.0.0',
              style: GoogleFonts.montserrat(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: 12),
          _SectionHeader(
            getIt<LocalizationService>()
                .localizations
                .settings_screen_legal_infos,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(
              getIt<LocalizationService>()
                  .localizations
                  .settings_screen_privacy,
              style: GoogleFonts.montserrat(),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              // TODO: open privacy policy (webview/url_launcher)
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(
              getIt<LocalizationService>().localizations.settings_screen_terms,
              style: GoogleFonts.montserrat(),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              // TODO: open terms of service
            },
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
              onPressed: () {
                // TODO: account deletion
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(
                getIt<LocalizationService>()
                    .localizations
                    .settings_screen_delete_acc,
                style: GoogleFonts.montserrat(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
