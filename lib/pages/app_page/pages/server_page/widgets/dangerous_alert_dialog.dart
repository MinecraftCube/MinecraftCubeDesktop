import 'package:flutter/material.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/dangerous_alert_dialog.i18n.dart';

class DangerousAlertDialog extends StatelessWidget {
  const DangerousAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: AlertDialog(
        title: Text(serverPageJarDangerousDialogTitle.i18n),
        content: Text(
          serverPageJarDangerousDialogNotify.i18n,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(serverPageJarDangerousDialogReject.i18n),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(serverPageJarDangerousDialogAgree.i18n),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
