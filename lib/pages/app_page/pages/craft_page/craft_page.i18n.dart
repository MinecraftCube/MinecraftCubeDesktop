import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftPageInstaller = 'craftPageInstaller';
const craftPageManual = 'craftPageManual';
const craftPageSelectAnApproach = 'craftPageSelectAnApproach';
const craftPagePlaylist = 'craftPagePlaylist';
const craftPageCreate = 'craftPageCreate';
const craftPageInstallerDesc = 'craftPageServerInstallerFolder';
const craftPageManualDescFollowing = 'craftPageManualDescFollowing';
const craftPageManualDescFollowingA = 'craftPageManualDescFollowingA';
const craftPageManualDescFollowingB = 'craftPageManualDescFollowingB';
const craftPageManualDescFollowingC = 'craftPageManualDescFollowingC';
const craftPageLineBreak = 'craftPageeLineBreak';
const craftPageManualDescIntegrate = 'craftPageManualDescIntegrate';
const craftPageManualDescIntegrateA = 'craftPageManualDescIntegrateA';
const craftPageManualDescIntegrateB = 'craftPageManualDescIntegrateB';
const craftPageManualDescIntegrateC = 'craftPageManualDescIntegrateC';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftPageInstaller: {
        AppLocalization.enUS.name: 'Installer',
        AppLocalization.zhTW.name: '安裝包',
      },
      craftPageManual: {
        AppLocalization.enUS.name: 'Manual',
        AppLocalization.zhTW.name: '手動',
      },
      craftPageSelectAnApproach: {
        AppLocalization.enUS.name: 'Select an approach',
        AppLocalization.zhTW.name: '選擇製作伺服器的方式',
      },
      craftPagePlaylist: {
        AppLocalization.enUS.name: 'Playlist',
        AppLocalization.zhTW.name: '播放清單',
      },
      craftPageCreate: {
        AppLocalization.enUS.name: 'Create',
        AppLocalization.zhTW.name: '開始製作',
      },
      craftPageInstallerDesc: {
        AppLocalization.enUS.name:
            'By defining server, map, mods, upload...etc.\n This mode help you make a reusable installer and share with everyone.❤️',
        AppLocalization.zhTW.name:
            '藉由定義伺服器、地圖、模組、上傳...等。\n這個模式可以用來製作，可重複使用與分享❤️的安裝包。',
      },
      craftPageManualDescFollowing: {
        AppLocalization.enUS.name:
            'Select this method If you are the following:\n',
        AppLocalization.zhTW.name: '選擇此模式，如果你有下列幾種狀況：\n',
      },
      craftPageManualDescFollowingA: {
        AppLocalization.enUS.name: '1. Lazy to create a installer.\n',
        AppLocalization.zhTW.name: '1. 懶得製作安裝包\n',
      },
      craftPageManualDescFollowingB: {
        AppLocalization.enUS.name: '2. Have an existed server.\n',
        AppLocalization.zhTW.name: '2. 已經有伺服器\n',
      },
      craftPageManualDescFollowingC: {
        AppLocalization.enUS.name:
            '3. Unsupported server type for installer (ex. spigot)\n',
        AppLocalization.zhTW.name: '3. 安裝包製作不支援的伺服器類型 (例如. spigot) \n',
      },
      craftPageLineBreak: {
        AppLocalization.enUS.name: '\n',
        AppLocalization.zhTW.name: '\n',
      },
      craftPageManualDescIntegrate: {
        AppLocalization.enUS.name: 'How to integrate?\n',
        AppLocalization.zhTW.name: '如何整合？\n',
      },
      craftPageManualDescIntegrateA: {
        AppLocalization.enUS.name:
            '1. Open servers folder (Not sure? there is an open button below in Server page)\n',
        AppLocalization.zhTW.name: '1. 開啟伺服器資料夾 (不知道在哪開啟？在伺服器頁面底下有按鈕)\n',
      },
      craftPageManualDescIntegrateB: {
        AppLocalization.enUS.name:
            '2. Create(or Copy) a folder that contained your server. Should match the relative path "servers/YourServer/yourserver.jar"\n',
        AppLocalization.zhTW.name:
            '2. 建立或複製一個包含伺服器主程式的資料夾，伺服器相依路徑必須為 "servers/任意伺服器專案名/server.jar"\n',
      },
      craftPageManualDescIntegrateC: {
        AppLocalization.enUS.name: '3. Enjoy.\n',
        AppLocalization.zhTW.name: '3. 完成.\n',
      },
    },
  );

  String get i18n => localize(this, _t);
}
