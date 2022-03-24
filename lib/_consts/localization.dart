import 'package:flutter/widgets.dart';
import 'package:minecraft_cube_desktop/_consts/localization.i18n.dart';

enum AppLanguage {
  zhTW,
  enUS,
}

extension AppLanguageExt on AppLanguage {
  String get name {
    switch (this) {
      case AppLanguage.zhTW:
        return localizationZhTw.i18n;
      case AppLanguage.enUS:
        return localizationEnUs.i18n;
      default:
        throw UnimplementedError();
    }
  }
}

extension LocaleExt on Locale {
  String get name {
    String result = languageCode.toLowerCase();
    final country = countryCode;
    if (country != null) {
      result += '_${country.toLowerCase()}';
    }
    return result;
  }
}

class AppLocalization {
  static Locale enUS = const Locale('en', 'US');
  static Locale zhTW = const Locale('zh', 'TW');
}
