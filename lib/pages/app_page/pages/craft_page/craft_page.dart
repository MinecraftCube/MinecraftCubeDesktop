import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/craft_page.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/craft_page/pages/craft_navi_page/craft_navi_page.dart';

class CraftPage extends StatefulWidget {
  const CraftPage({Key? key}) : super(key: key);

  @override
  State<CraftPage> createState() => _CraftPageState();
}

enum CraftPageType {
  intro,
  buildInstaller,
}

class _CraftPageState extends State<CraftPage> {
  late CraftPageType _page;
  @override
  void initState() {
    _page = CraftPageType.intro;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _page == CraftPageType.intro
        ? CraftIntroPage(
            onPageChanged: (page) {
              setState(() {
                _page = CraftPageType.buildInstaller;
              });
            },
          )
        : CraftNaviPage(
            onMenuPressed: () => setState(() {
              _page = CraftPageType.intro;
            }),
          );

    // See comments for knowing the issue above
    // itemBuilder: (context, index) {
    //   if (index == 0) {
    //     // print('intro');
    //     return CraftIntroPage(
    //       onPageChanged: (page) {
    //         pageController.jumpToPage(page.index);
    //         valueNotifier.value++;
    //       },
    //     );
    //   } else {
    //     // FlutterBug: Not disposing page when using SelectableText in CraftNaviPage
    //     // https://github.com/flutter/flutter/pull/94493
    //     // https://github.com/flutter/flutter/issues/93224
    //     // return CraftNaviPage(
    //     //   onMenuPressed: () =>
    //     //       pageController.jumpToPage(CraftPageType.intro.index),
    //     // );
    //     // print('navi');
    //     // not a workaround: https://stackoverflow.com/questions/67254062/how-to-dispose-kill-a-page-in-a-pageview-in-flutter/67257370#67257370
    //     return ValueListenableBuilder(
    //       valueListenable: valueNotifier,
    //       builder: (context, value, child) {
    //         return CraftNaviPage(
    //           onMenuPressed: () =>
    //               pageController.jumpToPage(CraftPageType.intro.index),
    //         );
    //       },
    //     );
    //   }
    // },
    // itemCount: 2,
    // );

    // After testing: PageView still cause bug, even with ValueListenableBuilder,
    // maybe It's issue with nested PageView, But I'm tired to test more deeply.
  }
}

class CraftIntroPage extends StatefulWidget {
  const CraftIntroPage({Key? key, required this.onPageChanged})
      : super(key: key);
  final Function(CraftPageType) onPageChanged;

  @override
  State<CraftIntroPage> createState() => CraftIntroPageState();
}

enum CraftIntroPageType { installer, integrate }

extension CraftIntroPageTypeExtension on CraftIntroPageType {
  String get name {
    switch (this) {
      case CraftIntroPageType.installer:
        return craftPageInstaller.i18n;
      case CraftIntroPageType.integrate:
        return craftPageManual.i18n;
    }
  }
}

class CraftIntroPageState extends State<CraftIntroPage> {
  late GroupButtonController _controller;
  @override
  void initState() {
    super.initState();
    _controller = GroupButtonController(
      selectedIndex: CraftIntroPageType.installer.index,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const gap = SizedBox(
      height: 12,
    );
    return Column(
      children: [
        gap,
        Text(
          craftPageSelectAnApproach.i18n.toUpperCase(),
          style: textTheme.headline5,
        ),
        gap,
        GroupButton(
          options: GroupButtonOptions(
            spacing: 4,
            textPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            selectedTextStyle:
                textTheme.headline6?.copyWith(color: Colors.white),
            unselectedTextStyle: textTheme.headline6,
          ),
          controller: _controller,
          onSelected: (index, isSelected) {
            setState(() {
              _controller.selectIndex(index);
            });
          },
          buttons: CraftIntroPageType.values
              .map((e) => e.name.toUpperCase())
              .toList(),
        ),
        gap,
        Expanded(
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              border: Border.all(color: Colors.black),
            ),
            child:
                _controller.selectedIndex == CraftIntroPageType.integrate.index
                    ? const CraftIntroPageIntegrateSection()
                    : const CraftIntroPageInstallerSection(),
          ),
        ),
        gap,
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.slideshow,
                        color: Colors.red,
                        size: 36,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        craftPagePlaylist.i18n,
                        style: textTheme.bodyText1?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    const link =
                        'https://www.youtube.com/playlist?list=PLhinMkAHNXof487STGZe50wHG3rS92jv3';
                    if (await context
                        .read<LauncherRepository>()
                        .canLaunch(path: link)) {
                      await context
                          .read<LauncherRepository>()
                          .launch(path: link);
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _controller.selectedIndex ==
                        CraftIntroPageType.integrate.index
                    ? null
                    : () {
                        widget.onPageChanged(CraftPageType.buildInstaller);
                      },
                child: Text(
                  craftPageCreate.i18n.toUpperCase(),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class CraftIntroPageInstallerSection extends StatelessWidget {
  const CraftIntroPageInstallerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        style: textTheme.bodyText2,
        children: [
          TextSpan(
            text: craftPageInstallerDesc.i18n,
          ),
        ],
      ),
    );
  }
}

class CraftIntroPageIntegrateSection extends StatelessWidget {
  const CraftIntroPageIntegrateSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        style: textTheme.bodyText2,
        children: [
          TextSpan(
            text: craftPageManualDescFollowing.i18n,
            style: textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: craftPageManualDescFollowingA.i18n,
          ),
          TextSpan(
            text: craftPageManualDescFollowingB.i18n,
          ),
          TextSpan(
            text: craftPageManualDescFollowingC.i18n,
          ),
          TextSpan(
            text: craftPageLineBreak.i18n,
          ),
          TextSpan(
            text: craftPageManualDescIntegrate.i18n,
            style: textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: craftPageManualDescIntegrateA.i18n,
          ),
          TextSpan(
            text: craftPageManualDescIntegrateB.i18n,
          ),
          TextSpan(
            text: craftPageManualDescIntegrateC.i18n,
          ),
        ],
      ),
    );
  }
}
