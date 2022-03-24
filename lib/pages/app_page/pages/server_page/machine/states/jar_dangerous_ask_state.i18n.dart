import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const jarDangerousAskAgree = 'jarDangerousAskAgree';
const jarDangerousAskDisagree = 'jarDangerousAskDisagree';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      jarDangerousAskAgree: {
        AppLocalization.enUS.name: 'You agree to execute the jar...',
        AppLocalization.zhTW.name: '同意執行未知 jar...',
      },
      jarDangerousAskDisagree: {
        AppLocalization.enUS.name:
            'Not agree, please check the jar carefully...',
        AppLocalization.zhTW.name: '不同意，請至專案底下檢查 jar...',
      }
    },
  );

  String get i18n => localize(this, _t);
}
