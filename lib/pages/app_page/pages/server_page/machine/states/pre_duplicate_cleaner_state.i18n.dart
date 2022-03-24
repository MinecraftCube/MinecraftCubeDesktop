import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const preDuplicateCleanerProgress = 'preDuplicateCleanerProgress';
const preDuplicateCleanerSuccess = 'preDuplicateCleanerSuccess';
const preDuplicateCleanerFailure = 'preDuplicateCleanerFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      preDuplicateCleanerProgress: {
        AppLocalization.enUS.name: 'Clean Duplicates...',
        AppLocalization.zhTW.name: '清除複製體...',
      },
      preDuplicateCleanerSuccess: {
        AppLocalization.enUS.name: 'Clean Success...',
        AppLocalization.zhTW.name: '清除完成',
      },
      preDuplicateCleanerFailure: {
        AppLocalization.enUS.name: 'Clean Failure...',
        AppLocalization.zhTW.name: '清除失敗',
      },
    },
  );

  String get i18n => localize(this, _t);
}
