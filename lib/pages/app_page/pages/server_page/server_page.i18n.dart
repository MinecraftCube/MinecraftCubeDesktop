import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const serverPageCommandInput = 'serverPageCommandInput';
const serverPageSelectServer = 'serverPageSelectServer';
const serverPageServerStop = 'serverPageServerStop';
const serverPageServerStart = 'serverPageServerStart';
const serverPageServerCreate = 'serverPageServerCreate';
const serverPageServerInstallersFolder = 'serverPageServerInstallerFolder';
const serverPageServerServersFolder = 'serverPageServerServersFolder';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      serverPageCommandInput: {
        AppLocalization.enUS.name: 'Command:',
        AppLocalization.zhTW.name: '請輸入指令:',
      },
      serverPageSelectServer: {
        AppLocalization.enUS.name: 'Server',
        AppLocalization.zhTW.name: '選擇伺服器',
      },
      serverPageServerStop: {
        AppLocalization.enUS.name: 'Stop',
        AppLocalization.zhTW.name: '停止',
      },
      serverPageServerStart: {
        AppLocalization.enUS.name: 'Start',
        AppLocalization.zhTW.name: '啟動',
      },
      serverPageServerCreate: {
        AppLocalization.enUS.name: 'Create',
        AppLocalization.zhTW.name: '新增伺服器',
      },
      serverPageServerInstallersFolder: {
        AppLocalization.enUS.name: 'Installers Dir',
        AppLocalization.zhTW.name: '安裝包資料夾',
      },
      serverPageServerServersFolder: {
        AppLocalization.enUS.name: 'Servers Dir',
        AppLocalization.zhTW.name: '伺服器資料夾',
      },
    },
  );

  String get i18n => localize(this, _t);
}
