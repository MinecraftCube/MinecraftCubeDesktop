import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const eulaStageProgress = 'eulaStageProgress';
const eulaStageSuccess = 'eulaStageSuccess';
const eulaStageFailure = 'eulaStageFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      eulaStageProgress: {
        AppLocalization.enUS.name: 'Check Eula...',
        AppLocalization.zhTW.name: '檢查終端用戶協議...',
      },
      eulaStageSuccess: {
        AppLocalization.enUS.name: 'Pass...',
        AppLocalization.zhTW.name: '檢查完成',
      },
      eulaStageFailure: {
        AppLocalization.enUS.name: 'Failure...',
        AppLocalization.zhTW.name: '檢查失敗',
      },
    },
  );

  String get i18n => localize(this, _t);
}
