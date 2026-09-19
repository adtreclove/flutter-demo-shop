import 'package:demo_shop/Services/localization_service.dart';

String getGreeting({DateTime? time}) {
  final now = time ?? DateTime.now();
  final hour = now.hour;

  if (hour >= 5 && hour < 12) {
    return getIt<LocalizationService>().localizations.greeting_morning;
  } else if (hour >= 12 && hour < 17) {
    return getIt<LocalizationService>().localizations.greeting_afternoon;
  } else if (hour >= 17 && hour < 21) {
    return getIt<LocalizationService>().localizations.greeting_evening;
  } else {
    return getIt<LocalizationService>().localizations.greeting_night;
  }
}
