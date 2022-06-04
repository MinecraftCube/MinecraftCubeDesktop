import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/_widgets/cube_text_field.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/map_download_page.i18n.dart';
import 'package:validators/validators.dart' as validator;

class MapDownloadNaviPage extends NaviPageStatefulWidget {
  const MapDownloadNaviPage({
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
  State createState() => _MapDownloadNaviPageState();
}

class _MapDownloadNaviPageState extends State<MapDownloadNaviPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;
  late ValueNotifier<bool> _nextButtonState;
  late bool _isMapDownloadFieldTouched;
  @override
  void initState() {
    super.initState();
    _isMapDownloadFieldTouched = true;
    _nextButtonState = ValueNotifier<bool>(true);
    _controller = TextEditingController()
      ..addListener(() {
        _nextButtonState.value = _validator(_controller.text) == null;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nextButtonState.dispose();
    super.dispose();
  }

  String? _validator(String? text) {
    if (text == null) return null;
    if (text.isEmpty == true) return null;
    return validator.isURL(text)
        ? null
        : craftMapDownloadPageFieldErrorTextA.i18n;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? descriptionTitleStyle =
        textTheme.subtitle1?.copyWith(color: Colors.grey);

    // return BlocBuilder<MPB.NaviPageBloc, MPB.NaviPageState>(
    //   buildWhen: (state, oldState) => oldState.mapDownloadPath != state.mapDownloadPath,
    //   cubit: widget.bloc,
    //   builder: (context, state) {
    return BuildPageBasePage(
      title: craftMapDownloadPageTitle.i18n,
      subtitle: craftMapDownloadPageSubtitle.i18n,
      coreWidget: CubeTextField(
        controller: _controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (text) {
          if (!_isMapDownloadFieldTouched) return null;
          return _validator(text);
          // return state.serverDownloadValid ? null : '';
        },
        hintText: craftMapDownloadPageFieldHelperText.i18n,
        onChanged: (_) => _isMapDownloadFieldTouched = true,
      ),
      descriptionWidget: RichText(
        text: TextSpan(
          children: getMapDownloadDescriptionSpan(() {
            context
                .read<LauncherRepository>()
                .launch(path: 'https://youtu.be/E9auOMjV3qg?t=138');
          }),
          style: descriptionTitleStyle,
        ),
      ),
      onNext: () {
        widget.onNext?.call();
        context
            .read<NaviPageBloc>()
            .add(NaviMapDownloadPathChanged(_controller.text));
      },
      nextButtonState: _nextButtonState,
      onPrevious: () {
        widget.onPrevious?.call();
      },
      onReturn: () {
        widget.onReturn();
      },
    );
    //   }
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
