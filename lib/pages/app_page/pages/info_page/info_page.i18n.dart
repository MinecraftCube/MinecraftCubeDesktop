import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const infoPageTitleInfo = 'infoPageTitle';
const infoPageTitleNetwork = 'infoPageTitleNetwork';
const infoPageTitleSystem = 'infoPageTitleSystem';
const infoPageInfoHome = 'infoPageInfoHome';
const infoPageInfoLinkHome = 'infoPageInfoLinkHome';
const infoPageInfoForum = 'infoPageInfoForum';
const infoPageInfoLinkForum = 'infoPageInfoLinkForum';
const infoPageInfoChangeHistory = 'infoPageInfoChangeHistory';
const infoPageInfoChangeLanguage = 'infoPageInfoChangeLanguage';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      infoPageTitleInfo: {
        AppLocalization.enUS.name: 'Info',
        AppLocalization.zhTW.name: '資訊',
      },
      infoPageTitleNetwork: {
        AppLocalization.enUS.name: 'Network',
        AppLocalization.zhTW.name: '網路',
      },
      infoPageTitleSystem: {
        AppLocalization.enUS.name: 'System',
        AppLocalization.zhTW.name: '系統',
      },
      infoPageInfoHome: {
        AppLocalization.enUS.name: 'Official',
        AppLocalization.zhTW.name: '官網',
      },
      infoPageInfoLinkHome: {
        AppLocalization.enUS.name: 'http://bit.ly/mcscepter_en',
        AppLocalization.zhTW.name: 'http://bit.ly/mcscepter_tw',
      },
      infoPageInfoForum: {
        AppLocalization.enUS.name: 'Forum',
        AppLocalization.zhTW.name: '論壇',
      },
      infoPageInfoLinkForum: {
        AppLocalization.enUS.name: 'http://bit.ly/mcscepterforum_en',
        AppLocalization.zhTW.name: 'http://bit.ly/mcscepterforum_tw',
      },
      infoPageInfoChangeHistory: {
        AppLocalization.enUS.name: 'Changes',
        AppLocalization.zhTW.name: '改版資訊',
      },
      infoPageInfoChangeLanguage: {
        AppLocalization.enUS.name: 'Language',
        AppLocalization.zhTW.name: '語言',
      },
    },
  );

  String get i18n => localize(this, _t);
}
