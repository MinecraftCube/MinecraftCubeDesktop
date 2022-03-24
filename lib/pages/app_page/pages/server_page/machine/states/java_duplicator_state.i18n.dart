import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const javaDuplicatorProgress = 'javaDuplicatorProgress';
const javaDuplicatorSuccess = 'javaDuplicatorSuccess';
const javaDuplicatorFailure = 'javaDuplicatorFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      javaDuplicatorProgress: {
        AppLocalization.enUS.name: 'Clone java executor...',
        AppLocalization.zhTW.name: '複製 Java...',
      },
      javaDuplicatorSuccess: {
        AppLocalization.enUS.name: 'Clone complete...',
        AppLocalization.zhTW.name: '複製完成...',
      },
      javaDuplicatorFailure: {
        AppLocalization.enUS.name: 'Clone Failure...',
        AppLocalization.zhTW.name: '複製失敗...',
      },
    },
  );

  String get i18n => localize(this, _t);
}
