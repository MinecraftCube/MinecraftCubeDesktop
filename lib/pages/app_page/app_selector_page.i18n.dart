import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const appSelectorPageTypeInfo = 'appSelectorPageTypeInfo';
const appSelectorPageTypeServer = 'appSelectorPageTypeServer';
const appSelectorPageTypeCraft = 'appSelectorPageTypeCraft';
const appSelectorPageTypeAbout = 'appSelectorPageTypeAbout';
const appTitle = 'appTitle';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      appTitle: {
        AppLocalization.enUS.name: 'Minecraft Cube',
        AppLocalization.zhTW.name: '創世神魔方',
      },
      appSelectorPageTypeInfo: {
        AppLocalization.enUS.name: 'Info',
        AppLocalization.zhTW.name: '資訊欄',
      },
      appSelectorPageTypeServer: {
        AppLocalization.enUS.name: 'Server',
        AppLocalization.zhTW.name: '伺服器',
      },
      appSelectorPageTypeCraft: {
        AppLocalization.enUS.name: 'Craft',
        AppLocalization.zhTW.name: '製作',
      },
      appSelectorPageTypeAbout: {
        AppLocalization.enUS.name: 'About',
        AppLocalization.zhTW.name: '關於',
      },
    },
  );

  String get i18n => localize(this, _t);
}
