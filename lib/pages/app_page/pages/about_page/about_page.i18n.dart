import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';

const aboutPageTitle = 'aboutPageTitle';

extension Localization on String {
  static final _t = Translations.from(
    AppLocalization.enUS.name,
    {
      aboutPageTitle: {
        AppLocalization.enUS.name: 'About app and creator',
        AppLocalization.zhTW.name: '關於軟體與作者',
      },
    },
  );

  String get i18n => localize(this, _t);
}

List<InlineSpan> getAppTextSpan() {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getAppTextSpanZhTW();
  } else {
    return _getAppTextSpanEnUS();
  }
}

List<InlineSpan> getAuthorTextSpan(
  VoidCallback onTapYoutube,
  TextTheme textTheme,
) {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getAuthorTextSpanZhTW(onTapYoutube, textTheme);
  } else {
    return _getAuthorTextSpanEnUS(onTapYoutube, textTheme);
  }
}

List<InlineSpan> _getAuthorTextSpanEnUS(
  VoidCallback onTapYoutube,
  TextTheme textTheme,
) {
  return [
    const TextSpan(text: 'Hey, I\'m '),
    TextSpan(
      text: 'Chinyun',
      style: TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Colors.yellow.shade100,
      ),
    ),
    const TextSpan(text: '!\n'),
    const TextSpan(
      text: 'The creator of this app, and a normal fullstack developer.\n',
    ),
    const TextSpan(
      text: 'Hope you enjoy your server. Have fun!\n',
    ),
    const TextSpan(
      text: '\n',
    ),
    const WidgetSpan(
      child: Icon(
        Icons.slideshow,
        color: Colors.red,
      ),
    ),
    TextSpan(
      text: 'Youtube',
      style: textTheme.subtitle1?.copyWith(color: Colors.red),
      recognizer: TapGestureRecognizer()..onTap = onTapYoutube,
    ),
  ];
}

List<InlineSpan> _getAuthorTextSpanZhTW(
  VoidCallback onTapYoutube,
  TextTheme textTheme,
) {
  return [
    const TextSpan(text: '嘿！我是'),
    TextSpan(
      text: '青雲',
      style: TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Colors.yellow.shade100,
      ),
    ),
    const TextSpan(text: '!\n'),
    const TextSpan(
      text: "本軟體開發者，也是個全端工程師。\n",
    ),
    const TextSpan(
      text: '廢話不多說，希望大家都簡單伺服器！祝愉快～\n',
    ),
    const TextSpan(
      text: '\n',
    ),
    const WidgetSpan(
      child: Icon(
        Icons.slideshow,
        color: Colors.red,
      ),
    ),
    TextSpan(
      text: 'Youtube',
      style: textTheme.subtitle1?.copyWith(color: Colors.red),
      recognizer: TapGestureRecognizer()..onTap = onTapYoutube,
    ),
  ];
}

List<InlineSpan> _getAppTextSpanEnUS() {
  return const [
    TextSpan(
      text: 'Minecraft Cube',
      style: TextStyle(
        color: Colors.yellowAccent,
        backgroundColor: Colors.black,
      ),
    ),
    TextSpan(text: '\n'),
    TextSpan(
      text: 'is the second generation of Minecraft Scepter.',
    ),
    TextSpan(
      text:
          ' Try to be the BEST server management tool for Minecraft Community!',
    ),
  ];
}

List<InlineSpan> _getAppTextSpanZhTW() {
  return const [
    TextSpan(
      text: '創世神魔方',
      style: TextStyle(
        color: Colors.yellowAccent,
        backgroundColor: Colors.black,
      ),
    ),
    TextSpan(text: '\n'),
    TextSpan(
      text: '是創世神權杖的第二代。',
    ),
    TextSpan(
      text: ' 朝向最佳的 Minecraft 伺服器管理工具邁進。',
    ),
  ];
}

List<InlineSpan> getSecretTextSpan() {
  final locale = I18n.locale;
  if (locale == AppLocalization.zhTW) {
    return _getSecretTextSpanZhTW();
  } else {
    return _getSecretTextSpanEnUS();
  }
}

List<InlineSpan> _getSecretTextSpanEnUS() {
  return const [
    TextSpan(
      text: 'Classic Trick, Hun?\n',
    ),
    TextSpan(
      text:
          'Oh Right, I\'ll talk more than above here. This app was made when I didn\'t have a full-time job, It cost me more than one month and even concentrate than a full-time job.\n',
    ),
    TextSpan(
      text: 'So... If you need a flutter dev, welcome to contact me :P\n',
    ),
    TextSpan(
      text:
          'App looks normal, but It\'s still hard! These words for the one who want to be developer in the future :(\n',
    ),
    TextSpan(
      text:
          'By the way, If you have any issue, please make an issue on github, others could send an email.',
    ),
  ];
}

List<InlineSpan> _getSecretTextSpanZhTW() {
  return const [
    TextSpan(
      text: '有沒有想起解謎地圖，麥塊的書....的經典玩法XD\n',
    ),
    TextSpan(
      text: '好吧! 這邊多說一點，這個軟體是在沒有正職工作且逼近996的一個半月完成的，算是比工作還認真的一個軟體。\n',
    ),
    TextSpan(
      text: '所以...話鋒一轉，如果有哪個公司缺 flutter 歡迎聯繫青雲 :P\n',
    ),
    TextSpan(
      text: '這個軟體的契機，主要是 2011 年開伺服器的時候，覺得怎麼沒有可以直接安裝無誤的懶人管理器，現在有能力就來開發看看。\n',
    ),
    TextSpan(
      text: '主要是參考原先未開源的創世神權杖所重寫，除了介面的視覺參考部分，核心幾乎是九成九的風雲色變，所以才花上這巨量的時間。\n',
    ),
    TextSpan(
      text: '也有這段經歷，也想著未來如果開付費課有沒有人想上呢～',
    ),
    TextSpan(
      text:
          '看了一堆沒頭沒尾的，只是想幫各位補充一下開發一款軟體的辛酸，希望有想當工程師的引以為戒(X)。那祝各位玩得愉快～有軟體問題請至 Github 發 issue 詢問，若是其他問題請信箱聯繫。',
    ),
  ];
}
