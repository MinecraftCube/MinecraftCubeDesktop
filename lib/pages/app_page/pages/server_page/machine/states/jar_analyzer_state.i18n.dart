import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const jarAnalyzerProgress = 'jarAnalyzerProgress';
const jarAnalyzerSuccess = 'jarAnalyzerSuccess';
const jarAnalyzerFailure = 'jarAnalyzerFailure';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      jarAnalyzerProgress: {
        AppLocalization.enUS.name: 'Analyze executors...',
        AppLocalization.zhTW.name: '分析執行檔...',
      },
      jarAnalyzerSuccess: {
        AppLocalization.enUS.name: 'Analyze Complete...',
        AppLocalization.zhTW.name: '分析完成',
      },
      jarAnalyzerFailure: {
        AppLocalization.enUS.name: 'Failure...',
        AppLocalization.zhTW.name: '分析失敗',
      },
    },
  );

  String get i18n => localize(this, _t);
}
