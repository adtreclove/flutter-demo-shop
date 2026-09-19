import 'package:demo_shop/Models/settings_model.dart';
import 'package:demo_shop/Services/localization_service.dart';
import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._service);

  final LocalizationService _service;

  Locale get locale => _service.currentLocale;

  Future<void> setLanguage(Language language) async {
    await _service.updateLocale(Locale(language.name));
    notifyListeners();
  }
}
