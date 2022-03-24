import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/_consts/localization.dart';
import 'package:minecraft_cube_desktop/pages/app_page/bloc/locale_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/language_dialog.i18n.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late final LocaleBloc _localeBloc;
  AppLanguage _language = AppLanguage.enUS;
  AppLanguage _initLanguage = AppLanguage.enUS;
  @override
  void initState() {
    super.initState();
    _localeBloc = BlocProvider.of<LocaleBloc>(context);
    final currentLocale = _localeBloc.state.locale;
    if (currentLocale == AppLocalization.enUS) {
      _language = AppLanguage.enUS;
    }
    if (currentLocale == AppLocalization.zhTW) {
      _language = AppLanguage.zhTW;
    }
    _initLanguage = _language;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        changeLocale(context, _initLanguage);
        return true;
      },
      child: AlertDialog(
        // backgroundColor: Colors.brown,
        title: Text(languageDialogSelectLanguage.i18n),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LanguageTile(
              title: 'English',
              language: AppLanguage.enUS,
              selectedLanguage: _language,
              onChanged: (lang) {
                setState(() {
                  if (lang != null) {
                    _language = lang;
                    changeLocale(context, lang);
                  }
                });
              },
            ),
            LanguageTile(
              title: '繁體中文',
              language: AppLanguage.zhTW,
              selectedLanguage: _language,
              onChanged: (lang) {
                setState(() {
                  if (lang != null) {
                    _language = lang;
                    changeLocale(context, lang);
                  }
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              changeLocale(context, _initLanguage);
              Navigator.of(context).pop();
            },
            child: Text(languageDialogCancel.i18n),
          ),
          TextButton(
            onPressed: () {
              changeLocale(context, _language);
              Navigator.of(context).pop();
            },
            child: Text(languageDialogConfirm.i18n),
          ),
        ],
      ),
    );
  }

  void changeLocale(BuildContext context, AppLanguage language) {
    if (language == AppLanguage.enUS) {
      _localeBloc.add(LanguageChanged(AppLocalization.enUS));
    }
    if (language == AppLanguage.zhTW) {
      _localeBloc.add(LanguageChanged(AppLocalization.zhTW));
    }
  }
}

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    Key? key,
    required this.onChanged,
    required this.language,
    required this.selectedLanguage,
    required this.title,
  }) : super(key: key);
  final void Function(AppLanguage?) onChanged;
  final String title;
  final AppLanguage language;
  final AppLanguage selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onChanged(language);
      },
      title: Text(title),
      leading: Radio<AppLanguage>(
        value: language,
        groupValue: selectedLanguage,
        fillColor: MaterialStateProperty.all(Colors.black),
        onChanged: onChanged,
      ),
    );
  }
}
