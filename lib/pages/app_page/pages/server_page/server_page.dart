import 'package:console_repository/console_repository.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installation_cubit.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/server_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/server_management_launcher_cubit.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/server_page.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/dangerous_alert_dialog.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/eula_agreement_dialog.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/minecraft_command_text_field.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/property_dialogs.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/server_creation_dialog.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/widgets/servers_dropdown.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';
import 'package:server_configuration_repository/server_configuration_repository.dart';
import 'package:server_management_repository/server_management_repository.dart';
import 'package:server_repository/server_repository.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({Key? key}) : super(key: key);

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage>
    with AutomaticKeepAliveClientMixin {
  late ServerMachine _serverMachine;
  late InstallationCubit _installationCubit;
  @override
  void initState() {
    _serverMachine = ServerMachine(
      processCleanerRepository: context.read<ProcessCleanerRepository>(),
      duplicateCleanerRepository: context.read<DuplicateCleanerRepository>(),
      eulaStageRepository: context.read<EulaStageRepository>(),
      jarAnalyzerRepository: context.read<JarAnalyzerRepository>(),
      cubePropertiesRepository: context.read<CubePropertiesRepository>(),
      javaPrinterRepository: context.read<JavaPrinterRepository>(),
      javaDuplicatorRepository: context.read<JavaDuplicatorRepository>(),
      forgeInstallerRepository: context.read<ForgeInstallerRepository>(),
      serverRepository: context.read<ServerRepository>(),
      consoleRepository: context.read<ConsoleRepository>(),
      serverConfigurationRepository:
          context.read<ServerConfigurationRepository>(),
    );
    _installationCubit = InstallationCubit(
      installerRepository: context.read<InstallerRepository>(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _installationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServerManagementLauncherCubit(
            launcherRepository: context.read<LauncherRepository>(),
            serverManagementRepository:
                context.read<ServerManagementRepository>(),
          ),
        ),
        // BlocProvider.value(value: _installationCubit),
        BlocProvider(
          create: (context) => ServerBloc(
            machine: _serverMachine,
            installationCubit: _installationCubit,
          ),
        ),
      ],
      child: const ServerPageView(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ServerPageView extends StatefulWidget {
  const ServerPageView({Key? key}) : super(key: key);

  @override
  State<ServerPageView> createState() => _ServerPageViewState();
}

class _ServerPageViewState extends State<ServerPageView>
    with AutomaticKeepAliveClientMixin<ServerPageView> {
  String? activeProjectPath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    const gap = SizedBox(
      height: 12,
    );
    return BlocListener<ServerBloc, ServerState>(
      listenWhen: (prev, current) => current.type != prev.type,
      listener: (context, state) {
        if (state.type == ServerType.none) return;
        final agree = showDialog<bool>(
          context: context,
          builder: (context) => state.type == ServerType.eula
              ? const EulaAgreementDialog()
              : const DangerousAlertDialog(),
        );
        agree.then((value) {
          if (value == true) {
            context.read<ServerBloc>().add(AgreementConfirmed());
          } else {
            context.read<ServerBloc>().add(AgreementRejected());
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(child: ServerSection(projectPath: activeProjectPath)),
            gap,
            const ServerActionSection(),
            gap,
            AssistentActionSection(
              onCreated: (
                InstallerFile file,
                String serverName,
              ) {
                context.read<ServerBloc>().add(
                      ProjectCreated(
                        installer: file.installer,
                        installerPath: file.path,
                        serverName: serverName,
                      ),
                    );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ServerSection extends StatefulWidget {
  const ServerSection({Key? key, this.projectPath}) : super(key: key);
  final String? projectPath;

  @override
  State<ServerSection> createState() => _ServerSectionState();
}

class _ServerSectionState extends State<ServerSection> {
  // late TextEditingController _controller;
  // late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    // _controller = TextEditingController();
    // _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                  bottom: Radius.zero,
                ),
              ),
              child: BlocBuilder<ServerBloc, ServerState>(
                buildWhen: (previous, current) =>
                    previous.lines != current.lines,
                builder: (context, state) {
                  return ConsoleLinesDisplayer(lines: state.lines);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: BlocBuilder<ServerBloc, ServerState>(
              buildWhen: (previous, current) =>
                  previous.stable != current.stable,
              builder: (context, state) {
                return Row(
                  children: [
                    Text(
                      serverPageCommandInput.i18n,
                      style: Theme.of(context).textTheme.overline?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: MinecraftCommandTextField(
                        enabled: state.stable,
                        onSubmitted: (command) {
                          if (command.isNotEmpty) {
                            context
                                .read<ServerBloc>()
                                .add(CommandInputted(command: command));
                          }
                        },
                      ),
                      // child: TextField(
                      //   controller: _controller,
                      //   focusNode: _focusNode,
                      //   enabled: state.stable,
                      //   decoration: const InputDecoration(
                      //     border: InputBorder.none,
                      //     isDense: true,
                      //     contentPadding: EdgeInsets.symmetric(vertical: 12),
                      //   ),
                      //   style: Theme.of(context).textTheme.overline?.copyWith(
                      //         color: Theme.of(context).colorScheme.onBackground,
                      //       ),
                      //   onSubmitted: (text) {
                      //     context
                      //         .read<ServerBloc>()
                      //         .add(CommandInputted(command: text));
                      //     _controller.clear();
                      //     _focusNode.requestFocus();
                      //   },
                      // ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServerActionSection extends StatefulWidget {
  const ServerActionSection({Key? key}) : super(key: key);

  @override
  State<ServerActionSection> createState() => _ServerActionSectionState();
}

class _ServerActionSectionState extends State<ServerActionSection> {
  String? _projectPath;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(
      width: 6,
    );
    return BlocBuilder<ServerBloc, ServerState>(
      buildWhen: (previous, current) {
        return previous.isIdle != current.isIdle ||
            previous.stable != current.stable;
      },
      builder: (context, state) {
        // enable: Idle and Selctor has value,
        // enable(stop): stable true
        final normalEnable = state.isIdle && _projectPath != null;
        final stableEnable = state.stable;
        final enable = stableEnable || normalEnable;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(serverPageSelectServer.i18n),
            gap,
            ServersDropdown(
              enabled: normalEnable,
              onProjectPathChanged: (String? projectPath) {
                setState(() {
                  _projectPath = projectPath;
                });
              },
              projectPath: _projectPath,
            ),
            gap,
            ElevatedButton(
              onPressed: enable
                  ? () {
                      if (stableEnable) {
                        context.read<ServerBloc>().add(StopCommandInputted());
                      } else {
                        final projectPath = _projectPath;
                        if (projectPath != null) {
                          context
                              .read<ServerBloc>()
                              .add(ProjectSelected(projectPath: projectPath));
                        }
                      }
                    }
                  : null,
              child: Text(
                stableEnable
                    ? serverPageServerStop.i18n
                    : serverPageServerStart.i18n,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  } else if (stableEnable) {
                    return Colors.redAccent;
                  } else {
                    return Colors.green;
                  }
                }),
              ),
            ),
            // gap,
            // ElevatedButton(onPressed: () {}, child: const Text('強制停止')),
            gap,
            ElevatedButton(
              onPressed: normalEnable
                  ? () async {
                      final projectPath = _projectPath;
                      if (projectPath != null) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return PropertyDialog(
                              projectPath: projectPath,
                            );
                          },
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 40),
                maximumSize: const Size(40, 40),
              ),
              child: const Icon(Icons.settings),
            ),
          ],
        );
      },
    );
  }
}

class AssistentActionSection extends StatelessWidget {
  const AssistentActionSection({
    Key? key,
    this.onCreated,
  }) : super(key: key);
  final void Function(
    InstallerFile installerFile,
    String serverName,
  )? onCreated;

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(
      width: 4,
    );
    return Row(
      children: [
        BlocBuilder<ServerBloc, ServerState>(
          buildWhen: (prev, current) => prev.isIdle != current.isIdle,
          builder: (context, state) {
            return TextButton.icon(
              style: TextButton.styleFrom(
                side: const BorderSide(),
                // shape: const StadiumBorder(),
              ),
              onPressed: state.isIdle
                  ? () async {
                      final result =
                          await showDialog<ServerCreationDialogResult>(
                        context: context,
                        builder: (context) {
                          return const ServerCreationDialog();
                        },
                      );
                      if (result == null) return;
                      final onCreatedEvent = onCreated;
                      if (onCreatedEvent != null) {
                        onCreatedEvent(
                          result.installerFile,
                          result.serverName,
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.add),
              label: Text(serverPageServerCreate.i18n),
            );
          },
        ),
        gap,
        TextButton(
          style: TextButton.styleFrom(
            side: const BorderSide(),
            // shape: const StadiumBorder(),
          ),
          onPressed: () async {
            context
                .read<ServerManagementLauncherCubit>()
                .launch(ServerManagementLauncherType.installers);
          },
          child: Text(serverPageServerInstallersFolder.i18n),
        ),
        gap,
        TextButton(
          style: TextButton.styleFrom(
            side: const BorderSide(),
            // shape: const StadiumBorder(),
          ),
          onPressed: () async {
            context
                .read<ServerManagementLauncherCubit>()
                .launch(ServerManagementLauncherType.servers);
          },
          child: Text(serverPageServerServersFolder.i18n),
        ),
      ],
    );
  }
}

class ConsoleLinesDisplayer extends StatefulWidget {
  const ConsoleLinesDisplayer({
    required this.lines,
    Key? key,
  }) : super(key: key);
  final Iterable<ConsoleLine> lines;

  @override
  State<ConsoleLinesDisplayer> createState() => _ConsoleLinesDisplayerState();
}

class _ConsoleLinesDisplayerState extends State<ConsoleLinesDisplayer> {
  late final ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ConsoleLinesDisplayer oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.lines;
    final textTheme = Theme.of(context).textTheme;
    final texts = <ConsoleText>[];
    const lineBreak = ConsoleText(text: '\n');
    for (final line in lines) {
      for (final text in line.texts) {
        texts.add(text);
      }
      texts.add(lineBreak);
    }
    return SingleChildScrollView(
      controller: _controller,
      child: SelectableText.rich(
        TextSpan(
          style: textTheme.caption,
          children: texts
              .map(
                (e) => TextSpan(
                  text: e.text,
                  style: TextStyle(
                    fontWeight: e.bold ? FontWeight.bold : null,
                    backgroundColor: e.background,
                    color: e.foreground,
                  ),
                ),
              )
              .toList(),
        ),
        textScaleFactor: 1.0,
      ),
    );
  }
}
// serverDetectorRepo
// installerDetectorRepo
// ?? serverConfigurationRepo (read server.properties, write server.properties, read cube.properties, write cube.properties)
