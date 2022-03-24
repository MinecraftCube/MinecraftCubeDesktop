import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const installationCreateProject = 'installationCreateProject';
const installationCopyInstaller = 'installationCopyInstaller';
const installationInstallMap = 'installationInstallMap';
const installationInstallMod = 'installationInstallMod';
const installationInstallModpack = 'installationInstallModpack';
const installationInstallServer = 'installationInstallServer';
const installationComplete = 'installationComplete';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      installationCreateProject: {
        AppLocalization.enUS.name: 'Create Project as %s ...',
        AppLocalization.zhTW.name: '建立專案 %s',
      },
      installationCopyInstaller: {
        AppLocalization.enUS.name: 'Copy installer from %s ...',
        AppLocalization.zhTW.name: '複製安裝包 %s',
      },
      installationInstallMap: {
        AppLocalization.enUS.name: 'Install map from %s',
        AppLocalization.zhTW.name: '安裝地圖 %s',
      },
      installationInstallMod: {
        AppLocalization.enUS.name: 'Install mod from %s',
        AppLocalization.zhTW.name: '安裝模組 %s',
      },
      installationInstallModpack: {
        AppLocalization.enUS.name: 'Install modpack from %s',
        AppLocalization.zhTW.name: '安裝模組包 %s',
      },
      installationInstallServer: {
        AppLocalization.enUS.name: 'Install server from %s',
        AppLocalization.zhTW.name: '安裝伺服器 %s',
      },
      installationComplete: {
        AppLocalization.enUS.name: 'Installation Complete',
        AppLocalization.zhTW.name: '安裝完畢',
      }
    },
  );

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
