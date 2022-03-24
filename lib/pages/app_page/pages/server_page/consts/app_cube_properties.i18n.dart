import 'package:i18n_extension/i18n_extension.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const cubeJava = 'cube-java';
const cubeSystemjava = 'cube-system-java';
const cubeXmx = 'cube-xmx';
const cubeXms = 'cube-xms';

const cubeJavaDesc = 'cube-java-desc';
const cubeXmxDesc = 'cube-xmx-desc';
const cubeXmsDesc = 'cube-xms-desc';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      cubeSystemjava: {
        AppLocalization.enUS.name: 'Java(System)',
        AppLocalization.zhTW.name: 'Java(系統)',
      },
      cubeJava: {
        AppLocalization.enUS.name: 'Java',
        AppLocalization.zhTW.name: 'Java',
      },
      cubeJavaDesc: {
        AppLocalization.enUS.name: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
        AppLocalization.zhTW.name: '''
允許使用自製 java

可以在專案底下 java 資料夾加入可攜版(portable) Java，
若要保持系統 java 請輸入'java'
''',
      },
      cubeXmx: {
        AppLocalization.enUS.name: 'Xmx',
        AppLocalization.zhTW.name: 'Xmx',
      },
      cubeXmxDesc: {
        AppLocalization.enUS.name: '''
set maximum Java heap size
''',
        AppLocalization.zhTW.name: '''
最大記憶體上限參數
''',
      },
      cubeXms: {
        AppLocalization.enUS.name: 'Xms',
        AppLocalization.zhTW.name: 'Xms',
      },
      cubeXmsDesc: {
        AppLocalization.enUS.name: '''
set initial Java heap size
''',
        AppLocalization.zhTW.name: '''
初始記憶體大小
''',
      },
    },
  );

  String get i18n => localize(this, _t);
}
