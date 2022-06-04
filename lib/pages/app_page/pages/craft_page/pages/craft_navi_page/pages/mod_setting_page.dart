import 'package:cube_api/cube_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/_widgets/cube_text_field.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/mod_setting_page.i18n.dart';
import 'package:validators/validators.dart' as validator;

class ModelSettingNaviPage extends NaviPageStatefulWidget {
  const ModelSettingNaviPage({
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
  State createState() => _ModelSettingNaviPageState();
}

enum ModelSettingType { detail, pack }

extension ModelSettingTypeExtension on ModelSettingType {
  String get name {
    switch (this) {
      case ModelSettingType.detail:
        return craftModelSettingPageTypeDetail.i18n;
      case ModelSettingType.pack:
        return craftModelSettingPageTypeAll.i18n;
    }
  }
}

class _ModelSettingNaviPageState extends State<ModelSettingNaviPage> {
  late GroupButtonController _groupButtonController;
  late ValueNotifier<bool> _nextButtonState;
  late List<ModelSetting> _settings;
  @override
  void initState() {
    _settings = [];
    _nextButtonState = ValueNotifier<bool>(true);
    _groupButtonController =
        GroupButtonController(selectedIndex: ModelSettingType.detail.index);
    super.initState();
  }

  @override
  void dispose() {
    _groupButtonController.dispose();
    _nextButtonState.dispose();
    super.dispose();
  }

  bool validateSettings(List<ModelSetting> settings) {
    if (settings.isEmpty) return true;
    for (final setting in settings) {
      if (nameFieldValidator(setting.name) != null) return false;
      if (programFieldValidator(setting.program) != null) return false;
      if (downloadFieldValidator(setting.path) != null) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    // TextStyle titleStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.primaryColor);
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? descriptionTitleStyle =
        textTheme.subtitle1?.copyWith(color: Colors.grey);

    const currentMode = ModelSettingType.detail;
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
      title: craftModelSettingPageTitle.i18n,
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            craftModelSettingPageSubtitle.i18n,
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
      coreWidget: DetailSection(
        settings: _settings,
        onModelSettingsChanged: (settings) {
          _settings = settings;
          _nextButtonState.value = validateSettings(settings);
        },
      ),
      descriptionWidget: SelectableText.rich(
        TextSpan(
          children: getModelSettingDescriptionSpan(() {
            context
                .read<LauncherRepository>()
                .launch(path: 'https://youtu.be/E9auOMjV3qg?t=586');
          }),
          style: descriptionTitleStyle,
        ),
      ),
      nextButtonState: _nextButtonState,
      onNext: () {
        context
            .read<NaviPageBloc>()
            .add(NaviModelSettingsChanged(settings: _settings));
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

class DetailSection extends StatefulWidget {
  const DetailSection({
    Key? key,
    required this.settings,
    required this.onModelSettingsChanged,
  }) : super(key: key);
  final List<ModelSetting> settings;
  final void Function(List<ModelSetting>) onModelSettingsChanged;

  @override
  State<DetailSection> createState() => _DetailSectionState();
}

class _DetailSectionState extends State<DetailSection> {
  late List<ModelSetting> _settings;
  @override
  void initState() {
    super.initState();
    _settings = List.from(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == _settings.length) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            onPressed: () {
              setState(() {
                _settings
                    .add(const ModelSetting(name: '', program: '', path: ''));
                widget.onModelSettingsChanged(_settings);
              });
            },
            child: const Icon(Icons.add),
          );
        }
        return DetailListTile(
          onDeleted: () {
            setState(() {
              _settings.removeAt(index);
              widget.onModelSettingsChanged(_settings);
            });
          },
          onChanged: ({
            required String download,
            required String name,
            required String program,
          }) {
            _settings[index] =
                ModelSetting(name: name, program: program, path: download);
            widget.onModelSettingsChanged(_settings);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: _settings.length + 1,
    );
  }
}

class DetailListTile extends StatefulWidget {
  const DetailListTile({
    Key? key,
    required this.onChanged,
    required this.onDeleted,
  }) : super(key: key);
  final void Function({
    required String name,
    required String program,
    required String download,
  }) onChanged;
  final VoidCallback onDeleted;

  @override
  State<DetailListTile> createState() => _DetailListTileState();
}

class _DetailListTileState extends State<DetailListTile> {
  late TextEditingController _nameController;
  late bool _isNameFieldTouched;
  late TextEditingController _programController;
  late bool _isProgramFieldTouched;
  late TextEditingController _downloadController;
  late bool _isDownloadFieldTouched;
  @override
  void initState() {
    _isNameFieldTouched = false;
    _isProgramFieldTouched = false;
    _isDownloadFieldTouched = false;
    void dataChangedListener() {
      widget.onChanged(
        name: _nameController.text,
        program: _programController.text,
        download: _downloadController.text,
      );
    }

    _nameController = TextEditingController()..addListener(dataChangedListener);
    _programController = TextEditingController()
      ..addListener(dataChangedListener);
    _downloadController = TextEditingController()
      ..addListener(dataChangedListener);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _programController.dispose();
    _downloadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(color: colorScheme.secondary),
      child: ExpansionTile(
        title: ValueListenableBuilder(
          valueListenable: _nameController,
          builder: (context, value, child) {
            final title = _nameController.text;
            return Text(
              title.isNotEmpty ? title : craftModelSettingPageFieldTitle.i18n,
              style: textTheme.bodyText1?.copyWith(color: Colors.white),
            );
          },
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              // borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: ColorPalette.accentColor),
              border: Border(
                top: BorderSide(color: colorScheme.secondary),
                bottom: BorderSide(color: colorScheme.secondary),
                right: BorderSide(color: colorScheme.secondary),
                left: BorderSide(color: colorScheme.secondary),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          craftModelSettingPageFieldModel.i18n,
                          style: textTheme.subtitle1
                              ?.copyWith(color: colorScheme.primary),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 240,
                          child: CubeTextField(
                            controller: _nameController,
                            hintText:
                                craftModelSettingPageFieldModelHelper.i18n,
                            validator: (text) {
                              if (!_isNameFieldTouched) return null;
                              return nameFieldValidator(text);
                            },
                            onChanged: (_) => _isNameFieldTouched = true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          craftModelSettingPageFieldFilename.i18n,
                          style: textTheme.subtitle1
                              ?.copyWith(color: colorScheme.primary),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 240,
                          child: CubeTextField(
                            controller: _programController,
                            hintText:
                                craftModelSettingPageFieldFilenameHelper.i18n,
                            validator: (text) {
                              if (!_isProgramFieldTouched) return null;
                              return programFieldValidator(text);
                            },
                            onChanged: (_) => _isProgramFieldTouched = true,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      craftModelSettingPageFieldDownload.i18n,
                      style: textTheme.subtitle1
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CubeTextField(
                        controller: _downloadController,
                        hintText: craftModelSettingPageFieldDownloadHelper.i18n,
                        validator: (text) {
                          if (!_isDownloadFieldTouched) return null;
                          return downloadFieldValidator(text);
                        },
                        onChanged: (_) => _isDownloadFieldTouched = true,
                      ),
                    ),
                    IconButton(
                      color: Colors.red,
                      disabledColor: Colors.grey,
                      icon: const Icon(Icons.delete),
                      onPressed: widget.onDeleted,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

String? nameFieldValidator(String? text) {
  if (text == null) return craftModelSettingPageFieldErrorTextA.i18n;
  if (text.isEmpty) return craftModelSettingPageFieldErrorTextA.i18n;
  return null;
}

String? programFieldValidator(String? text) {
  if (text == null) return craftModelSettingPageFieldErrorTextA.i18n;
  if (text.isEmpty) return craftModelSettingPageFieldErrorTextA.i18n;
  return null;
}

String? downloadFieldValidator(String? text) {
  if (text == null) return craftModelSettingPageFieldErrorTextB.i18n;
  if (!validator.isURL(text)) return craftModelSettingPageFieldErrorTextB.i18n;
  return null;
}
