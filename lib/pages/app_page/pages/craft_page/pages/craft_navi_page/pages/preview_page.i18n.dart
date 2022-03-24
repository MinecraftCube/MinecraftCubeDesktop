import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftPreviewPageTitle = 'craftPreviewPageTitle';
const craftPreviewPageSubtitle = 'craftPreviewPageSubtitle';
const craftPreviewPageInstallerName = 'craftPreviewPageInstallerName';
const craftPreviewPageDescription = 'craftPreviewPageDescription';
const craftPreviewPageServerType = 'craftPreviewPageServerType';
const craftPreviewPageServerDirectDownload =
    'craftPreviewPageServerDirectDownload';
const craftPreviewPageMapDirectDownload = 'craftPreviewPageMapDirectDownload';
const craftPreviewPageServerAllMods = 'craftPreviewPageServerAllMods';
const craftPreviewPageServerModName = 'craftPreviewPageServerModName';
const craftPreviewPageServerModProgram = 'craftPreviewPageServerModProgram';
const craftPreviewPageServerModDownload = 'craftPreviewPageServerModDownload';
const craftPreviewPageServerModpackDownload =
    'craftPreviewPageServerModpackDownload';
const craftPreviewPageServerModpackDescription =
    'craftPreviewPageServerModpackDescription';

const craftPreviewPageComplete = 'craftPreviewPageComplete';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftPreviewPageTitle: {
        AppLocalization.enUS.name: 'Final Check',
        AppLocalization.zhTW.name: '再次確認安裝包',
      },
      craftPreviewPageSubtitle: {
        AppLocalization.enUS.name: 'Click complete when done',
        AppLocalization.zhTW.name: '無誤後請按完成',
      },
      craftPreviewPageComplete: {
        AppLocalization.enUS.name: 'Complete',
        AppLocalization.zhTW.name: '完成',
      },
      craftPreviewPageInstallerName: {
        AppLocalization.enUS.name: 'Name',
        AppLocalization.zhTW.name: '安裝包名稱',
      },
      craftPreviewPageDescription: {
        AppLocalization.enUS.name: 'Description',
        AppLocalization.zhTW.name: '敘述',
      },
      craftPreviewPageServerType: {
        AppLocalization.enUS.name: 'Type',
        AppLocalization.zhTW.name: '類型',
      },
      craftPreviewPageServerDirectDownload: {
        AppLocalization.enUS.name: 'Server',
        AppLocalization.zhTW.name: '伺服器來源',
      },
      craftPreviewPageMapDirectDownload: {
        AppLocalization.enUS.name: 'Map',
        AppLocalization.zhTW.name: '地圖來源',
      },
      craftPreviewPageServerAllMods: {
        AppLocalization.enUS.name: 'All Mods',
        AppLocalization.zhTW.name: '所有模組',
      },
      craftPreviewPageServerModName: {
        AppLocalization.enUS.name: 'Name',
        AppLocalization.zhTW.name: '模組名',
      },
      craftPreviewPageServerModProgram: {
        AppLocalization.enUS.name: 'Program',
        AppLocalization.zhTW.name: '檔案名',
      },
      craftPreviewPageServerModDownload: {
        AppLocalization.enUS.name: 'Source',
        AppLocalization.zhTW.name: '來源',
      },
      craftPreviewPageServerModpackDownload: {
        AppLocalization.enUS.name: 'Pack Source',
        AppLocalization.zhTW.name: '模組包來源',
      },
      craftPreviewPageServerModpackDescription: {
        AppLocalization.enUS.name: 'Description',
        AppLocalization.zhTW.name: '說明',
      },
    },
  );

  String get i18n => localize(this, _t);
}

List<TextSpan> getPreviewDescriptionSpan() {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getDescriptionSpanZhTW();
  } else {
    return _getDescriptionSpanEnUS();
  }
}

List<TextSpan> _getDescriptionSpanEnUS() {
  return [
    const TextSpan(
      text: 'Please check all fields before completion.\n',
    ),
    const TextSpan(
      text: 'This action will override the ',
    ),
    const TextSpan(
      text: 'existed installer file(.dmc).\n',
      style: TextStyle(color: Colors.red),
    ),
    const TextSpan(
      text:
          'Before publish installer file anywhere, please run in \'Server\' once for checking.\n',
    ),
  ];
}

List<TextSpan> _getDescriptionSpanZhTW() {
  return [
    const TextSpan(
      text: '請再次檢查填寫內容\n',
    ),
    const TextSpan(
      text: '完成後將會創建或覆蓋',
    ),
    const TextSpan(
      text: '安裝包(.dmc).\n',
      style: TextStyle(color: Colors.red),
    ),
    const TextSpan(
      text: '在發布或分享前，記得至「伺服器」測試一遍。.\n',
    ),
  ];
}
