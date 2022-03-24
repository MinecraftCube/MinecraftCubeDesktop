import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const localizationZhTw = 'localizationZhTw';
const localizationEnUs = 'localizationEnUs';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      localizationZhTw: {
        AppLocalization.enUS.name: 'Traditional Chinese',
        AppLocalization.zhTW.name: '繁體中文',
      },
      localizationEnUs: {
        AppLocalization.enUS.name: 'English',
        AppLocalization.zhTW.name: '英文',
      },
    },
  );

  String get i18n => localize(this, _t);
}
