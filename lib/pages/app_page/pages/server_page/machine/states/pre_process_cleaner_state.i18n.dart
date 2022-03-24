import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const preProcessCleanerProgress = 'preProcessCleanerProgress';
const preProcessCleanerSuccess = 'preProcessCleanerSuccess';
const preProcessCleanerFailure = 'preProcessCleanerFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      preProcessCleanerProgress: {
        AppLocalization.enUS.name: 'Clean Process...',
        AppLocalization.zhTW.name: '清除程序...',
      },
      preProcessCleanerSuccess: {
        AppLocalization.enUS.name: 'Clean Success...',
        AppLocalization.zhTW.name: '清除完成',
      },
      preProcessCleanerFailure: {
        AppLocalization.enUS.name: 'Clean Failure...',
        AppLocalization.zhTW.name: '清除失敗',
      },
    },
  );

  String get i18n => localize(this, _t);
}
