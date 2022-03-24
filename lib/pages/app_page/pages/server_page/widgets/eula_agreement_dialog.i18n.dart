import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const serverPageEulaDialogTitle = 'serverPageEulaDialogTitle';
const serverPageEulaDialogNotify = 'serverPageEulaDialogNotify';
const serverPageEulaDialogEula = 'serverPageEulaDialogEula';
const serverPageEulaDialogReject = 'serverPageEulaDialogReject';
const serverPageEulaDialogAgree = 'serverPageEulaDialogAgree';
const serverPageEulaDialogDot = 'serverPageEulaDialogDot';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      serverPageEulaDialogTitle: {
        AppLocalization.enUS.name: 'Agree end-user license agreements',
        AppLocalization.zhTW.name: '同意終端用戶協議',
      },
      serverPageEulaDialogNotify: {
        AppLocalization.enUS.name: 'Please check for detail:',
        AppLocalization.zhTW.name: '請詳閱:',
      },
      serverPageEulaDialogEula: {
        AppLocalization.enUS.name: 'EULA',
        AppLocalization.zhTW.name: 'EULA',
      },
      serverPageEulaDialogReject: {
        AppLocalization.enUS.name: 'Reject',
        AppLocalization.zhTW.name: '拒絕',
      },
      serverPageEulaDialogAgree: {
        AppLocalization.enUS.name: 'Agree',
        AppLocalization.zhTW.name: '同意',
      },
      serverPageEulaDialogDot: {
        AppLocalization.enUS.name: '.',
        AppLocalization.zhTW.name: '。',
      },
    },
  );

  String get i18n => localize(this, _t);
}
