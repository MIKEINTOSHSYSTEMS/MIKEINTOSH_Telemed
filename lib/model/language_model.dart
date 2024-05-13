import 'package:flutter/material.dart';

import '../utils/images.dart';

class Language {
  int id;
  String name;
  String languageCode;
  String flag;

  Language(this.id, this.name, this.languageCode, this.flag);

  static List<Language> getLanguages() {
    return <Language>[
      Language(0, 'English', 'en', flagsIcUs),
      Language(1, 'Amharic', 'am', flagsIcEthiopia),
      Language(2, 'French', 'fr', flagsIcFrench),
      Language(3, 'German', 'de', flagsIcGermany),
      Language(4, 'Arabic', 'ar', flagsIcAr),
      Language(5, 'Hindi', 'hi', flagsIcIndia),
    ];
  }

  static List<String> languages() {
    List<String> list = [];

    getLanguages().forEach((element) {
      list.add(element.languageCode);
    });

    return list;
  }

  static List<Locale> languagesLocale() {
    List<Locale> list = [];

    getLanguages().forEach((element) {
      list.add(Locale(element.languageCode, ''));
    });

    return list;
  }
}
