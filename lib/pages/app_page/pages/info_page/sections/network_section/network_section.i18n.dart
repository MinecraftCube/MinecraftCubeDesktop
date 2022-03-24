import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const networkSectionPublicIp = 'networkSectionPublicIp';
const networkSectionInternalIp = 'networkSectionInternalIp';
const networkSectionGatewayIp = 'networkSectionGatewayIp';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      networkSectionPublicIp: {
        AppLocalization.enUS.name: 'Public Ip',
        AppLocalization.zhTW.name: '公開地址',
      },
      networkSectionInternalIp: {
        AppLocalization.enUS.name: 'Internal Ip',
        AppLocalization.zhTW.name: '內部地址',
      },
      networkSectionGatewayIp: {
        AppLocalization.enUS.name: 'Gateway Ip',
        AppLocalization.zhTW.name: '閘道地址',
      },
    },
  );

  String get i18n => localize(this, _t);
}
