import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftInstallerNamePageTitle = 'craftInstallerNamePageTitle';
const craftInstallerNamePageSubtitle = 'craftInstallerNamePageSubtitle';
const craftInstallerNamePageNameFieldHint =
    'craftInstallerNamePageNameFieldHint';
const craftInstallerNamePageNameFieldErrorA =
    'craftInstallerNamePageNameFieldErrorA';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftInstallerNamePageTitle: {
        AppLocalization.enUS.name: 'Step 1．Name your Installer',
        AppLocalization.zhTW.name: '步驟一、輸入安裝包名稱',
      },
      craftInstallerNamePageSubtitle: {
        AppLocalization.enUS.name: '① Installer name',
        AppLocalization.zhTW.name: '① 安裝包名稱',
      },
      craftInstallerNamePageNameFieldHint: {
        AppLocalization.enUS.name: 'ex. Unfair_1.12.2_vanilla',
        AppLocalization.zhTW.name: 'ex. 你寧可v2_1.12.2_vanilla',
      },
      craftInstallerNamePageNameFieldErrorA: {
        AppLocalization.enUS.name: 'Should not be empty',
        AppLocalization.zhTW.name: '必填',
      }
    },
  );

  String get i18n => localize(this, _t);
}

List<TextSpan> getInstallerNameDescriptionSpan() {
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
      text: 'Installer name',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: ' ' 'will become' ' ',
    ),
    TextSpan(
      text: 'File name.dmc',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: ', It is recommended to name It as ',
    ),
    TextSpan(
      text: '{NAME_VERSION_(TYPE)}',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: ',\nFor example, to build a unfair minecraft installer, ',
    ),
    TextSpan(
      text: 'Unfair_1.12.2_vanilla',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: ' or ',
    ),
    TextSpan(
      text: 'Unfair_1.12.2',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text:
          ' is better to management and help others know which version for client side.',
    )
  ];
}

List<TextSpan> _getDescriptionSpanZhTW() {
  return const [
    TextSpan(
      text: '「安裝包名稱」',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: '會變成',
    ),
    TextSpan(
      text: '「檔案名稱」.dmc',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: '，建議格式為',
    ),
    TextSpan(
      text: '{名稱_版本號_(種類)}',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: '，\n例如，製作你寧可製作包，',
    ),
    TextSpan(
      text: '你寧可v2_1.12.2_Vanilla',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: ' 或 ',
    ),
    TextSpan(
      text: '你寧可v2_1.12.2',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: '，這樣除了可以讓下載者一目了然，也可以幫助自己管理安裝包哦！',
    )
  ];
}
