import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const forgeInstallProgress = 'forgeInstallProgress';
const forgeInstallForgeSuccess = 'forgeInstallForgeSuccess';
const forgeInstallPassSuccess = 'forgeInstallPassSuccess';
const forgeInstallFailure = 'forgeInstallFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      forgeInstallProgress: {
        AppLocalization.enUS.name: 'Check forge...',
        AppLocalization.zhTW.name: '檢查 forge...',
      },
      forgeInstallForgeSuccess: {
        AppLocalization.enUS.name: 'Install forge successfuuly...',
        AppLocalization.zhTW.name: '成功安裝 forge',
      },
      forgeInstallPassSuccess: {
        AppLocalization.enUS.name: 'Pass forge...',
        AppLocalization.zhTW.name: '通過 forge...',
      },
      forgeInstallFailure: {
        AppLocalization.enUS.name: 'Process forge failure...',
        AppLocalization.zhTW.name: '處理 forge 時發生錯誤',
      },
    },
  );

  String get i18n => localize(this, _t);
}
