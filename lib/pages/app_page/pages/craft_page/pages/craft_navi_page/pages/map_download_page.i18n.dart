import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftMapDownloadPageTitle = 'craftMapDownloadPageTitle';
const craftMapDownloadPageSubtitle = 'craftMapDownloadPageSubtitle';
const craftMapDownloadPageFieldHelperText =
    'craftMapDownloadPageFieldHelperText';
const craftMapDownloadPageFieldErrorTextA =
    'craftMapDownloadPageFieldErrorTextA';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftMapDownloadPageTitle: {
        AppLocalization.enUS.name: 'Step 5．URL of map pack',
        AppLocalization.zhTW.name: '步驟五、輸入地圖下載位置',
      },
      craftMapDownloadPageSubtitle: {
        AppLocalization.enUS.name: '① \'Direct\' download path',
        AppLocalization.zhTW.name: '① 「直接」下載位置',
      },
      craftMapDownloadPageFieldHelperText: {
        AppLocalization.enUS.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
        AppLocalization.zhTW.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
      },
      craftMapDownloadPageFieldErrorTextA: {
        AppLocalization.enUS.name: 'Not a valid url',
        AppLocalization.zhTW.name: '不是一個連結',
      }
    },
  );

  String get i18n => localize(this, _t);
}

List<TextSpan> getMapDownloadDescriptionSpan(
  VoidCallback onInstallerViewPressed,
) {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getDescriptionSpanZhTW(
      onInstallerViewPressed,
    );
  } else {
    return _getDescriptionSpanEnUS(
      onInstallerViewPressed,
    );
  }
}

List<TextSpan> _getDescriptionSpanEnUS(
  VoidCallback onInstallerViewPressed,
) {
  return [
    const TextSpan(
      text: '''If you don't know how to make a map pack, please see ''',
    ),
    TextSpan(
      text: '''How to make installer (Sorry, It's Chinese)''',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onInstallerViewPressed();
        },
    ),
    const TextSpan(
      text:
          ', Timestamp is marked!\n Please notice, must be zip and the structure of file is a single World and server.properties.',
    ),
  ];
}

List<TextSpan> _getDescriptionSpanZhTW(
  VoidCallback onInstallerViewPressed,
) {
  return [
    const TextSpan(
      text: '''地圖包不知道怎麼做，請參考''',
    ),
    TextSpan(
      text: '''安裝包製作''',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onInstallerViewPressed();
        },
    ),
    const TextSpan(
      text:
          '！時間點都標好囉！\n再次提醒，請注意，必須是 zip 檔與其內架構為 world 與 單一 server.properties。\n因有部分玩家，把 world 資料夾亂更名，多說一次，資料夾名稱請保持 world ，且確認無中文雜檔，請參考影片教學...。',
    ),
  ];
}
