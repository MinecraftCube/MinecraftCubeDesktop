import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';

class InfoIconLink extends StatelessWidget {
  const InfoIconLink({
    Key? key,
    required this.url,
    required this.text,
    required this.icon,
  }) : super(key: key);
  final String url;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
              boxShadow: kElevationToShadow[2],
            ),
            padding: const EdgeInsets.all(1),
            child: icon,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.black),
          )
        ],
      ),
      onPressed: () async {
        final launcher = context.read<LauncherRepository>();
        if (await launcher.canLaunch(path: url)) {
          await launcher.launch(path: url);
        }
      },
    );
  }
}
