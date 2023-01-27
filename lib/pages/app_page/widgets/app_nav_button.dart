import 'package:flutter/material.dart';

class AppNavButton extends StatelessWidget {
  final String buttonName;
  final bool selected;
  final Color iconActiveColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback? onTap;
  const AppNavButton({
    Key? key,
    this.onTap,
    required this.iconActiveColor,
    required this.iconColor,
    required this.icon,
    required this.buttonName,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      fillColor: selected ? Colors.brown.shade900 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 64,
        child: AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? iconActiveColor : iconColor,
              ),
              Text(
                buttonName,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
            // ),
          ),
        ),
      ),
    );
  }
}
