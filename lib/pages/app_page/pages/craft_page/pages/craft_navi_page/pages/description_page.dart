import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/_widgets/cube_text_field.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/_blocs/navi_page_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/base_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/pages/description_page.i18n.dart';

class DescriptionNaviPage extends NaviPageStatefulWidget {
  const DescriptionNaviPage({
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
  _DescriptionNaviPageState createState() => _DescriptionNaviPageState();
}

class _DescriptionNaviPageState extends State<DescriptionNaviPage> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()
      ..addListener(() {
        // widget.bloc.add(MPB.ModifyDescriptionEvent(_controller.text));
      });
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle headerStyle = Theme.of(context).textTheme.headline.copyWith(color: ColorPalette.primaryColor);
    // TextStyle headerBtnStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.fontColor);
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? descriptionTitleStyle =
        textTheme.subtitle1?.copyWith(color: Colors.grey);
    // TextStyle descriptionStyle = Theme.of(context).textTheme.title.copyWith(color: ColorPalette.secondaryColor);

    // return BlocBuilder<MPB.NaviPageBloc, MPB.NaviPageState>(
    //     buildWhen: (state, oldState) =>
    //         oldState.description != state.description,
    //     cubit: widget.bloc,
    //     builder: (context, state) {
    return BuildPageBasePage(
      title: craftDescriptionPageTitle.i18n,
      subtitle: craftDescriptionPageSubtitle.i18n,
      coreWidget: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        // height: 56,
        child: CubeTextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          maxLines: 10,
        ),
      ),
      descriptionWidget: SelectableText.rich(
        TextSpan(
          children: getDescriptionDescriptionSpan(),
          style: descriptionTitleStyle,
        ),
      ),
      onNext: () {
        context
            .read<NaviPageBloc>()
            .add(NaviDescriptionChanged(_controller.text));
        widget.onNext?.call();
      },
      onPrevious: () {
        widget.onPrevious?.call();
      },
      onReturn: () {
        widget.onReturn();
      },
    );
    // });
  }
}
