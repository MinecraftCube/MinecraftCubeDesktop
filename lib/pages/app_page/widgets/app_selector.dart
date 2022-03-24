import 'package:flutter/material.dart';
import 'package:minecraft_cube_desktop/pages/app_page/app_selector_page.dart';
import 'package:minecraft_cube_desktop/pages/app_page/widgets/app_nav_button.dart';

class AppSelector extends StatelessWidget {
  final AppSelectorPageType pageType;
  final void Function(AppSelectorPageType page) onPageChanged;
  const AppSelector({
    Key? key,
    required this.pageType,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      AppSelectorPageType.info,
      AppSelectorPageType.server,
      AppSelectorPageType.craft,
      AppSelectorPageType.about
    ];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Color(0xff5f4339),
      ),
      width: 72,
      child: ListView.separated(
        itemBuilder: (context, index) {
          final currentPage = pages[index];
          return AppNavButton(
            buttonName: currentPage.name,
            icon: currentPage.icon,
            iconActiveColor: currentPage.iconActiveColor,
            iconColor: currentPage.iconColor,
            selected: pageType == currentPage,
            onTap: () {
              onPageChanged(currentPage);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 12,
            child: Divider(
              color: Colors.white24,
              height: 12,
            ),
          );
        },
        itemCount: pages.length,
      ),
    );
  }
}
