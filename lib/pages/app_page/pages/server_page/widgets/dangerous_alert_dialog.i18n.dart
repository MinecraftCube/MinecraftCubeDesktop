import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const serverPageJarDangerousDialogTitle = 'serverPageJarDangerousDialogTitle';
const serverPageJarDangerousDialogNotify = 'serverPageJarDangerousDialogNotify';
const serverPageJarDangerousDialogReject = 'serverPageJarDangerousDialogReject';
const serverPageJarDangerousDialogAgree = 'serverPageJarDangerousDialogAgree';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      serverPageJarDangerousDialogTitle: {
        AppLocalization.enUS.name: 'Unknown jar',
        AppLocalization.zhTW.name: '無法辨識的 jar',
      },
      serverPageJarDangerousDialogNotify: {
        AppLocalization.enUS.name:
            'Warning: you should take full care of this action, since this is not recognized as a valid jar.',
        AppLocalization.zhTW.name: '警告: 請注意此操作，無法辨識的 jar。',
      },
      serverPageJarDangerousDialogReject: {
        AppLocalization.enUS.name: 'Reject',
        AppLocalization.zhTW.name: '拒絕',
      },
      serverPageJarDangerousDialogAgree: {
        AppLocalization.enUS.name: 'Agree',
        AppLocalization.zhTW.name: '同意',
      },
    },
  );

  String get i18n => localize(this, _t);
}
