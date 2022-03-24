import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const serverPageCreationDialogSelectInstaller =
    'serverPageCreationDialogSelectInstaller';
const serverPageCreationDialogServerName = 'serverPageCreationDialogServerName';
const serverPageCreationDialogBack = 'serverPageCreationDialogBack';
const serverPageCreationDialogCreate = 'serverPageCreationDialogCreate';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      serverPageCreationDialogSelectInstaller: {
        AppLocalization.enUS.name: 'Installer',
        AppLocalization.zhTW.name: '選擇安裝包',
      },
      serverPageCreationDialogServerName: {
        AppLocalization.enUS.name: 'Server Name',
        AppLocalization.zhTW.name: '請輸入伺服器名稱',
      },
      serverPageCreationDialogBack: {
        AppLocalization.enUS.name: 'Back',
        AppLocalization.zhTW.name: '返回',
      },
      serverPageCreationDialogCreate: {
        AppLocalization.enUS.name: 'Create',
        AppLocalization.zhTW.name: '建立',
      },
    },
  );

  String get i18n => localize(this, _t);
}
