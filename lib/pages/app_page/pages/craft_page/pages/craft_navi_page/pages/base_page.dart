import 'package:flutter/material.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.i18n.dart';

abstract class NaviPageStatefulWidget extends StatefulWidget {
  final void Function()? onPrevious;
  final void Function()? onNext;
  final void Function() onReturn;
  const NaviPageStatefulWidget({
    Key? key,
    this.onPrevious,
    required this.onNext,
    required this.onReturn,
  }) : super(key: key);
}

class BuildPageBasePage extends StatelessWidget {
  final String title;
  final dynamic subtitle;
  final void Function() onReturn;
  final Widget? coreWidget;
  final Widget? descriptionWidget;
  final void Function()? onNext;
  final void Function()? onPrevious;
  final String? nextButtonName;
  final ValueNotifier<bool>? nextButtonState;
  final bool showNextButton;

  const BuildPageBasePage({
    Key? key,
    required this.title,
    this.onPrevious,
    required this.subtitle,
    this.coreWidget,
    this.descriptionWidget,
    required this.onNext,
    this.nextButtonName,
    this.nextButtonState,
    required this.onReturn,
    this.showNextButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? titleStyle =
        textTheme.titleMedium?.copyWith(color: scheme.primary);
    // TextStyle descriptionTitleStyle = textTheme.titleLarge.copyWith(color: ColorPalette.accentColor);
    TextStyle? descriptionStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: scheme.secondary);

    Widget nextButton = BasePageNextButton(
      nextButtonName: nextButtonName,
      onNext: onNext,
    );
    if (nextButtonState != null) {
      nextButton = ValueListenableBuilder<bool>(
        valueListenable: nextButtonState!,
        builder: (BuildContext context, bool value, Widget? child) {
          return BasePageNextButton(
            nextButtonName: nextButtonName,
            onNext: value ? onNext : null,
          );
        },
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(hintColor: scheme.onPrimary),
      child: ListView(
        primary: false,
        children: <Widget>[
          BaseTitle(onPrevious: onPrevious, title: title, onReturn: onReturn),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[

                //   ],
                // )
                if (subtitle is String) Text(subtitle, style: titleStyle),
                if (subtitle is Widget) subtitle,
                const SizedBox(
                  height: 8,
                ),
                if (coreWidget != null) coreWidget!,
                const SizedBox(
                  height: 12,
                ),
                Text(craftBasePageInstruction.i18n, style: descriptionStyle),
                const SizedBox(
                  height: 8,
                ),
                if (descriptionWidget != null) descriptionWidget!,
                const SizedBox(
                  height: 32,
                ),
                if (showNextButton)
                  Align(alignment: Alignment.bottomRight, child: nextButton)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BasePageNextButton extends StatelessWidget {
  const BasePageNextButton({
    Key? key,
    required this.nextButtonName,
    required this.onNext,
  }) : super(key: key);

  final String? nextButtonName;
  final void Function()? onNext;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    TextStyle? headerBtnStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: scheme.onPrimary);
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return scheme.primary;
        }),
      ),
      onPressed: onNext,
      child: Text(
        nextButtonName ?? craftBasePageNext.i18n,
        style: headerBtnStyle?.copyWith(
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}

class BaseTitle extends StatelessWidget {
  const BaseTitle({
    Key? key,
    required this.onPrevious,
    required this.title,
    required this.onReturn,
  }) : super(key: key);

  final void Function()? onPrevious;
  final String title;
  final void Function() onReturn;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? headerStyle =
        textTheme.titleLarge?.copyWith(color: scheme.primary);
    TextStyle? headerBtnStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: scheme.onPrimary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (onPrevious != null)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: scheme.secondary,
                    ),
                  ),
                  onTap: () {
                    onPrevious!();
                  },
                ),
              ),
            Text(
              title,
              style: headerStyle,
            ),
          ],
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) => scheme.secondary,
            ),
          ),
          child: Text(craftBasePageBack.i18n, style: headerBtnStyle),
          onPressed: () {
            onReturn();
          },
        )
      ],
    );
  }
}
