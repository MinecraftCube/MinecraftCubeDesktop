import 'package:flutter/material.dart';

class InfoIconButton extends StatelessWidget {
  const InfoIconButton({
    Key? key,
    required this.name,
    required this.icon,
    this.padding,
    this.onPressed,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 48),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: padding,
            child: Icon(icon),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
