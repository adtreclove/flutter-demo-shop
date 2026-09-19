import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'intl_localizations_de.dart';
import 'intl_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/intl_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @login_screen_header.
  ///
  /// In de, this message translates to:
  /// **'Willkommen!'**
  String get login_screen_header;

  /// No description provided for @login_screen_username.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get login_screen_username;

  /// No description provided for @login_screen_password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get login_screen_password;

  /// No description provided for @login_screen_text.
  ///
  /// In de, this message translates to:
  /// **'Logge dich ein, um fortzufahren'**
  String get login_screen_text;

  /// No description provided for @login_screen_login_btn.
  ///
  /// In de, this message translates to:
  /// **'Login'**
  String get login_screen_login_btn;

  /// No description provided for @login_screen_error_creds.
  ///
  /// In de, this message translates to:
  /// **'Zugangsdaten falsch, versuche es bitte erneut.'**
  String get login_screen_error_creds;

  /// No description provided for @login_screen_error_missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib deinen Benutzernamen und dein Passwort ein.'**
  String get login_screen_error_missing;

  /// No description provided for @login_screen_error_generic.
  ///
  /// In de, this message translates to:
  /// **'Etwas ist schiefgelaufen. Bitte überprüfe deine Verbindung und versuche es erneut.'**
  String get login_screen_error_generic;

  /// No description provided for @settings_screen_header.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings_screen_header;

  /// No description provided for @settings_screen_notifications.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get settings_screen_notifications;

  /// No description provided for @settings_screen_push_noti.
  ///
  /// In de, this message translates to:
  /// **'Push-Nachrichten'**
  String get settings_screen_push_noti;

  /// No description provided for @settings_screen_email_noti.
  ///
  /// In de, this message translates to:
  /// **'E-Mail Benachrichtigungen'**
  String get settings_screen_email_noti;

  /// No description provided for @settings_screen_general.
  ///
  /// In de, this message translates to:
  /// **'Allgemein'**
  String get settings_screen_general;

  /// No description provided for @settings_screen_language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settings_screen_language;

  /// No description provided for @settings_screen_version.
  ///
  /// In de, this message translates to:
  /// **'App Version'**
  String get settings_screen_version;

  /// No description provided for @settings_screen_legal_infos.
  ///
  /// In de, this message translates to:
  /// **'Rechtliche Informationen'**
  String get settings_screen_legal_infos;

  /// No description provided for @settings_screen_privacy.
  ///
  /// In de, this message translates to:
  /// **'Privatsphäre'**
  String get settings_screen_privacy;

  /// No description provided for @settings_screen_terms.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Geschäftsbedingungen'**
  String get settings_screen_terms;

  /// No description provided for @settings_screen_delete_acc.
  ///
  /// In de, this message translates to:
  /// **'Account löschen'**
  String get settings_screen_delete_acc;

  /// No description provided for @search_screen_header.
  ///
  /// In de, this message translates to:
  /// **'Suchen'**
  String get search_screen_header;

  /// No description provided for @search_screen_hint.
  ///
  /// In de, this message translates to:
  /// **'Produkte suchen...'**
  String get search_screen_hint;

  /// No description provided for @search_screen_text.
  ///
  /// In de, this message translates to:
  /// **'Nach einem Produkt suchen'**
  String get search_screen_text;

  /// No description provided for @search_screen_error.
  ///
  /// In de, this message translates to:
  /// **'Etwas ist schief gelaufen'**
  String get search_screen_error;

  /// No description provided for @search_screen_no_products.
  ///
  /// In de, this message translates to:
  /// **'Keine Produkte gefunden'**
  String get search_screen_no_products;

  /// No description provided for @profile_screen_orders.
  ///
  /// In de, this message translates to:
  /// **'Meine Bestellungen'**
  String get profile_screen_orders;

  /// No description provided for @profile_screen_cart.
  ///
  /// In de, this message translates to:
  /// **'Warenkorb'**
  String get profile_screen_cart;

  /// No description provided for @profile_screen_favorites.
  ///
  /// In de, this message translates to:
  /// **'Favoriten'**
  String get profile_screen_favorites;

  /// No description provided for @profile_screen_settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get profile_screen_settings;

  /// No description provided for @profile_screen_logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get profile_screen_logout;

  /// No description provided for @order_screen_header.
  ///
  /// In de, this message translates to:
  /// **'Meine Bestellungen'**
  String get order_screen_header;

  /// No description provided for @order_screen_loading_error.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden der Bestellungen. Versuche es später erneut.'**
  String get order_screen_loading_error;

  /// No description provided for @order_screen_no_orders.
  ///
  /// In de, this message translates to:
  /// **'Du hast noch keine Bestellungen aufgegeben'**
  String get order_screen_no_orders;

  /// No description provided for @order_screen_order.
  ///
  /// In de, this message translates to:
  /// **'Bestellung #'**
  String get order_screen_order;

  /// No description provided for @order_screen_articles.
  ///
  /// In de, this message translates to:
  /// **'Artikel'**
  String get order_screen_articles;

  /// No description provided for @order_screen_products.
  ///
  /// In de, this message translates to:
  /// **'Produkte'**
  String get order_screen_products;

  /// No description provided for @favorite_screen_header.
  ///
  /// In de, this message translates to:
  /// **'Favoriten'**
  String get favorite_screen_header;

  /// No description provided for @favorite_screen_no_favorites.
  ///
  /// In de, this message translates to:
  /// **'Keine Produkte favoritisiert.'**
  String get favorite_screen_no_favorites;

  /// No description provided for @cat_screen_women.
  ///
  /// In de, this message translates to:
  /// **'FRAUEN'**
  String get cat_screen_women;

  /// No description provided for @cat_screen_men.
  ///
  /// In de, this message translates to:
  /// **'MÄNNER'**
  String get cat_screen_men;

  /// No description provided for @cart_screen_empty.
  ///
  /// In de, this message translates to:
  /// **'Dein Einkaufswagen ist leer.'**
  String get cart_screen_empty;

  /// No description provided for @cart_screen_total.
  ///
  /// In de, this message translates to:
  /// **'Gesamt'**
  String get cart_screen_total;

  /// No description provided for @cart_screen_checkout.
  ///
  /// In de, this message translates to:
  /// **'Zur Kasse'**
  String get cart_screen_checkout;

  /// No description provided for @home_screen_new_prod_header.
  ///
  /// In de, this message translates to:
  /// **'Entdecke neue Produkte'**
  String get home_screen_new_prod_header;

  /// No description provided for @home_screen_loading_error.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden der Produkte'**
  String get home_screen_loading_error;

  /// No description provided for @highlight_header.
  ///
  /// In de, this message translates to:
  /// **'Sonnenbrillen'**
  String get highlight_header;

  /// No description provided for @highlight_headline.
  ///
  /// In de, this message translates to:
  /// **'JETZT KAUFEN'**
  String get highlight_headline;

  /// No description provided for @greeting_morning.
  ///
  /// In de, this message translates to:
  /// **'Guten Morgen'**
  String get greeting_morning;

  /// No description provided for @greeting_afternoon.
  ///
  /// In de, this message translates to:
  /// **'Guten Tag'**
  String get greeting_afternoon;

  /// No description provided for @greeting_evening.
  ///
  /// In de, this message translates to:
  /// **'Guten Abend'**
  String get greeting_evening;

  /// No description provided for @greeting_night.
  ///
  /// In de, this message translates to:
  /// **'Gute Nacht'**
  String get greeting_night;

  /// No description provided for @ordered_text.
  ///
  /// In de, this message translates to:
  /// **'Bestellt!'**
  String get ordered_text;

  /// No description provided for @buy_now_text.
  ///
  /// In de, this message translates to:
  /// **'Jetzt kaufen'**
  String get buy_now_text;

  /// No description provided for @added_to_cart_text.
  ///
  /// In de, this message translates to:
  /// **'zum Warenkorb hinzugefügt'**
  String get added_to_cart_text;

  /// No description provided for @order_overlay_text.
  ///
  /// In de, this message translates to:
  /// **'Bestellung aufgegeben'**
  String get order_overlay_text;

  /// No description provided for @bestseller_header.
  ///
  /// In de, this message translates to:
  /// **'Bestselling Must-Haves'**
  String get bestseller_header;

  /// No description provided for @bestseller_error.
  ///
  /// In de, this message translates to:
  /// **'Fehler bei Laden der Bestseller'**
  String get bestseller_error;

  /// No description provided for @drawer_menu.
  ///
  /// In de, this message translates to:
  /// **'MENÜ'**
  String get drawer_menu;

  /// No description provided for @drawer_account.
  ///
  /// In de, this message translates to:
  /// **'ACCOUNT'**
  String get drawer_account;

  /// No description provided for @drawer_item_home.
  ///
  /// In de, this message translates to:
  /// **'Startseite'**
  String get drawer_item_home;

  /// No description provided for @drawer_item_profile.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get drawer_item_profile;

  /// No description provided for @drawer_item_search.
  ///
  /// In de, this message translates to:
  /// **'Suchen'**
  String get drawer_item_search;

  /// No description provided for @drawer_item_cat.
  ///
  /// In de, this message translates to:
  /// **'Kategorien'**
  String get drawer_item_cat;

  /// No description provided for @drawer_item_cart.
  ///
  /// In de, this message translates to:
  /// **'Warenkorb'**
  String get drawer_item_cart;

  /// No description provided for @drawer_item_logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get drawer_item_logout;

  /// No description provided for @error.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get error;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
