import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const systemSectionCpu = 'systemSectionCpu';
const systemSectionRam = 'systemSectionRam';
const systemSectionGpu = 'systemSectionGpu';
const systemSectionSystemJava = 'systemSectionSystemJava';
const systemSectionSystemJavaLocations = 'systemSectionSystemJavaLocations';
const systemSectionSystemJavaInfos = 'systemSectionSystemJavaInfos';
const systemSectionPortableJava = 'systemSectionPortableJava';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      systemSectionCpu: {
        AppLocalization.enUS.name: 'CPU',
        AppLocalization.zhTW.name: '處理器',
      },
      systemSectionRam: {
        AppLocalization.enUS.name: 'RAM',
        AppLocalization.zhTW.name: '記憶體',
      },
      systemSectionGpu: {
        AppLocalization.enUS.name: 'GPU',
        AppLocalization.zhTW.name: '顯示卡',
      },
      systemSectionSystemJava: {
        AppLocalization.enUS.name: 'System Java',
        AppLocalization.zhTW.name: '系統 Java',
      },
      systemSectionSystemJavaLocations: {
        AppLocalization.enUS.name: 'Locations',
        AppLocalization.zhTW.name: '位置',
      },
      systemSectionSystemJavaInfos: {
        AppLocalization.enUS.name: 'Infos',
        AppLocalization.zhTW.name: '資訊',
      },
      systemSectionPortableJava: {
        AppLocalization.enUS.name: 'Portable Java',
        AppLocalization.zhTW.name: '獨立 Java',
      },
    },
  );

  String get i18n => localize(this, _t);
}
