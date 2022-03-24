import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftServerTypePageTitle = 'craftServerTypePageTitle';
const craftServerTypePageSubtitle = 'craftServerTypePageSubtitle';
const craftServerTypePageNameFieldHint = 'craftServerTypePageNameFieldHint';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftServerTypePageTitle: {
        AppLocalization.enUS.name: 'Step 3．Select server type',
        AppLocalization.zhTW.name: '步驟三、選擇安裝包種類',
      },
      craftServerTypePageSubtitle: {
        AppLocalization.enUS.name: '① Type',
        AppLocalization.zhTW.name: '① 伺服器種類',
      },
      craftServerTypePageNameFieldHint: {
        AppLocalization.enUS.name: ' Please select a server type',
        AppLocalization.zhTW.name: ' 請選擇一個伺服器種類',
      }
    },
  );

  String get i18n => localize(this, _t);
}

List<TextSpan> getServerTypeDescriptionSpan(
  VoidCallback onTapVanilla,
  VoidCallback onTapForge,
) {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getDescriptionSpanZhTW(onTapVanilla, onTapForge);
  } else {
    return _getDescriptionSpanEnUS(onTapVanilla, onTapForge);
  }
}

List<TextSpan> _getDescriptionSpanEnUS(
  VoidCallback onTapVanilla,
  VoidCallback onTapForge,
) {
  return [
    const TextSpan(
      text: 'Supported server type is ',
    ),
    TextSpan(
      text: 'Vanilla ',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTapVanilla();
        },
    ),
    const TextSpan(
      text: 'and ',
    ),
    TextSpan(
      text: 'Forge',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTapForge();
        },
    ),
    const TextSpan(
      text:
          'For simple, want to play some model, go Forge, otherwise, Vanilla, or ask the map/plugin author which should choose!',
    ),
  ];
}

List<TextSpan> _getDescriptionSpanZhTW(
  VoidCallback onTapVanilla,
  VoidCallback onTapForge,
) {
  return [
    const TextSpan(
      text: '伺服器目前僅支援',
    ),
    TextSpan(
      text: 'Vanilla (俗稱官方版)',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTapVanilla();
        },
    ),
    const TextSpan(
      text: '與',
    ),
    TextSpan(
      text: 'Forge (模組版)',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTapForge();
        },
    ),
    const TextSpan(
      text: '簡單來說，需要模組用 Forge，不需要就選擇 Vanilla，如果是包裝別人的東西，直接問作者最快哦！',
    ),
  ];
}
