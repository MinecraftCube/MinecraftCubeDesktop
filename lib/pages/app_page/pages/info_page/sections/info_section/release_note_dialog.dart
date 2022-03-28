import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/_consts/common.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/bloc/app_updater_bloc.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/release_note_dialog.i18n.dart';

class ReleaseNoteDialog extends StatefulWidget {
  const ReleaseNoteDialog({Key? key, required this.appUpdaterBloc})
      : super(key: key);
  final AppUpdaterBloc appUpdaterBloc;

  @override
  State<ReleaseNoteDialog> createState() => _ReleaseNoteDialogState();
}

class _ReleaseNoteDialogState extends State<ReleaseNoteDialog> {
  @override
  void initState() {
    super.initState();
    final currentLocale = I18n.locale;
    final lang = currentLocale.languageCode;
    final country = currentLocale.countryCode;
    final appUpdaterBloc = widget.appUpdaterBloc;
    appUpdaterBloc.add(AppUpdaterMarkdownFetched(fullLocale: '$lang$country'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUpdaterBloc, AppUpdaterState>(
      bloc: widget.appUpdaterBloc,
      builder: (context, state) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                child: Markdown(
                  data: state.markdown,
                  extensionSet: md.ExtensionSet(
                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                    [
                      md.EmojiSyntax(),
                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(releaseNoteDialogDownload.i18n),
              onPressed: () {
                context.read<LauncherRepository>().launch(
                      path: releaseNotDialogDownloadLink.i18n,
                    );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(confirm.ci18n),
            )
          ],
        );
      },
    );
  }
}
