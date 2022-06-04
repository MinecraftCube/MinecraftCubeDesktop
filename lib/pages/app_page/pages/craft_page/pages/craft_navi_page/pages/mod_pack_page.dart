import 'package:cube_api/cube_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/_widgets/cube_text_field.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/mod_pack_page.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/mod_setting_page.dart';
import 'package:validators/validators.dart' as validator;

class ModpackNaviPage extends NaviPageStatefulWidget {
  const ModpackNaviPage({
    Key? key,
    void Function()? onPrevious,
    required void Function() onNext,
    required void Function() onReturn,
    required this.onSwitchMode,
    // MPB.NaviPageBloc bloc,
  }) : super(
          key: key,
          onPrevious: onPrevious,
          onNext: onNext,
          onReturn: onReturn,
          // bloc: bloc,
        );
  final VoidCallback onSwitchMode;

  @override
  State createState() => _ModpackNaviPageState();
}

class _ModpackNaviPageState extends State<ModpackNaviPage> {
  late GroupButtonController _groupButtonController;
  late ValueNotifier<bool> _nextButtonState;
  late ModelPack _pack;

  @override
  void initState() {
    _nextButtonState = ValueNotifier<bool>(true);
    _pack = const ModelPack(
      path: '',
    );
    _groupButtonController =
        GroupButtonController(selectedIndex: ModelSettingType.pack.index);
    super.initState();
  }

  @override
  void dispose() {
    _groupButtonController.dispose();
    _nextButtonState.dispose();
    super.dispose();
  }

  bool validatePack(ModelPack pack) {
    return _downloadValidator(pack.path) == null;
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    // TextStyle titleStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.primaryColor);
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? descriptionTitleStyle =
        textTheme.subtitle1?.copyWith(color: Colors.grey);

    const currentMode = ModelSettingType.pack;
    // return BlocBuilder<MPB.NaviPageBloc, MPB.NaviPageState>(
    //   buildWhen: (state, oldState) {
    //     return oldState.settings != state.settings || oldState.isPack != state.isPack || oldState.pack != state.pack;
    //   },
    //   cubit: widget.bloc,
    //   builder: (context, state) {
    //     // if(state.isPack) aaa
    //     bool isNextButtonAvaliable = false;
    //     if(!state.isPack) {
    //       isNextButtonAvaliable = state.settings.isEmpty || (state.settings.isNotEmpty && state.settings.fold(true, (v, comined) => v && state.checkModelSettingValid(comined)));
    //     } else {
    //       isNextButtonAvaliable = state.isModelPackValid();
    //     }
    return BuildPageBasePage(
      title: craftModpackPageTitle.i18n,
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            craftModpackPageSubtitle.i18n,
          ),
          GroupButton(
            controller: _groupButtonController,
            buttons: ModelSettingType.values.map((e) => e.name).toList(),
            onSelected: (_, index, __) {
              if (index != currentMode.index) {
                widget.onSwitchMode();
                _groupButtonController.selectIndex(currentMode.index);
              }
            },
          ),
        ],
      ),
      coreWidget: ModpackSection(
        pack: _pack,
        onModpackChanged: (pack) {
          _pack = pack;
          _nextButtonState.value = validatePack(pack);
        },
      ),
      descriptionWidget: SelectableText.rich(
        TextSpan(
          children: getModpackDescriptionSpan(() {
            context
                .read<LauncherRepository>()
                .launch(path: 'https://youtu.be/E9auOMjV3qg?t=586');
          }),
          style: descriptionTitleStyle,
        ),
      ),
      nextButtonState: _nextButtonState,
      onNext: () {
        context.read<NaviPageBloc>().add(NaviModelPackChanged(_pack));
        widget.onNext?.call();
      },
      onPrevious: () {
        widget.onPrevious?.call();
      },
      onReturn: () {
        widget.onReturn();
      },
    );
  }
}

class ModpackSection extends StatefulWidget {
  const ModpackSection({
    Key? key,
    required this.pack,
    required this.onModpackChanged,
  }) : super(key: key);
  final ModelPack pack;
  final void Function(ModelPack pack) onModpackChanged;

  @override
  State<ModpackSection> createState() => _ModpackSectionState();
}

class _ModpackSectionState extends State<ModpackSection> {
  late TextEditingController _downloadController;
  late TextEditingController _descController;
  late bool _isDownloadFieldTouched;
  @override
  void initState() {
    super.initState();
    void dataChangedListener() {
      widget.onModpackChanged(
        ModelPack(
          path: _downloadController.text,
          description: _descController.text,
        ),
      );
    }

    _downloadController = TextEditingController(text: widget.pack.path)
      ..addListener(dataChangedListener);
    _isDownloadFieldTouched = false;
    _descController = TextEditingController(text: widget.pack.description ?? '')
      ..addListener(dataChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(craftModpackPageFieldDownload.i18n),
        CubeTextField(
          controller: _downloadController,
          hintText: craftModpackPageFieldDownloadHelper.i18n,
          validator: (text) {
            if (!_isDownloadFieldTouched) return null;
            return _downloadValidator(text);
          },
          onChanged: (_) => _isDownloadFieldTouched = true,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(craftModpackPageFieldDescription.i18n),
        CubeTextField(
          controller: _descController,
          keyboardType: TextInputType.multiline,
          maxLines: 10,
        )
      ],
    );
  }
}

String? _downloadValidator(String? text) {
  if (text == null) return null;
  if (text.isEmpty) return null;
  if (!validator.isURL(text)) return craftModpackPageFieldErrorTextA.i18n;
  return null;
}
