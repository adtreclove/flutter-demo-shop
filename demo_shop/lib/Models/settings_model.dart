enum Language { de, en }

enum Mode { light, dark }

class Settings {
  Language language;
  Mode mode;

  Settings({required this.language, required this.mode});

  factory Settings.defaults() =>
      Settings(language: Language.en, mode: Mode.light);

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      language: Language.values.asNameMap()[json['language']] ?? Language.en,
      mode: Mode.values.asNameMap()[json['mode']] ?? Mode.light,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language.name,
    'mode': mode.name,
  };
}
