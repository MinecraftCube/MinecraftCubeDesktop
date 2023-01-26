import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/cube_properties_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/server_properties_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/property_dialogs.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/property_list_tile.dart';
import 'package:server_properties_repository/server_properties_repository.dart';

class PropertyDialog extends StatelessWidget {
  const PropertyDialog({
    Key? key,
    required this.projectPath,
  }) : super(key: key);
  final String projectPath;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServerPropertiesBloc(
            serverPropertiesRepository:
                context.read<ServerPropertiesRepository>(),
            projectPath: projectPath,
          )..add(ServerPropertiesLoaded()),
        ),
        BlocProvider(
          create: (context) => CubePropertiesBloc(
            javaInfoRepository: context.read<JavaInfoRepository>(),
            cubePropertiesRepository: context.read<CubePropertiesRepository>(),
            projectPath: projectPath,
          )..add(CubePropertiesLoaded()),
        ),
      ],
      child: const PropertyDialogView(),
    );
  }
}

enum PropetyTabPageType {
  server,
  advanced,
}

extension PropetyTabPageTypeExtension on PropetyTabPageType {
  String get name {
    switch (this) {
      case PropetyTabPageType.server:
        return serverPagePropertyDialogTabServer.i18n;
      case PropetyTabPageType.advanced:
        return serverPagePropertyDialogTabAdvanced.i18n;
      default:
        break;
    }
    throw UnimplementedError();
  }
}

class PropertyDialogView extends StatefulWidget {
  const PropertyDialogView({Key? key}) : super(key: key);

  @override
  State<PropertyDialogView> createState() => _PropertyDialogViewState();
}

class _PropertyDialogViewState extends State<PropertyDialogView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: PropetyTabPageType.values.length,
      vsync: this,
      initialIndex: PropetyTabPageType.server.index,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return AlertDialog(
      buttonPadding: const EdgeInsets.all(4),
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          SizedBox(
            height: 36,
            child: TabBar(
              controller: _controller,
              indicator: BoxDecoration(
                color: colorTheme.primary.withAlpha(200),
                // border: Border(
                //   bottom: BorderSide(
                //     color: colorTheme.primary.withAlpha(200),
                //   ),
                // ),
              ),
              labelColor: colorTheme.onSecondary,
              unselectedLabelColor: colorTheme.primary.withAlpha(200),
              tabs: PropetyTabPageType.values
                  .map<Tab>(
                    (e) => Tab(
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            height: 3,
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              width: 280,
              color: Colors.white,
              child: TabBarView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ServerPropertiesSection(),
                  CubePropertiesMainSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(serverPagePropertyDialogLeave.i18n),
        ),
        TextButton(
          onPressed: () {
            context.read<ServerPropertiesBloc>().add(ServerPropertiesSaved());
            context.read<CubePropertiesBloc>().add(CubePropertiesSaved());
          },
          child: Text(serverPagePropertyDialogSave.i18n),
        ),
      ],
    );
  }
}

class ServerPropertiesSection extends StatelessWidget {
  const ServerPropertiesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        ServerPropertiesMainSection(),
        WikiSection(),
      ],
    );
  }
}

class WikiSection extends StatelessWidget {
  const WikiSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(right: 4, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            serverPagePropertyDialogServerInfoFrom.i18n,
            style: textTheme.bodySmall,
          ),
          GestureDetector(
            child: Text(
              serverPagePropertyDialogFromMinecraftWiki.i18n,
              style: textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.underline,
                color: Colors.blueAccent,
              ),
            ),
            onTap: () {
              context.read<LauncherRepository>().launch(
                    path: 'https://minecraft.gamepedia.com/Minecraft_Wiki',
                  );
              // launch(
              //     'https://minecraft.gamepedia.com/Minecraft_Wiki');
            },
          )
        ],
      ),
    );
  }
}

class ServerPropertiesMainSection extends StatelessWidget {
  const ServerPropertiesMainSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerPropertiesBloc, ServerPropertiesState>(
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final property = state.properties[index];
            return CommonPropertyTile(
              property: property,
              onChanged: (value) => context.read<ServerPropertiesBloc>().add(
                    ServerPropertiesChanged(
                      fieldName: property.fieldName,
                      value: value,
                    ),
                  ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.properties.length,
        );
      },
    );
  }
}

class CubePropertiesMainSection extends StatelessWidget {
  const CubePropertiesMainSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubePropertiesBloc, CubePropertiesState>(
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final property = state.properties[index];
            return CommonPropertyTile(
              property: property,
              onChanged: (value) => context.read<CubePropertiesBloc>().add(
                    CubePropertiesChanged(
                      fieldName: property.fieldName,
                      value: value,
                    ),
                  ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.properties.length,
        );
      },
    );
  }
}

class CommonPropertyTile extends StatelessWidget {
  const CommonPropertyTile({
    required this.property,
    this.onChanged,
    Key? key,
  }) : super(key: key);
  final CommonProperty property;
  final void Function(dynamic value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final property = this.property;
    final onChanged = this.onChanged;
    if (property is IntegerServerProperty) {
      if (property.selectables.keys.isNotEmpty) {
        return EnumIntPropertyListTile(
          title: property.name,
          fieldName: property.fieldName,
          description: property.description,
          value: property.value,
          selects: property.selectables,
          onChanged: (value) => onChanged?.call(value),
        );
      } else {
        return IntegerPropertyListTile(
          title: property.name,
          fieldName: property.fieldName,
          description: property.description,
          value: property.value,
          onChanged: (value) => onChanged?.call(value),
        );
      }
    } else if (property is BoolServerProperty) {
      return BoolPropertyListTile(
        title: property.name,
        fieldName: property.fieldName,
        description: property.description,
        value: property.value,
        onChanged: (value) => onChanged?.call(value),
      );
    } else if (property is StringServerProperty) {
      if (property.selectables.keys.isNotEmpty) {
        return EnumStringPropertyListTile(
          title: property.name,
          fieldName: property.fieldName,
          description: property.description,
          value: property.value,
          selects: property.selectables,
          onChanged: (value) => onChanged?.call(value),
        );
      } else {
        return StringPropertyListTile(
          title: property.name,
          fieldName: property.fieldName,
          description: property.description,
          value: property.value,
          onChanged: (value) => onChanged?.call(value),
        );
      }
    }
    return PropertyListTile(
      title: property.name,
      fieldName: property.fieldName,
      description: property.description,
    );
  }
}
