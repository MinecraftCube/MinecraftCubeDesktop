import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const serverStateProgress = 'serverStateProgress';
const serverStateSuccess = 'serverStateSuccess';
const serverStateExitCodeFailure = 'serverStateExitCodeFailure';
const serverStateUnexpectedFailure = 'serverStateUnexpectedFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      serverStateProgress: {
        AppLocalization.enUS.name: 'Starting Server...',
        AppLocalization.zhTW.name: '啟動伺服器...',
      },
      serverStateSuccess: {
        AppLocalization.enUS.name: 'Server close safely.',
        AppLocalization.zhTW.name: '伺服器安全關閉',
      },
      serverStateExitCodeFailure: {
        AppLocalization.enUS.name: 'Server Close unexpectedly(1)',
        AppLocalization.zhTW.name: '無法預期的關閉(1)',
      },
      serverStateUnexpectedFailure: {
        AppLocalization.enUS.name: 'Server Close unexpectedly(2)',
        AppLocalization.zhTW.name: '無法預期的關閉(2)',
      },
    },
  );

  String get i18n => localize(this, _t);
}
