import 'package:flutter/material.dart';
import 'package:udcks_news_app/cache/shared_preference_helper.dart';

class LanguageProvider extends ChangeNotifier {
  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocale = const Locale('en');

  LanguageProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
  }

  Locale get appLocale {
    _sharedPrefsHelper.appLocale?.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    print(languageCode);
    if (languageCode == "vi") {
      _appLocale = const Locale("vi");
    } else {
      _appLocale = const Locale("en");
    }

    _sharedPrefsHelper.changeLanguage(languageCode);
    notifyListeners();
  }
}
