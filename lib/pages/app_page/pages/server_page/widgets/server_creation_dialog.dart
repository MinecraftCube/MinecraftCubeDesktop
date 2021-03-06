import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/server_creation_dialog.i18n.dart';
import 'package:path/path.dart' as p;
import 'package:server_management_repository/server_management_repository.dart';

import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installer_manager_cubit.dart';

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

class _ServerCreationDialogViewState extends State<ServerCreationDialogView> {
  late TextEditingController _controller;
  InstallerFile? _selectedInstaller;
  @override
  void initState() {
    context.read<InstallerManagerCubit>().getInstallers();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCreatable =
        _controller.text.isNotEmpty && _selectedInstaller != null;
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
          // Expanded(
          //   child: Container(),
          // ),
          Flexible(
            child: Container(
              width: 320,
              constraints: const BoxConstraints(maxHeight: 320),
              child: BlocBuilder<InstallerManagerCubit, InstallerManagerState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final installer = state.installers[index];
                      return RadioListTile<InstallerFile>(
                        value: installer,
                        title: Text(p.basename(installer.path)),
                        subtitle: Text(installer.installer.name),
                        groupValue: _selectedInstaller,
                        onChanged: (InstallerFile? file) => setState(() {
                          _selectedInstaller = file;
                        }),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: state.installers.length,
                  );
                },
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
              ? () {
                  final installerFile = _selectedInstaller;
                  if (installerFile != null && _controller.text.isNotEmpty) {
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
