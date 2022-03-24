import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const serverPagePropertyDialogTabServer = 'serverPagePropertyDialogTabServer';
const serverPagePropertyDialogTabAdvanced =
    'serverPagePropertyDialogTabAdvanced';
const serverPagePropertyDialogLeave = 'serverPagePropertyDialogLeave';
const serverPagePropertyDialogSave = 'serverPagePropertyDialogSave';
const serverPagePropertyDialogServerInfoFrom =
    'serverPagePropertyDialogServerInfoFrom';
const serverPagePropertyDialogFromMinecraftWiki =
    'serverPagePropertyDialogFromMinecraftWiki';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      serverPagePropertyDialogTabServer: {
        AppLocalization.enUS.name: 'Server',
        AppLocalization.zhTW.name: '伺服器',
      },
      serverPagePropertyDialogTabAdvanced: {
        AppLocalization.enUS.name: 'Advanced',
        AppLocalization.zhTW.name: '進階',
      },
      serverPagePropertyDialogLeave: {
        AppLocalization.enUS.name: 'Leave',
        AppLocalization.zhTW.name: '返回',
      },
      serverPagePropertyDialogSave: {
        AppLocalization.enUS.name: 'Save',
        AppLocalization.zhTW.name: '建立',
      },
      serverPagePropertyDialogServerInfoFrom: {
        AppLocalization.enUS.name: 'From: ',
        AppLocalization.zhTW.name: '資訊取自: ',
      },
      serverPagePropertyDialogFromMinecraftWiki: {
        AppLocalization.enUS.name: 'Minecraft Wiki',
        AppLocalization.zhTW.name: 'Minecraft Wiki',
      },
    },
  );

  String get i18n => localize(this, _t);
}
