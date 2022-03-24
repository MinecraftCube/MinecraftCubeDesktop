import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const languageDialogSelectLanguage = 'languageDialogSelectLanguage';
const languageDialogCancel = 'languageDialogCancel';
const languageDialogConfirm = 'languageDialogConfirm';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      languageDialogSelectLanguage: {
        AppLocalization.enUS.name: 'Select Lang',
        AppLocalization.zhTW.name: '選擇語言',
      },
      languageDialogCancel: {
        AppLocalization.enUS.name: 'Cancel',
        AppLocalization.zhTW.name: '取消',
      },
      languageDialogConfirm: {
        AppLocalization.enUS.name: 'Confirm',
        AppLocalization.zhTW.name: '確定',
      },
    },
  );

  String get i18n => localize(this, _t);
}
