import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const cancel = 'cancel';
const confirm = 'confirm';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      cancel: {
        AppLocalization.enUS.name: 'Cancel',
        AppLocalization.zhTW.name: '取消',
      },
      confirm: {
        AppLocalization.enUS.name: 'Confirm',
        AppLocalization.zhTW.name: '確認',
      },
    },
  );

  String get ci18n => localize(this, _t);
}
