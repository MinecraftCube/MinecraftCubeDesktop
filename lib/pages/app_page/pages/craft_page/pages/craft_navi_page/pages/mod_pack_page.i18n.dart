import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftModpackPageTitle = 'craftModpackPageTitle';
const craftModpackPageSubtitle = 'craftModpackPageSubtitle';
const craftModpackPageTypeDetail = 'craftModpackPageTypeDetail';
const craftModpackPageTypeAll = 'craftModpackPageTypeAll';
const craftModpackPageFieldDescription = 'craftModpackPageFieldDescription';
const craftModpackPageFieldDownload = 'craftModpackPageFieldDownload';
const craftModpackPageFieldDownloadHelper =
    'craftModpackPageFieldDownloadHelper';
const craftModpackPageFieldErrorTextA = 'craftModpackPageFieldErrorTextA';
const craftModpackPageFieldErrorTextB = 'craftModpackPageFieldErrorTextB';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftModpackPageTitle: {
        AppLocalization.enUS.name: 'Step 6．Models\' info',
        AppLocalization.zhTW.name: '步驟六、填寫模組資訊',
      },
      craftModpackPageSubtitle: {
        AppLocalization.enUS.name: '① All models',
        AppLocalization.zhTW.name: '① 所有模組',
      },
      craftModpackPageTypeDetail: {
        AppLocalization.enUS.name: 'Detail',
        AppLocalization.zhTW.name: '詳細版',
      },
      craftModpackPageTypeAll: {
        AppLocalization.enUS.name: 'Modpack',
        AppLocalization.zhTW.name: '模組包',
      },
      craftModpackPageFieldDescription: {
        AppLocalization.enUS.name: 'Description:',
        AppLocalization.zhTW.name: '敘述:',
      },
      craftModpackPageFieldDownload: {
        AppLocalization.enUS.name: 'Direct Link:',
        AppLocalization.zhTW.name: '直接下載連結:',
      },
      craftModpackPageFieldDownloadHelper: {
        AppLocalization.enUS.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
        AppLocalization.zhTW.name:
            'ex. https://www.dropbox.com/s/dvzj9lnujpec0wd/something.zip?dl=1',
      },
      craftModpackPageFieldErrorTextA: {
        AppLocalization.enUS.name: 'Not a valid url',
        AppLocalization.zhTW.name: '不是一個連結',
      },
    },
  );

  String get i18n => localize(this, _t);
  // String fill(List<Object> params) => localizeFill(this, params);
}

List<TextSpan> getModpackDescriptionSpan(
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
