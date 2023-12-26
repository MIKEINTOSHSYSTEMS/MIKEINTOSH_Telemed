import 'package:flutter/material.dart';

class Language {
  int id;
  String name;
  String languageCode;
  String flag;

  Language(this.id, this.name, this.languageCode, this.flag);

  static List<Language> getLanguages() {
    return <Language>[
      Language(0, 'English', 'en', 'images/flags/ic_us.png'),
      Language(1, 'Arabic', 'ar', 'images/flags/ic_ar.png'),
      Language(2, 'Hindi', 'hi', 'images/flags/ic_india.png'),
      Language(3, 'German', 'de', 'images/flags/ic_germany.png'),
      Language(4, 'French', 'fr', 'images/flags/ic_french.png'),
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
