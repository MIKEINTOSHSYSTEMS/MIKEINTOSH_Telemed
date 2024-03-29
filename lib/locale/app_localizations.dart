import 'package:flutter/material.dart';
import 'package:momona_healthcare/locale/base_language_key.dart';
import 'package:momona_healthcare/locale/language_ar.dart';
import 'package:momona_healthcare/locale/language_am.dart';
import 'package:momona_healthcare/locale/language_en.dart';
import 'package:momona_healthcare/locale/language_fr.dart';
import 'package:momona_healthcare/locale/language_hi.dart';
import 'package:nb_utils/nb_utils.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'am':
        return LanguageAm();
      case 'ar':
        return LanguageAr();
      case 'fr':
        return LanguageFr();
      case 'hi':
        return LanguageHi();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
