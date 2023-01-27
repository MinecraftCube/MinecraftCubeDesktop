import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/server_creation_dialog.i18n.dart';
import 'package:path/path.dart' as p;
import 'package:server_management_repository/server_management_repository.dart';

import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installer_manager_cubit.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

class ServerCreationDialogResult extends Equatable {
  final InstallerFile installerFile;
  final String serverName;
  const ServerCreationDialogResult({
    required this.installerFile,
    required this.serverName,
  });

  @override
  List<Object> get props => [installerFile, serverName];
}

class ServerCreationDialog extends StatelessWidget {
  const ServerCreationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InstallerManagerCubit(
        serverManagementRepository: context.read<ServerManagementRepository>(),
        vanillaServerRepository: context.read<VanillaServerRepository>(),
        installerCreatorRepository: context.read<InstallerCreatorRepository>(),
      ),
      child: const ServerCreationDialogView(),
    );
  }
}

class ServerCreationDialogView extends StatefulWidget {
  const ServerCreationDialogView({Key? key}) : super(key: key);

  @override
  State<ServerCreationDialogView> createState() =>
      _ServerCreationDialogViewState();
}

enum ServerCreationType {
  vanilla,
  custom,
}

extension ServerCreationTypeExtension on ServerCreationType {
  get name {
    switch (this) {
      case ServerCreationType.vanilla:
        return serverPageCreationDialogTypeOfficial.i18n;
      case ServerCreationType.custom:
        return serverPageCreationDialogTypeCustom.i18n;
    }
  }
}

class _ServerCreationDialogViewState extends State<ServerCreationDialogView>
    with TickerProviderStateMixin {
  late TabController _createTypeTabController;
  late TextEditingController _controller;
  InstallerFile? _selectedInstaller;
  VanillaManifestVersionInfo? _selectedVersionInfo;
  @override
  void initState() {
    context.read<InstallerManagerCubit>().getInstallers();
    _createTypeTabController = TabController(
      length: ServerCreationType.values.length,
      vsync: this,
      initialIndex: ServerCreationType.vanilla.index,
    );
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _createTypeTabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final isCreatable = _controller.text.isNotEmpty &&
        (_selectedInstaller != null || _selectedVersionInfo != null);
    return AlertDialog(
      buttonPadding: const EdgeInsets.all(4),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(serverPageCreationDialogSelectInstaller.i18n),
          Container(
            height: 3,
            color: Colors.black,
          ),
          TabBar(
            controller: _createTypeTabController,
            indicator: BoxDecoration(
              color: colorTheme.primary.withAlpha(200),
            ),
            labelColor: colorTheme.onSecondary,
            unselectedLabelColor: colorTheme.primary.withAlpha(200),
            tabs: ServerCreationType.values
                .map(
                  (type) => Tab(
                    text: type.name,
                  ),
                )
                .toList(),
          ),
          // Expanded(
          //   child: Container(),
          // ),
          Flexible(
            child: Container(
              width: 320,
              constraints: const BoxConstraints(maxHeight: 320),
              child: TabBarView(
                controller: _createTypeTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  VanillaTabView(
                    versionInfo: _selectedVersionInfo,
                    onChanged: (versionInfo) {
                      setState(() {
                        _selectedVersionInfo = versionInfo;
                        _selectedInstaller = null;
                      });
                    },
                  ),
                  CustomTabView(
                    installerFile: _selectedInstaller,
                    onChanged: (file) {
                      setState(() {
                        _selectedInstaller = file;
                        _selectedVersionInfo = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.amber,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: serverPageCreationDialogServerName.i18n,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(serverPageCreationDialogBack.i18n),
        ),
        TextButton(
          onPressed: isCreatable
              ? () async {
                  final installerFile = _selectedInstaller;
                  final vanillaManifest = _selectedVersionInfo;
                  final hasProjectName = _controller.text.isNotEmpty;
                  if (installerFile != null && hasProjectName) {
                    Navigator.of(context).pop(
                      ServerCreationDialogResult(
                        installerFile: installerFile,
                        serverName: _controller.text,
                      ),
                    );
                  } else if (vanillaManifest != null && hasProjectName) {
                    final installerFile = await context
                        .read<InstallerManagerCubit>()
                        .getVanillaInstaller(vanillaManifest: vanillaManifest);
                    if (!mounted || installerFile == null) return;
                    Navigator.of(context).pop(
                      ServerCreationDialogResult(
                        installerFile: installerFile,
                        serverName: _controller.text,
                      ),
                    );
                  }
                }
              : null,
          child: Text(serverPageCreationDialogCreate.i18n),
        ),
      ],
    );
  }
}

class VanillaTabView extends StatelessWidget {
  const VanillaTabView({
    Key? key,
    this.versionInfo,
    required this.onChanged,
  }) : super(key: key);
  final VanillaManifestVersionInfo? versionInfo;
  final void Function(VanillaManifestVersionInfo versionInfo) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstallerManagerCubit, InstallerManagerState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final vanillaVersion = state.vanillaVersions[index];
            return RadioListTile<VanillaManifestVersionInfo>(
              value: vanillaVersion,
              title: Text(vanillaVersion.id),
              subtitle: Text(vanillaVersion.type),
              groupValue: versionInfo,
              onChanged: (VanillaManifestVersionInfo? vanillaVersion) {
                if (vanillaVersion == null) return;
                onChanged(vanillaVersion);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: state.vanillaVersions.length,
        );
      },
    );
  }
}

class CustomTabView extends StatelessWidget {
  const CustomTabView({
    Key? key,
    this.installerFile,
    required this.onChanged,
  }) : super(key: key);
  final InstallerFile? installerFile;
  final void Function(InstallerFile file) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstallerManagerCubit, InstallerManagerState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final installer = state.installers[index];
            return RadioListTile<InstallerFile>(
              value: installer,
              title: Text(p.basename(installer.path)),
              subtitle: Text(installer.installer.name),
              groupValue: installerFile,
              onChanged: (InstallerFile? file) {
                if (file == null) return;
                onChanged(file);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: state.installers.length,
        );
      },
    );
  }
}
