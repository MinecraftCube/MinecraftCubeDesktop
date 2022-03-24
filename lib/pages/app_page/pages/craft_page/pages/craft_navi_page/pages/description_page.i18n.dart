import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftDescriptionPageTitle = 'craftDescriptionPageTitle';
const craftDescriptionPageSubtitle = 'craftDescriptionPageSubtitle';
const craftDescriptionPageNameFieldHint = 'craftDescriptionPageNameFieldHint';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftDescriptionPageTitle: {
        AppLocalization.enUS.name: 'Step 2．Description for installer',
        AppLocalization.zhTW.name: '步驟二、輸入安裝包敘述(可略)',
      },
      craftDescriptionPageSubtitle: {
        AppLocalization.enUS.name: '① Breif',
        AppLocalization.zhTW.name: '① 簡單敘述',
      },
    },
  );

  String get i18n => localize(this, _t);
}

List<TextSpan> getDescriptionDescriptionSpan() {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getDescriptionSpanZhTW();
  } else {
    return _getDescriptionSpanEnUS();
  }
}

List<TextSpan> _getDescriptionSpanEnUS() {
  return const [
    TextSpan(
      text:
          '''Description is for introduce other player to understand. Currently, It's not displayed, because I can't find where to display (´_ゝ`)''',
    ),
  ];
}

List<TextSpan> _getDescriptionSpanZhTW() {
  return const [
    TextSpan(
      text: '''敘述是為了介紹給其他小玩家使用。你問安裝的時候為什麼不顯示出來？找不到地方顯示啊(´_ゝ`)''',
    ),
  ];
}
