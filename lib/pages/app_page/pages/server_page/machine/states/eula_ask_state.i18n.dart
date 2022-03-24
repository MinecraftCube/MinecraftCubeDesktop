import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const eulaAskAgreeProgress = 'eulaAskAgreeProgress';
const eulaAskAgreeSuccess = 'eulaAskAgreeSuccess';
const eulaAskAgreeFailure = 'eulaAskAgreeFailure';
const eulaAskDisagree = 'eulaAskDisagree';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      eulaAskAgreeProgress: {
        AppLocalization.enUS.name: 'Agree Eula...',
        AppLocalization.zhTW.name: '同意終端用戶協議...',
      },
      eulaAskAgreeSuccess: {
        AppLocalization.enUS.name: 'Pass...',
        AppLocalization.zhTW.name: '完成',
      },
      eulaAskAgreeFailure: {
        AppLocalization.enUS.name: 'Failure...',
        AppLocalization.zhTW.name: '失敗',
      },
      eulaAskDisagree: {
        AppLocalization.enUS.name: 'Not agree, then check eula.txt manually.',
        AppLocalization.zhTW.name: '不同意終端用戶協議...請自行閱讀專案下的 eula.txt',
      }
    },
  );

  String get i18n => localize(this, _t);
}
