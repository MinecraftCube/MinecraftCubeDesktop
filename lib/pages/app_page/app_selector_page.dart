import 'package:flutter/material.dart';
import 'package:minecraft_cube_desktop/_theme/color_palette.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/about_page/about_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/craft_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/info_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/server_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/widgets/app_selector.dart';
import 'package:window_size/window_size.dart' as appWindow;

import 'app_selector_page.i18n.dart';

enum AppSelectorPageType { info, server, craft, about }

extension AppSelectorPageTypeExt on AppSelectorPageType {
  String get name {
    switch (this) {
      case AppSelectorPageType.info:
        return appSelectorPageTypeInfo.i18n;
      case AppSelectorPageType.server:
        return appSelectorPageTypeServer.i18n;
      case AppSelectorPageType.craft:
        return appSelectorPageTypeCraft.i18n;
      case AppSelectorPageType.about:
        return appSelectorPageTypeAbout.i18n;
      default:
        return 'Unimplement';
    }
  }

  IconData get icon {
    switch (this) {
      case AppSelectorPageType.info:
        return Icons.view_module;
      case AppSelectorPageType.server:
        return Icons.kitchen;
      case AppSelectorPageType.craft:
        return Icons.build;
      case AppSelectorPageType.about:
        return Icons.ac_unit;
      default:
        throw UnimplementedError();
    }
  }

  Color get iconColor {
    switch (this) {
      case AppSelectorPageType.info:
        return Colors.green;
      case AppSelectorPageType.server:
        return Colors.blueAccent;
      case AppSelectorPageType.craft:
        return Colors.black26;
      case AppSelectorPageType.about:
        return const Color(0x88fff176);
      default:
        throw UnimplementedError();
    }
  }

  Color get iconActiveColor {
    switch (this) {
      case AppSelectorPageType.info:
        return Colors.greenAccent;
      case AppSelectorPageType.server:
        return Colors.blue;
      case AppSelectorPageType.craft:
        return Colors.white;
      case AppSelectorPageType.about:
        return Colors.yellow;
      default:
        throw UnimplementedError();
    }
  }
}

class AppSelectorPage extends StatefulWidget {
  const AppSelectorPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AppSelectorPage> createState() => _AppSelectorPageState();
}

class _AppSelectorPageState extends State<AppSelectorPage> {
  late AppSelectorPageType _pageType;
  late PageController _pageController;
  @override
  void initState() {
    _pageType = AppSelectorPageType.info;
    _pageController = PageController(
      initialPage: AppSelectorPageType.info.index,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appWindow.setWindowTitle(appTitle.i18n);
    return Scaffold(
      backgroundColor: ColorPalette.bgColor,
      body: Row(
        children: [
          AppSelector(
            pageType: _pageType,
            onPageChanged: (p) {
              setState(() {
                _pageType = p;
                _pageController.jumpToPage(p.index);
              });
            },
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                InfoPage(),
                ServerPage(),
                CraftPage(),
                AboutPage()
              ],
            ),
          )
        ],
      ),
    );
  }
}
