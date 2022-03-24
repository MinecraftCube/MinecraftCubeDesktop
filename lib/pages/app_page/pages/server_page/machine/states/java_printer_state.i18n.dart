import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const javaPrinterProgress = 'javaPrinterProgress';
const javaPrinterSuccess = 'javaPrinterSuccess';
const javaPrinterFailure = 'javaPrinterFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      javaPrinterProgress: {
        AppLocalization.enUS.name: 'Dump java version...',
        AppLocalization.zhTW.name: '傾印 Java 版本...',
      },
      javaPrinterSuccess: {
        AppLocalization.enUS.name: 'Dump complete...',
        AppLocalization.zhTW.name: '傾印完成',
      },
      javaPrinterFailure: {
        AppLocalization.enUS.name: 'Dump Failure...',
        AppLocalization.zhTW.name: '傾印失敗',
      },
    },
  );

  String get i18n => localize(this, _t);
}
