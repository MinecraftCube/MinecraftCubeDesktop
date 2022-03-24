import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _buildPage = Translations.byLocale('en_us') +
      {
        'en_us': {
          'Back': 'Back',
          'Instruction:': 'Instruction:',
          'Next': 'Next',
          'Step 2．Description for installer':
              'Step 2．Description for installer',
          '① Breif': '① Breif',
          '''Description is for introduce other player to understand. Currently, It's not displayed, because I can't find where to display (´_ゝ`)''':
              '''Description is for introduce other player to understand. Currently, It's not displayed, because I can't find where to display (´_ゝ`)''',
          'Step 1．Name your Installer': 'Step 1．Name your Installer',
          '① Installer name': '① Installer name',
          'ex. Unfair_1.12.2_vanilla': 'ex. Unfair_1.12.2_vanilla',
          '\'Installer name\'': '\'Installer name\'',
          'will become': 'will become',
          '\'File name\'.dmc': '\'File name\'.dmc',
          ', It is recommended to name It as ':
              ', It is recommended to name It as ',
          '{NAME_VERSION_(TYPE)}': '{NAME_VERSION_(TYPE)}',
          ',\nFor example, to build a unfair minecraft installer, ':
              ',\nFor example, to build a unfair minecraft installer, ',
          'Unfair_1.12.2_vanilla': 'Unfair_1.12.2_vanilla',
          ' or ': ' or ',
          'Unfair_1.12.2': 'Unfair_1.12.2',
          ' is better to management and help others know which version for client side.':
              ' is better to management and help others know which version for client side.',
          'Step 5．URL of map pack': 'Step 5．URL of map pack',
          '① \'Direct\' download path': '① \'Direct\' download path',
          '''If you don't know how to make a map pack, please see ''':
              '''If you don't know how to make a map pack, please see ''',
          '''How to make installer (Sorry, It's Chinese)''':
              '''How to make installer (Sorry, It's Chinese)''',
          ', Timestamp is marked!\n Please notice, must be zip and the structure of file is a single World and server.properties.':
              ', Timestamp is marked!\n Please notice, must be zip and the structure of file is a single World and server.properties.',
          '''Step 6．Models' info''': '''Step 6．Models' info''',
          '① All models': '① All models',
          '''Don't know how to do? Please see ''':
              '''Don't know how to do? Please see ''',
          ', Timestamp is marked!\n (Direct download url must end with .jar)':
              ', Timestamp is marked!\n (Direct download url must end with .jar)',
          'Model name:': 'Model name:',
          'Please enter the name for model': 'Please enter the name for model',
          'Model program name:': 'Model program name:',
          'Please enter the program name for model':
              'Please enter the program name for model',
          'Model download url:': 'Model download url:',
          'Please enter the \'direct\' download path':
              'Please enter the \'direct\' download path',
          'Step 3．Select server type': 'Step 3．Select server type',
          '① server type': '① server type',
          'Supported server type is ': 'Supported server type is ',
          'Vanilla ': 'Vanilla ',
          'and ': 'and ',
          'Forge': 'Forge',
          ''', \nIf you don't know which to choose, could see ''':
              ''', \nIf you don't know which to choose, could see ''',
          'Multiplayer model (Chinese)': 'Multiplayer model (Chinese)',
          ' OR ': ' OR ',
          'Build a minecraft server from zero (Chinese)':
              'Build a minecraft server from zero (Chinese)',
          '.\n': '.\n',
          'For simple, want to play some model, go Forge, otherwise, Vanilla, or ask the map/plugin author which should choose!':
              'For simple, want to play some model, go Forge, otherwise, Vanilla, or ask the map/plugin author which should choose!',
          'Please select a server type': 'Please select a server type',
          'Step 4．Server download url': 'Step 4．Server download url',
          '① \'Direct\' download url': '① \'Direct\' download url',
          '''If you know nothing about direct download url, please see author's ''':
              '''If you know nothing about direct download url, please see author's ''',
          'How to make an installer(Chinese, Sorry...)':
              'How to make an installer(Chinese, Sorry...)',
          ',\n (Direct download url is a url that paste on Broswer, and could download It directly without any redirect.':
              ',\n (Direct download url is a url that paste on Broswer, and could download It directly without any redirect.',
          'Check installer again': 'Check installer again',
          'Press complete when no error': 'Press complete when no error',
          'Installer name': 'Installer name',
          'Description': 'Description',
          'Server Type': 'Server Type',
          'Server \'Direct\' Download Url': 'Server \'Direct\' Download Url',
          'Map \'Direct\' Download Url': 'Map \'Direct\' Download Url',
          'All model infomations': 'All model infomations',
          'Model Name': 'Model Name',
          'Model Program Name': 'Model Program Name',
          'Model  \'Direct\' Download Url': 'Model  \'Direct\' Download Url',
          'Please recheck to complete!\nThis action will override the ':
              'Please recheck to complete!\nThis action will override the ',
          'same name ': 'same name ',
          'of .dmc file, please be noticed If ':
              'of .dmc file, please be noticed If ',
          'you want to override existed file!\n':
              'you want to override existed file!\n',
          'In additional, remember to test in \'Manage\' page, and welcome to share the installer to ':
              'In additional, remember to test in \'Manage\' page, and welcome to share the installer to ',
          ' Minecraft Scepter Forum': ' Minecraft Scepter Forum',
          'http://bit.ly/mcscepterforum_tw': 'http://bit.ly/mcscepterforum_en',
          'Complete': 'Complete',
          'Direct download path:': 'Direct download path:',
          'Modpack path:': 'Modpack path:',
          'Description:': 'Description',
          'Modpack': 'Modpack',
          'Detail': 'Detail',
        },
        'zh_tw': {
          'Back': '回選單',
          'Instruction:': '說明：',
          'Next': '下一步',
          'Step 2．Description for installer': '步驟二、輸入安裝包敘述(選擇性)',
          '① Breif': '① 簡單敘述',
          '''Description is for introduce other player to understand. Currently, It's not displayed, because I can't find where to display (´_ゝ`)''':
              '敘述是為了介紹給其他小玩家使用。你問安裝的時候為什麼不顯示出來？找不到地方顯示啊(´_ゝ`)',
          'Step 1．Name your Installer': '步驟一、輸入安裝包名稱',
          '① Installer name': '① 安裝包名稱',
          'ex. Unfair_1.12.2_vanilla': 'ex. 你寧可v2_1.12.2_vanilla',
          '\'Installer name\'': '「安裝包名稱」',
          'will become': '會變成',
          '\'File name\'.dmc': '「檔案名稱」.dmc',
          ', It is recommended to name It as ': '，建議格式為',
          '{NAME_VERSION_(TYPE)}': '{名稱_版本號_(種類)}',
          ',\nFor example, to build a unfair minecraft installer, ':
              '，\n例如，製作你寧可製作包，',
          'Unfair_1.12.2_vanilla': '你寧可v2_1.12.2_Vanilla',
          ' or ': ' 或 ',
          'Unfair_1.12.2': '你寧可v2_1.12.2',
          ' is better to management and help others know which version for client side.':
              '，這樣除了可以讓下載者一目了然，也可以幫助自己管理安裝包哦！',
          'Step 5．URL of map pack': '步驟五、輸入地圖下載位置',
          '① \'Direct\' download path': '① 「直接」下載位置',
          '''If you don't know how to make a map pack, please see ''':
              '地圖包不知道怎麼做，請參考',
          '''How to make installer (Sorry, It's Chinese)''': '安裝包製作',
          ', Timestamp is marked!\n Please notice, must be zip and the structure of file is a single World and server.properties.':
              '！時間點都標好囉！\n再次提醒，請注意，必須是 zip 檔與其內架構為 world 與 單一 server.properties。\n因有部分玩家，把 world 資料夾亂更名，多說一次，資料夾名稱請保持 world ，且確認無中文雜檔，請參考影片教學...。',
          '''Step 6．Models' info''': '步驟六、填寫模組資訊',
          '① All models': '① 所有模組資訊',
          '''Don't know how to do? Please see ''': '模組不知道怎麼填寫，請參考',
          ', Timestamp is marked!\n (Direct download url must end with .jar)':
              '！時間點都標好囉！\n(直接下載連結必須有 .jar 為結尾，若有非 .jar 的直連需支援，請通知青雲測試)',
          'Model name:': '模組名稱:',
          'Please enter the name for model': '請輸入模組名稱',
          'Model program name:': '模組程式名:',
          'Please enter the program name for model': '請輸入模組程式名',
          'Model download url:': '模組下載位置:',
          'Please enter the \'direct\' download path': '請輸入直接下載位置',
          'Step 3．Select server type': '步驟三、選擇安裝包種類',
          '① server type': '① 選擇伺服器種類',
          'Supported server type is ': '伺服器目前僅支援',
          'Vanilla ': 'Vanilla (俗稱官方版)',
          'and ': '與',
          'Forge': 'Forge (模組版)',
          ''', \nIf you don't know which to choose, could see ''':
              '，\n對於這兩個有疑問可以參考',
          'Multiplayer model (Chinese)': '多人伺服器模組',
          ' OR ': '、',
          'Build a minecraft server from zero (Chinese)': '從無到有伺服器架設',
          '.\n': '。\n',
          'For simple, want to play some model, go Forge, otherwise, Vanilla, or ask the map/plugin author which should choose!':
              '簡單來說，需要模組用 Forge，不需要就選擇 Vanilla，如果是包裝別人的東西，直接問作者最快哦！',
          'Please select a server type': '  請選擇一個伺服器種類',
          'Step 4．Server download url': '步驟四、輸入伺服器下載位置',
          '① \'Direct\' download url': '① 「直接」下載位置',
          '''If you know nothing about direct download url, please see author's ''':
              '如果不知道什麼是直接下載位置，請看青雲的',
          'How to make an installer(Chinese, Sorry...)': '安裝包製作',
          ',\n (Direct download url is a url that paste on Broswer, and could download It directly without any redirect.':
              '！\n(直接下載連結必須可直接貼上瀏覽器下載，並以 .jar 結尾，若有非 .jar 的直連需支援，請通知青雲測試)',
          'Check installer again': '再次確認安裝包',
          'Press complete when no error': '無誤後請按完成',
          'Installer name': '安裝包名稱',
          'Description': '敘述',
          'Server Type': '伺服器類型',
          'Server \'Direct\' Download Url': '伺服器直接下載位置',
          'Map \'Direct\' Download Url': '地圖直接下載位置',
          'All model infomations': '所有模組資訊',
          'Model Name': '模組名稱',
          'Model Program Name': '模組程式名',
          'Model  \'Direct\' Download Url': '模組直接下載位置',
          'Please recheck to complete!\nThis action will override the ':
              '請詳細看過後按完成！\n這個操作會覆蓋資料夾中',
          'same name ': '相同名稱',
          'of .dmc file, please be noticed If ': '的 dmc 檔，請注意是否',
          'you want to override existed file!\n': '覆蓋已有的檔案！\n',
          'In additional, remember to test in \'Manage\' page, and welcome to share the installer to ':
              '此外，記得至「伺服器管理」測試，覺得不錯歡迎分享至',
          ' Minecraft Scepter Forum': '創世神權杖論壇',
          'http://bit.ly/mcscepterforum_tw': 'http://bit.ly/mcscepterforum_tw',
          'Complete': '完成',
          'Direct download path:': '直接下載連結:',
          'Modpack path:': '整合包下載連結:',
          'Description:': '敘述:',
          'Modpack': '整合包',
          'Detail': '詳細版',
        },
        'zh_cn': {
          'Back': '回选单',
          'Instruction:': '说明：',
          'Next': '下一步',
          'Step 2．Description for installer': '步骤二、输入安装包叙述(选择性)',
          '① Breif': '① 简单叙述',
          '''Description is for introduce other player to understand. Currently, It's not displayed, because I can't find where to display (´_ゝ`)''':
              '叙述是为了介绍给其他小玩家使用。你问安装的时候为什麽不显示出来？找不到地方显示啊(´_ゝ`)',
          'Step 1．Name your Installer': '步骤一、输入安装包名称',
          '① Installer name': '① 安装包名称',
          'ex. Unfair_1.12.2_vanilla': 'ex. 你宁可v2_1.12.2_vanilla',
          '\'Installer name\'': '「安装包名称」',
          'will become': '会变成',
          '\'File name\'.dmc': '「档案名称」.dmc',
          ', It is recommended to name It as ': '，建议格式为',
          '{NAME_VERSION_(TYPE)}': '{名称_版本号_(种类)}',
          ',\nFor example, to build a unfair minecraft installer, ':
              '，\n例如，製作你宁可製作包，',
          'Unfair_1.12.2_vanilla': '你宁可v2_1.12.2_Vanilla',
          ' or ': ' 或 ',
          'Unfair_1.12.2': '你宁可v2_1.12.2',
          ' is better to management and help others know which version for client side.':
              '，这样除了可以让下载者一目了然，也可以帮助自己管理安装包哦！',
          'Step 5．URL of map pack': '步骤五、输入地图下载位置',
          '① \'Direct\' download path': '① 「直接」下载位置',
          '''If you don't know how to make a map pack, please see ''':
              '地图包不知道怎麽做，请参考',
          '''How to make installer (Sorry, It's Chinese)''': '安装包製作',
          ', Timestamp is marked!\n Please notice, must be zip and the structure of file is a single World and server.properties.':
              '！时间点都标好囉！\n再次提醒，请注意，必须是 zip 档与其内架构为 world 与 单一 server.properties。\n因有部分玩家，把 world 资料夹乱更名，多说一次，资料夹名称请保持 world ，且确认无中文杂档，请参考影片教学...。',
          '''Step 6．Models' info''': '步骤六、填写模组资讯',
          '① All models': '① 所有模组资讯',
          '''Don't know how to do? Please see ''': '模组不知道怎麽填写，请参考',
          ', Timestamp is marked!\n (Direct download url must end with .jar)':
              '！时间点都标好囉！\n(直接下载连结必须有 .jar 为结尾，若有非 .jar 的直连需支援，请通知青云测试)',
          'Model name:': '模组名称:',
          'Please enter the name for model': '请输入模组名称',
          'Model program name:': '模组程式名:',
          'Please enter the program name for model': '请输入模组程式名',
          'Model download url:': '模组下载位置:',
          'Please enter the \'direct\' download path': '请输入直接下载位置',
          'Step 3．Select server type': '步骤三、选择安装包种类',
          '① server type': '① 选择伺服器种类',
          'Supported server type is ': '伺服器目前仅支援',
          'Vanilla ': 'Vanilla (俗称官方版)',
          'and ': '与',
          'Forge': 'Forge (模组版)',
          ''', \nIf you don't know which to choose, could see ''':
              '，\n对于这两个有疑问可以参考',
          'Multiplayer model (Chinese)': '多人伺服器模组',
          ' OR ': '、',
          'Build a minecraft server from zero (Chinese)': '从无到有伺服器架设',
          '.\n': '。\n',
          'For simple, want to play some model, go Forge, otherwise, Vanilla, or ask the map/plugin author which should choose!':
              '简单来说，需要模组用 Forge，不需要就选择 Vanilla，如果是包装别人的东西，直接问作者最快哦！',
          'Please select a server type': '  请选择一个伺服器种类',
          'Step 4．Server download url': '步骤四、输入伺服器下载位置',
          '① \'Direct\' download url': '① 「直接」下载位置',
          '''If you know nothing about direct download url, please see author's ''':
              '如果不知道什麽是直接下载位置，请看青云的',
          'How to make an installer(Chinese, Sorry...)': '安装包製作',
          ',\n (Direct download url is a url that paste on Broswer, and could download It directly without any redirect.':
              '！\n(直接下载连结必须可直接贴上浏览器下载，并以 .jar 结尾，若有非 .jar 的直连需支援，请通知青云测试)',
          'Check installer again': '再次确认安装包',
          'Press complete when no error': '无误后请按完成',
          'Installer name': '安装包名称',
          'Description': '叙述',
          'Server Type': '伺服器类型',
          'Server \'Direct\' Download Url': '伺服器直接下载位置',
          'Map \'Direct\' Download Url': '地图直接下载位置',
          'All model infomations': '所有模组资讯',
          'Model Name': '模组名称',
          'Model Program Name': '模组程式名',
          'Model  \'Direct\' Download Url': '模组直接下载位置',
          'Please recheck to complete!\nThis action will override the ':
              '请详细看过后按完成！\n这个操作会复盖资料夹中',
          'same name ': '相同名称',
          'of .dmc file, please be noticed If ': '的 dmc 档，请注意是否',
          'you want to override existed file!\n': '复盖已有的档案！\n',
          'In additional, remember to test in \'Manage\' page, and welcome to share the installer to ':
              '此外，记得至「伺服器管理」测试，觉得不错欢迎分享至',
          ' Minecraft Scepter Forum': '创世神权杖论坛',
          'http://bit.ly/mcscepterforum_tw': 'http://bit.ly/mcscepterforum_tw',
          'Complete': '完成',
          'Direct download path:': '直接下载连结:',
          'Modpack path:': '整合包下载连结:',
          'Description:': '叙述:',
          'Modpack': '整合包',
          'Detail': '详细版',
        }
      };

  String get i18n => localize(this, _buildPage);
}
