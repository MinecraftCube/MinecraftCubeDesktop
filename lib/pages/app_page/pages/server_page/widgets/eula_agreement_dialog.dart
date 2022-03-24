import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/eula_agreement_dialog.i18n.dart';

class EulaAgreementDialog extends StatelessWidget {
  const EulaAgreementDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Theme(
      data: ThemeData.light(),
      child: AlertDialog(
        title: Text(serverPageEulaDialogTitle.i18n),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: textTheme.subtitle2?.copyWith(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: serverPageEulaDialogNotify.i18n),
                    TextSpan(
                      text: serverPageEulaDialogEula.i18n,
                      style: textTheme.subtitle2?.copyWith(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.read<LauncherRepository>().launch(
                                path:
                                    'https://account.mojang.com/documents/minecraft_eula',
                              );
                        },
                    ),
                    TextSpan(text: serverPageEulaDialogDot.i18n),
                  ],
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(serverPageEulaDialogReject.i18n),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(serverPageEulaDialogAgree.i18n),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
