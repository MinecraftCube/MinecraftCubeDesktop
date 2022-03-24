import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/_widgets/cube_text_field.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/installer_name_page.i18n.dart';

import 'base_page.dart';

class InstallerNameNaviPage extends NaviPageStatefulWidget {
  const InstallerNameNaviPage({
    Key? key,
    void Function()? onPrevious,
    required void Function() onNext,
    required void Function() onReturn,
    // MPB.NaviPageBloc bloc,
  }) : super(
          key: key,
          onPrevious: onPrevious,
          onNext: onNext,
          onReturn: onReturn,
          // bloc: bloc,
        );

  @override
  _InstallerNameNaviPageState createState() => _InstallerNameNaviPageState();
}

class _InstallerNameNaviPageState extends State<InstallerNameNaviPage> {
  late TextEditingController _controller;
  late ValueNotifier<bool> _nextButtonNotifier;
  late bool _isInstallerFieldTocuhed;
  @override
  void initState() {
    super.initState();
    _isInstallerFieldTocuhed = false;
    _nextButtonNotifier = ValueNotifier<bool>(false);
    _controller = TextEditingController()
      ..addListener(() {
        _nextButtonNotifier.value = _validator(_controller.text) == null;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nextButtonNotifier.dispose();
    super.dispose();
  }

  String? _validator(String? text) {
    if (text == null) return craftInstallerNamePageNameFieldErrorA.i18n;
    if (text.isEmpty) return craftInstallerNamePageNameFieldErrorA.i18n;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? descriptionTitleStyle =
        textTheme.subtitle1?.copyWith(color: Colors.grey);
    // TextStyle descriptionStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.secondaryColor);

    /*return BlocBuilder<NaviPageBloc, NaviPageState>(
      buildWhen: (state, oldState) =>
          oldState.installerName != state.installerName,
      builder: (context, state) {*/
    return BuildPageBasePage(
      title: craftInstallerNamePageTitle.i18n,
      subtitle: craftInstallerNamePageSubtitle.i18n,
      coreWidget: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: CubeTextField(
          controller: _controller,
          hintText: craftInstallerNamePageNameFieldHint.i18n,
          validator: (text) {
            if (!_isInstallerFieldTocuhed) return null;
            return _validator(text);
            // return state.installerValid ? null : '';
          },
          onChanged: (_) => _isInstallerFieldTocuhed = true,
        ),
      ),
      descriptionWidget: SelectableText.rich(
        TextSpan(
          children: getInstallerNameDescriptionSpan(),
          style: descriptionTitleStyle,
        ),
      ),
      // onNext: !state.installerValid
      //     ? null
      //     : () {
      onNext: () {
        context
            .read<NaviPageBloc>()
            .add(NaviInstallerNameChanged(_controller.text));
        widget.onNext?.call();
      },
      nextButtonState: _nextButtonNotifier,
      onPrevious: widget.onPrevious,
      onReturn: () {
        widget.onReturn();
      },
    );
    /* },
    );*/
  }
}
