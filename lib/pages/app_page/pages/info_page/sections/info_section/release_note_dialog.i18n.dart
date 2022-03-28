import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const releaseNoteDialogDownload = 'releaseNoteDialogDownload';
const releaseNotDialogDownloadLink = 'releaseNotDialogDownloadLink';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      releaseNoteDialogDownload: {
        AppLocalization.enUS.name: 'Download',
        AppLocalization.zhTW.name: '前往下載頁',
      },
      releaseNotDialogDownloadLink: {
        AppLocalization.enUS.name:
            'https://minecraftscepter.github.io/changelogs?lang=en',
        AppLocalization.zhTW.name:
            'https://minecraftscepter.github.io/changelogs?lang=zhTW',
      }
    },
  );

  String get i18n => localize(this, _t);
}
