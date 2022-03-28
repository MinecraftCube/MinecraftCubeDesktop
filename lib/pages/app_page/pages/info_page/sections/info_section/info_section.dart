import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/_gen/assets.gen.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/info_page.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/bloc/app_updater_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/language_dialog.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/release_note_dialog.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/widgets/info_icon_button.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/widgets/info_icon_link.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppUpdaterBloc(
        appUpdaterRepository: context.read<AppUpdaterRepository>(),
      )..add(AppUpdaterStarted()),
      child: const InfoSectionView(),
    );
  }
}

class InfoSectionView extends StatefulWidget {
  const InfoSectionView({Key? key}) : super(key: key);

  @override
  State<InfoSectionView> createState() => _InfoSectionViewState();
}

class _InfoSectionViewState extends State<InfoSectionView> {
  late final AppUpdaterBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = context.read<AppUpdaterBloc>();
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(
      width: 4,
    );
    return SizedBox(
      height: 36,
      child: ListView(
        primary: false,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InfoIconLink(
            icon: Assets.resources.logo.image(),
            text: infoPageInfoHome.i18n,
            url: infoPageInfoLinkHome.i18n,
          ),
          gap,
          InfoIconLink(
            icon: Assets.resources.forum.image(),
            text: infoPageInfoForum.i18n,
            url: infoPageInfoLinkForum.i18n,
          ),
          gap,
          BlocBuilder<AppUpdaterBloc, AppUpdaterState>(
            builder: (context, state) {
              return Badge(
                showBadge: state.hasGreaterVersion,
                position: BadgePosition.topStart(top: 0, start: 0),
                child: InfoIconButton(
                  name: infoPageInfoChangeHistory.i18n,
                  icon: Icons.change_history,
                  padding: const EdgeInsets.only(
                    left: 1,
                    right: 1,
                    top: 0,
                    bottom: 4,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ReleaseNoteDialog(appUpdaterBloc: _bloc);
                      },
                    );
                  },
                ),
              );
            },
          ),
          gap,
          gap,
          InfoIconButton(
            name: infoPageInfoChangeLanguage.i18n,
            icon: Icons.language,
            padding: const EdgeInsets.all(1),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return const LanguageDialog();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
