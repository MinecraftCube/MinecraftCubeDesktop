import 'package:cube_api/cube_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/description_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/installer_name_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/map_download_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/mod_pack_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/mod_setting_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/preview_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/server_download_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/server_type_page.dart';
import 'package:server_management_repository/server_management_repository.dart';

class CraftNaviPage extends StatelessWidget {
  const CraftNaviPage({
    Key? key,
    required this.onMenuPressed,
  }) : super(key: key);
  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NaviPageBloc(
        installerCreatorRepository: context.read<InstallerCreatorRepository>(),
        launcherRepository: context.read<LauncherRepository>(),
        serverManagementRepository: context.read<ServerManagementRepository>(),
      ),
      child: CraftNaviPageView(
        onMenuPressed: onMenuPressed,
      ),
    );
  }
}

class CraftNaviPageView extends StatefulWidget {
  const CraftNaviPageView({
    Key? key,
    required this.onMenuPressed,
  }) : super(key: key);
  final VoidCallback onMenuPressed;

  @override
  State<StatefulWidget> createState() => _CraftNaviPageViewState();
}

enum NaviPageType {
  installerName,
  description,
  serverType,
  serverDownload,
  mapDownload,
  modelSettings,
  modpack,
  preview
}

class _CraftNaviPageViewState extends State<CraftNaviPageView> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: NaviPageType.installerName.index,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double itemHeight = 180;
    // final double itemWidth = MediaQuery.of(context).size.width / 2;
    // TextStyle _ = Theme.of(context)
    //     .textTheme
    //     .titleLarge
    //     .copyWith(color: ColorPalette.primaryColor);

    void onMenuPressed() {
      _pageController.jumpToPage(NaviPageType.installerName.index);
      widget.onMenuPressed();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 1600),
      decoration: BoxDecoration(
        // color: ColorPalette.fontColor,
        borderRadius: BorderRadius.circular(4),
      ),
      // child: TextButton(
      //   child: Text(''),
      //   onPressed: () => widget.onMenuPressed(),
      // ),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          InstallerNameNaviPage(
            // bloc: _bloc,
            onNext: () {
              _pageController.jumpToPage(NaviPageType.description.index);
            },
            // onPrevious: () {
            //   // page = NaviPageType.values[_page.index - 1];
            // },
            onReturn: onMenuPressed,
          ),
          DescriptionNaviPage(
            onNext: () {
              _pageController.jumpToPage(NaviPageType.serverType.index);
            },
            onPrevious: () {
              _pageController.jumpToPage(NaviPageType.installerName.index);
            },
            onReturn: onMenuPressed,
          ),
          // // _getDescriptionView(context),
          // //_getServeTypeView(context),
          ServerTypeNaviPage(
            onNext: () {
              _pageController.jumpToPage(NaviPageType.serverDownload.index);
            },
            onPrevious: () {
              _pageController.jumpToPage(NaviPageType.description.index);
            },
            onReturn: onMenuPressed,
          ),
          // // _getServerDownloadView(context),
          ServerDownloadNaviPage(
            onNext: () {
              _pageController.jumpToPage(NaviPageType.mapDownload.index);
            },
            onPrevious: () {
              _pageController.jumpToPage(NaviPageType.serverType.index);
            },
            onReturn: onMenuPressed,
          ),
          // // _getMapDownloadView(context),
          MapDownloadNaviPage(
            onNext: () {
              // Might be modpack
              NaviPageState state = context.read<NaviPageBloc>().state;
              if (state.type == JarType.forgeInstaller) {
                if (state.settings.isNotEmpty) {
                  _pageController.jumpToPage(NaviPageType.modelSettings.index);
                } else {
                  _pageController.jumpToPage(NaviPageType.modpack.index);
                }
              } else {
                _pageController.jumpToPage(NaviPageType.preview.index);
              }
            },
            onPrevious: () {
              _pageController.jumpToPage(NaviPageType.serverDownload.index);
            },
            onReturn: onMenuPressed,
          ),
          // //_getModelSettingsView(context)
          ModelSettingNaviPage(
            onSwitchMode: () {
              _pageController.jumpToPage(NaviPageType.modpack.index);
            },
            onNext: () {
              _pageController.jumpToPage(NaviPageType.preview.index);
            },
            onPrevious: () {
              _pageController.jumpToPage(NaviPageType.mapDownload.index);
            },
            onReturn: onMenuPressed,
          ),
          ModpackNaviPage(
            onSwitchMode: () {
              _pageController.jumpToPage(NaviPageType.modelSettings.index);
            },
            onNext: () {
              _pageController.jumpToPage(NaviPageType.preview.index);
            },
            onPrevious: () {
              _pageController.jumpToPage(NaviPageType.mapDownload.index);
            },
            onReturn: onMenuPressed,
          ),
          PreviewBuildPage(
            onNext: () {
              // _pageController.jumpToPage(NaviPageType.preview.index);
            },
            onPrevious: () {
              NaviPageState state = context.read<NaviPageBloc>().state;
              if (state.type == JarType.forgeInstaller) {
                if (state.settings.isNotEmpty) {
                  _pageController.jumpToPage(NaviPageType.modelSettings.index);
                } else {
                  _pageController.jumpToPage(NaviPageType.modpack.index);
                }
              } else {
                _pageController.jumpToPage(NaviPageType.mapDownload.index);
              }
              // check which jarType, modelSettings, modpack
              // _pageController.jumpToPage(NaviPageType.mapDownload.index);
            },
            onReturn: onMenuPressed,
          ),
        ],
      ),
    );
  }
}
