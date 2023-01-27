import 'package:cube_api/cube_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/preview_page.i18n.dart';

class PreviewBuildPage extends NaviPageStatefulWidget {
  const PreviewBuildPage({
    Key? key,
    void Function()? onPrevious,
    required void Function() onNext,
    required void Function() onReturn,
  }) : super(
          key: key,
          onPrevious: onPrevious,
          onNext: onNext,
          onReturn: onReturn,
        );

  @override
  State createState() => _PreviewNaviPageState();
}

class _PreviewNaviPageState extends State<PreviewBuildPage> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()
      ..addListener(() {
        // widget.bloc.add(MPB.ModifyDescriptionEvent(_controller.text));
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    // TextStyle titleStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.primaryColor);
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextStyle? descriptionTitleStyle =
        textTheme.titleLarge?.copyWith(color: Colors.grey);
    // TextStyle descriptionStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.secondaryColor);

    return BlocBuilder<NaviPageBloc, NaviPageState>(
      builder: (context, state) {
        return BuildPageBasePage(
          title: craftPreviewPageTitle.i18n,
          subtitle: craftPreviewPageSubtitle.i18n,
          coreWidget: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colorScheme.secondary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text(craftPreviewPageInstallerName.i18n),
                  subtitle: Text(state.installerName),
                ),
                ListTile(
                  title: Text(craftPreviewPageDescription.i18n),
                  subtitle: Text(state.installerName),
                ),
                ListTile(
                  title: Text(craftPreviewPageServerType.i18n),
                  subtitle: Text(
                    state.type == JarType.forgeInstaller ? 'Forge' : 'Vanilla',
                  ),
                ),
                ListTile(
                  title: Text(craftPreviewPageServerDirectDownload.i18n),
                  subtitle: InkWell(
                    child: Text(
                      state.serverDownloadPath,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      context
                          .read<LauncherRepository>()
                          .launch(path: state.serverDownloadPath);
                    },
                  ),
                  onTap: null,
                ),
                if (state.mapDownloadPath.isNotEmpty)
                  ListTile(
                    title: Text(craftPreviewPageMapDirectDownload.i18n),
                    subtitle: InkWell(
                      child: Text(
                        state.mapDownloadPath,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        context
                            .read<LauncherRepository>()
                            .launch(path: state.mapDownloadPath);
                      },
                    ),
                    onTap: null,
                  ),
                if (state.pack != null)
                  ListTile(
                    title: Text(craftPreviewPageServerAllMods.i18n),
                    subtitle: Column(
                      children: <Widget>[
                        ListTile(
                          title:
                              Text(craftPreviewPageServerModpackDownload.i18n),
                          subtitle: InkWell(
                            child: Text(
                              state.pack?.path ?? '',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<LauncherRepository>()
                                  .launch(path: state.pack?.path ?? '');
                            },
                          ),
                          onTap: null,
                        ),
                        ListTile(
                          title: Text(
                            craftPreviewPageServerModpackDescription.i18n,
                          ),
                          subtitle: Text(state.pack?.description ?? ''),
                        ),
                      ],
                    ),
                  ),
                if (state.settings.isNotEmpty)
                  ListTile(
                    title: Text(craftPreviewPageServerAllMods.i18n),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: state.settings.map<Widget>((setting) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(craftPreviewPageServerModName.i18n),
                              subtitle: Text(setting.name),
                            ),
                            ListTile(
                              title:
                                  Text(craftPreviewPageServerModProgram.i18n),
                              subtitle: Text(setting.program),
                            ),
                            ListTile(
                              title:
                                  Text(craftPreviewPageServerModDownload.i18n),
                              subtitle: InkWell(
                                child: Text(
                                  setting.path,
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  context
                                      .read<LauncherRepository>()
                                      .launch(path: setting.path);
                                },
                              ),
                              onTap: null,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  )
              ],
            ),
          ),
          descriptionWidget: RichText(
            text: TextSpan(
              children: getPreviewDescriptionSpan(),
              style: descriptionTitleStyle,
            ),
          ),
          onNext: state.status == NetworkStatus.inProgress
              ? null
              : () {
                  // widget.onNext?.call();
                  context.read<NaviPageBloc>().add(NaviInstallerCreated());
                },
          nextButtonName: craftPreviewPageComplete.i18n,
          onPrevious: () {
            widget.onPrevious?.call();
          },
          onReturn: () {
            widget.onReturn();
          },
        );
      },
    );
  }
}
