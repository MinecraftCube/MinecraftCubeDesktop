import 'package:cube_api/cube_api.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/app_cube_properties.i18n.dart';

Iterable<CommonProperty> getAppCubeProperties() {
  return [
    StringServerProperty(
      name: cubeJava.i18n,
      fieldName: 'Java',
      value: 'java',
      selectables: {
        cubeSystemjava.i18n: 'java',
      },
      description: cubeJavaDesc.i18n,
    ),
    StringServerProperty(
      name: cubeXmx.i18n,
      fieldName: 'Xmx',
      value: '4g',
      description: cubeXmxDesc.i18n,
    ),
    StringServerProperty(
      name: cubeXms.i18n,
      fieldName: 'Xms',
      value: '256m',
      description: cubeXmsDesc.i18n,
    )
  ];
}
