import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftServerDownloadPageTitle = 'craftServerDownloadPageTitle';
const craftServerDownloadPageSubtitle = 'craftServerDownloadPageSubtitle';
const craftServerDownloadPageFieldHelperText =
    'craftServerDownloadPageFieldHelperText';
const craftServerDownloadPageFieldErrorTextA =
    'craftServerDownloadPageFieldErrorTextA';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftServerDownloadPageTitle: {
        AppLocalization.enUS.name: 'Step 4．Server download url',
        AppLocalization.zhTW.name: '步驟四、輸入伺服器下載位置',
      },
      craftServerDownloadPageSubtitle: {
        AppLocalization.enUS.name: '① \'Direct\' download url',
        AppLocalization.zhTW.name: '① 「直接」下載位置',
      },
      craftServerDownloadPageFieldHelperText: {
        AppLocalization.enUS.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
        AppLocalization.zhTW.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
      },
      craftServerDownloadPageFieldErrorTextA: {
        AppLocalization.enUS.name: 'Not a valid url',
        AppLocalization.zhTW.name: '不是一個連結',
      }
    },
  );

  String get i18n => localize(this, _t);
}

List<TextSpan> getServerDownloadDescriptionSpan(
  VoidCallback onInstallerVideoPressed,
) {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getDescriptionSpanZhTW(
      onInstallerVideoPressed,
    );
  } else {
    return _getDescriptionSpanEnUS(
      onInstallerVideoPressed,
    );
  }
}

List<TextSpan> _getDescriptionSpanEnUS(
  VoidCallback onInstallerVideoPressed,
) {
  return [
    const TextSpan(
      text:
          '''If you know nothing about direct download url, please see author's ''',
    ),
    TextSpan(
      text: 'How to make an installer(Chinese, Sorry...)'.i18n,
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onInstallerVideoPressed();
        },
    ),
    const TextSpan(
      text:
          ',\n (Direct download url is a url that paste on Broswer, and could download It directly without any redirect.',
    ),
    // TextSpan(
    //   text: '\n(有鑑於有部分小玩家使用巴哈姆特轉址接口，誤認為直接下載位置，且忽略錯誤訊息，請先測試是否可直接下載，再貼上，感謝配合。)',
    //   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
    // ),
  ];
}

List<TextSpan> _getDescriptionSpanZhTW(
  VoidCallback onInstallerVideoPressed,
) {
  return [
    const TextSpan(
      text: '''如果不知道什麼是直接下載位置，請看青雲的''',
    ),
    TextSpan(
      text: '安裝包製作',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onInstallerVideoPressed();
        },
    ),
    const TextSpan(
      text: '！\n(直接下載連結必須可直接貼上瀏覽器下載)',
    ),
  ];
}
