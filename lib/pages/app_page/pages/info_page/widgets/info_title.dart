import 'package:flutter/material.dart';

class InfoTitle extends StatelessWidget {
  const InfoTitle({Key? key, required this.icon, required this.title})
      : super(key: key);
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon),
            Text(
              title,
              style: textTheme.titleLarge!,
            ),
          ],
        ),
        Divider(
          color: textTheme.bodyLarge!.color,
        )
      ],
    );
  }
}
