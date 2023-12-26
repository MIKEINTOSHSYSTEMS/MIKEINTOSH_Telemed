import 'package:flutter/material.dart';
import 'package:kivicare_flutter/locale/base_language_key.dart';
import 'package:kivicare_flutter/locale/language_ar.dart';
import 'package:kivicare_flutter/locale/language_de.dart';
import 'package:kivicare_flutter/locale/language_en.dart';
import 'package:kivicare_flutter/locale/language_fr.dart';
import 'package:kivicare_flutter/locale/language_hi.dart';
import 'package:nb_utils/nb_utils.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'hi':
        return LanguageHi();
      case 'fr':
        return LanguageFr();
      case 'de':
        return LanguageDe();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
