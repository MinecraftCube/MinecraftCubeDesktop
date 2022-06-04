import 'package:cube_api/cube_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/server_type_page.i18n.dart';

class ServerTypeNaviPage extends NaviPageStatefulWidget {
  const ServerTypeNaviPage({
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
  State createState() => _ServerTypeNaviPageState();
}

class _ServerTypeNaviPageState extends State<ServerTypeNaviPage>
    with AutomaticKeepAliveClientMixin {
  JarType? _selectType = JarType.vanilla;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextStyle? titleStyle =
        textTheme.subtitle1?.copyWith(color: colorScheme.primary);
    TextStyle? descriptionTitleStyle =
        textTheme.subtitle1?.copyWith(color: Colors.grey);

    // return BlocBuilder<MPB.NaviPageBloc, MPB.NaviPageState>(
    //   buildWhen: (state, oldState) => oldState.type != state.type,
    //   cubit: widget.bloc,
    //   builder: (context, state) {
    return BuildPageBasePage(
      title: craftServerTypePageTitle.i18n,
      subtitle: craftServerTypePageSubtitle.i18n,
      descriptionWidget: RichText(
        text: TextSpan(
          children: getServerTypeDescriptionSpan(
            () {
              context
                  .read<LauncherRepository>()
                  .launch(path: 'https://mcversions.net/');
            },
            () {
              context.read<LauncherRepository>().launch(
                    path:
                        'https://files.minecraftforge.net/net/minecraftforge/forge/',
                  );
            },
          ),
          style: descriptionTitleStyle,
        ),
      ),
      coreWidget: Container(
        width: 320,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.primary),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<JarType>(
            value: _selectType,
            hint: Text(
              craftServerTypePageNameFieldHint.i18n,
              style: titleStyle,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.secondary,
            ),
            items: [JarType.vanilla, JarType.forgeInstaller]
                .map<DropdownMenuItem<JarType>>((value) {
              return DropdownMenuItem<JarType>(
                value: value,
                child: Text(
                  value == JarType.forgeInstaller ? 'Forge' : 'Vanilla',
                  textAlign: TextAlign.right,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectType = value;
              });
              // widget.bloc.add(MPB.ModifyServerTypeEvent(value));
            },
          ),
        ),
      ),
      onNext: () {
        context.read<NaviPageBloc>().add(NaviJarTypeChanged(_selectType!));
        widget.onNext?.call();
      },
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
