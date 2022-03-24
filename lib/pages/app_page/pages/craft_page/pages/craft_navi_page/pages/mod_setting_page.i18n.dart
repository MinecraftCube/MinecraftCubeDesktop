import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftModelSettingPageTitle = 'craftModelSettingPageTitle';
const craftModelSettingPageSubtitle = 'craftModelSettingPageSubtitle';
const craftModelSettingPageTypeDetail = 'craftModelSettingPageTypeDetail';
const craftModelSettingPageTypeAll = 'craftModelSettingPageTypeAll';
const craftModelSettingPageFieldTitle = 'craftModelSettingPageFieldTitle';
const craftModelSettingPageFieldModel = 'craftModelSettingPageFieldModel';
const craftModelSettingPageFieldModelHelper =
    'craftModelSettingPageFieldModelHelper';
const craftModelSettingPageFieldFilename = 'craftModelSettingPageFieldFilename';
const craftModelSettingPageFieldFilenameHelper =
    'craftModelSettingPageFieldFilenameHelper';
const craftModelSettingPageFieldDownload = 'craftModelSettingPageFieldDownload';
const craftModelSettingPageFieldDownloadHelper =
    'craftModelSettingPageFieldDownloadHelper';
const craftModelSettingPageFieldErrorTextA =
    'craftModelSettingPageFieldErrorTextA';
const craftModelSettingPageFieldErrorTextB =
    'craftModelSettingPageFieldErrorTextB';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftModelSettingPageTitle: {
        AppLocalization.enUS.name: 'Step 6．Models\' info',
        AppLocalization.zhTW.name: '步驟六、填寫模組資訊',
      },
      craftModelSettingPageSubtitle: {
        AppLocalization.enUS.name: '① All models',
        AppLocalization.zhTW.name: '① 所有模組',
      },
      craftModelSettingPageTypeDetail: {
        AppLocalization.enUS.name: 'Detail',
        AppLocalization.zhTW.name: '詳細版',
      },
      craftModelSettingPageTypeAll: {
        AppLocalization.enUS.name: 'Modpack',
        AppLocalization.zhTW.name: '模組包',
      },
      craftModelSettingPageFieldTitle: {
        AppLocalization.enUS.name: 'Enter a name for model',
        AppLocalization.zhTW.name: '請輸入模組名稱',
      },
      craftModelSettingPageFieldModel: {
        AppLocalization.enUS.name: 'Mod',
        AppLocalization.zhTW.name: '模組',
      },
      craftModelSettingPageFieldModelHelper: {
        AppLocalization.enUS.name: 'ex. pokemon',
        AppLocalization.zhTW.name: 'ex. 寶可夢模組',
      },
      craftModelSettingPageFieldFilename: {
        AppLocalization.enUS.name: 'Filename',
        AppLocalization.zhTW.name: '檔名',
      },
      craftModelSettingPageFieldFilenameHelper: {
        AppLocalization.enUS.name: 'ex. pokemon_mod.zip or some_mod.jar',
        AppLocalization.zhTW.name: 'ex. pokemon_mod.zip or some_mod.jar',
      },
      craftModelSettingPageFieldDownload: {
        AppLocalization.enUS.name: 'Direct',
        AppLocalization.zhTW.name: '直接連接',
      },
      craftModelSettingPageFieldDownloadHelper: {
        AppLocalization.enUS.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
        AppLocalization.zhTW.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
      },
      craftModelSettingPageFieldErrorTextA: {
        AppLocalization.enUS.name: 'Should not be empty',
        AppLocalization.zhTW.name: '必填',
      },
      craftModelSettingPageFieldErrorTextB: {
        AppLocalization.enUS.name: 'Not a valid url',
        AppLocalization.zhTW.name: '不是一個連結',
      },
    },
  );

  String get i18n => localize(this, _t);
  // String fill(List<Object> params) => localizeFill(this, params);
}

List<TextSpan> getModelSettingDescriptionSpan(
  VoidCallback onModelVideoPressed,
) {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getDescriptionSpanZhTW(
      onModelVideoPressed,
    );
  } else {
    return _getDescriptionSpanEnUS(
      onModelVideoPressed,
    );
  }
}

List<TextSpan> _getDescriptionSpanEnUS(
  VoidCallback onModelVideoPressed,
) {
  return [
    const TextSpan(
      text: '''Don't know how to do? Please see ''',
    ),
    TextSpan(
      text: '''How to make installer (Sorry, It's Chinese)''',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onModelVideoPressed,
    ),
    const TextSpan(
      text: ', Timestamp has been marked!\n',
    ),
    const TextSpan(
      text: 'Notice: Modpack mode must contain only mods\n',
    ),
  ];
}

List<TextSpan> _getDescriptionSpanZhTW(
  VoidCallback onModelVideoPressed,
) {
  return [
    const TextSpan(
      text: '''不知道怎麼填寫，請參考''',
    ),
    TextSpan(
      text: '''安裝包製作''',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onModelVideoPressed,
    ),
    const TextSpan(
      text: '，時間點已標註！\n',
    ),
    const TextSpan(
      text: '註記: 模組包只能包含模組檔案\n',
    ),
  ];
}
