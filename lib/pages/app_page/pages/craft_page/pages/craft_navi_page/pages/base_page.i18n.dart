import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const craftBasePageBack = 'craftBasePageBack';
const craftBasePageInstruction = 'craftBasePageInstruction';
const craftBasePageNext = 'craftInstallerNamePageNext';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      craftBasePageBack: {
        AppLocalization.enUS.name: 'Back',
        AppLocalization.zhTW.name: '回選單',
      },
      craftBasePageInstruction: {
        AppLocalization.enUS.name: 'Instruction:',
        AppLocalization.zhTW.name: '說明：',
      },
      craftBasePageNext: {
        AppLocalization.enUS.name: 'Next',
        AppLocalization.zhTW.name: '下一步',
      },
    },
  );

  String get i18n => localize(this, _t);
}
