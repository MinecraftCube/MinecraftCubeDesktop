import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const configurationLoaderProgress = 'configurationLoaderProgress';
const configurationLoaderSuccess = 'configurationLoaderSuccess';
const configurationLoaderFailure = 'configurationLoaderFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      configurationLoaderProgress: {
        AppLocalization.enUS.name: 'Load cube.properties...',
        AppLocalization.zhTW.name: '讀取 Cube 設定檔...',
      },
      configurationLoaderSuccess: {
        AppLocalization.enUS.name: 'Load Complete...',
        AppLocalization.zhTW.name: '讀取完成',
      },
      configurationLoaderFailure: {
        AppLocalization.enUS.name: 'Load Failure...',
        AppLocalization.zhTW.name: '讀取失敗',
      },
    },
  );

  String get i18n => localize(this, _t);
}
