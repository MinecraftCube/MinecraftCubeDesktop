import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const appTitle = 'appTitle';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      appTitle: {
        AppLocalization.enUS.name: 'Minecraft Cube',
        AppLocalization.zhTW.name: '創世神魔方',
      },
    },
  );

  String get i18n => localize(this, _t);
}
