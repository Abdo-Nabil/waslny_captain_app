import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waslny_captain/core/error/exceptions.dart';
import 'dart:convert' show json;
import 'app_localizations_delegate.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    //
    String jsonString = await rootBundle.loadString(
      'lang/${locale.languageCode}.json',
    );

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(
        key,
        value.toString(),
      );
    });
  }

  String translate(String key) {
    if (_localizedStrings.containsKey(key)) {
      return _localizedStrings[key]!;
    } else {
      throw TranslateException();
    }
  }

  bool get isEnglishLocale => locale.languageCode == 'en';
  bool get isArabicLocale => locale.languageCode == 'ar';
}
