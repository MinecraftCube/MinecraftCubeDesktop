import 'package:flutter/material.dart';
import 'package:minecraft_cube_desktop/_theme/color_palette.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/info_section.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/network_section.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/system_section.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/widgets/info_title.dart';

import 'info_page.i18n.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(
      height: 8,
    );
    return Container(
      padding: const EdgeInsets.all(12),
      color: ColorPalette.bgColor,
      child: ListView(
        primary: false,
        children: [
          InfoTitle(
            icon: Icons.home,
            title: infoPageTitleInfo.i18n,
          ),
          const InfoSection(),
          gap,
          InfoTitle(
            icon: Icons.wifi,
            title: infoPageTitleNetwork.i18n,
          ),
          const NetworkSection(),
          gap,
          InfoTitle(
            icon: Icons.computer,
            title: infoPageTitleSystem.i18n,
          ),
          const SystemSection(),
        ],
      ),
      // child: Column(
      //   children: const [
      //     Text('官網連結'),
      //     Text('論壇連結'),
      //     Text('改版資訊'),
      //     Text('語言'),
      //     Text('所有IP'),
      //     Text('系統使用率'),
      //     Text('GPU資訊'),
      //     Text('Java資訊'),
      //   ],
      // ),
    );
  }
}
