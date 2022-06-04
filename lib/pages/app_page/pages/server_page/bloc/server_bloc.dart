import 'dart:async';
import 'dart:math' as Math;

import 'package:bloc/bloc.dart';
import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installation_cubit.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_ask_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_dangerous_ask_state.dart';
import 'package:rxdart/rxdart.dart';

abstract class ServerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectCreated extends ServerEvent {
  final Installer installer;
  final String installerPath;
  final String serverName;
  ProjectCreated({
    required this.installer,
    required this.installerPath,
    required this.serverName,
  });

  @override
  List<Object?> get props =>
      [super.props, installer, installerPath, serverName];
}

class ProjectSelected extends ServerEvent {
  final String projectPath;
  ProjectSelected({
    required this.projectPath,
  });
  @override
  List<Object?> get props => [super.props, projectPath];
}

class AgreementConfirmed extends ServerEvent {}

class AgreementRejected extends ServerEvent {}

class CommandInputted extends ServerEvent {
  final String command;
  CommandInputted({
    required this.command,
  });
  @override
  List<Object?> get props => [super.props, command];
}

class StopCommandInputted extends ServerEvent {}

class _LogChanged extends ServerEvent {
  final Iterable<ConsoleLine> lines;
  _LogChanged({
    required this.lines,
  });

  @override
  List<Object?> get props => [super.props, lines];
}

class _UserActionNeeded extends ServerEvent {
  final ServerType type;
  _UserActionNeeded({
    required this.type,
  });

  @override
  List<Object?> get props => [super.props, type];
}

class _MachineStableFetched extends ServerEvent {
  final bool stable;
  _MachineStableFetched({
    required this.stable,
  });

  @override
  List<Object?> get props => [super.props, stable];
}

class _MachineIdleChanged extends ServerEvent {
  final bool isIdle;
  _MachineIdleChanged({
    required this.isIdle,
  });

  @override
  List<Object?> get props => [super.props, isIdle];
}

enum ServerType { none, eula, dangerous }

enum ServerProgress { idle, run }

class ServerState extends Equatable {
  const ServerState({
    this.installer,
    this.installerPath,
    this.serverName,
    this.type = ServerType.none,
    this.progress = ServerProgress.idle,
    required this.lines,
    this.stable = false,
    this.isIdle = true,
  });
  final Installer? installer;
  final String? installerPath;
  final String? serverName;
  final List<ConsoleLine> lines;
  final bool stable;
  final ServerType type;
  final ServerProgress progress;
  final bool isIdle;

  @override
  List<Object?> get props => [
        installer,
        installerPath,
        serverName,
        lines,
        stable,
        type,
        progress,
        isIdle,
      ];

  ServerState copyWith({
    Installer? installer,
    String? installerPath,
    String? serverName,
    List<ConsoleLine>? lines,
    bool? stable,
    bool? isIdle,
    ServerType? type,
    ServerProgress? progress,
  }) {
    return ServerState(
      installer: installer ?? this.installer,
      installerPath: installerPath ?? this.installerPath,
      serverName: serverName ?? this.serverName,
      lines: lines ?? this.lines,
      stable: stable ?? this.stable,
      type: type ?? this.type,
      progress: progress ?? this.progress,
      isIdle: isIdle ?? this.isIdle,
    );
  }
}

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  ServerBloc({
    required this.machine,
    required this.installationCubit,
  }) : super(
          const ServerState(
            lines: [],
            stable: false,
          ),
        ) {
    _installationSub = installationCubit.stream.listen((installationState) {
      add(_LogChanged(lines: installationState.logs));
      if (installationState.status == NetworkStatus.success) {
        add(ProjectSelected(projectPath: installationState.projectPath));
        // add(_MachineIdleChanged(isIdle: true));
      } else if (installationState.status == NetworkStatus.failure) {
        add(_MachineIdleChanged(isIdle: true));
      }
    });
    _machineLogSub = machine.logStream
        .bufferTime(const Duration(milliseconds: 500))
        .map<Iterable<ConsoleLine>>(
          (event) => event.fold<List<ConsoleLine>>(
            [],
            (previousValue, element) => previousValue..addAll(element),
          ),
        )
        .listen((logs) {
      add(_LogChanged(lines: logs));
    });
    _machineStateSub = machine.stateStream.listen((machineState) {
      final currentMachineState = machineState;
      if (currentMachineState is EulaAskState) {
        add(_UserActionNeeded(type: ServerType.eula));
      } else if (currentMachineState is JarDangerousAskState) {
        add(_UserActionNeeded(type: ServerType.dangerous));
      } else {
        if (state.type != ServerType.none) {
          add(_UserActionNeeded(type: ServerType.none));
        }
      }
      add(_MachineIdleChanged(isIdle: currentMachineState is IdleState));
    });
    _machineStableSub = machine.stableStream.listen((machineStable) {
      add(_MachineStableFetched(stable: machineStable));
    });

    on<ServerEvent>(_onServerEvent, transformer: _transformer());
    // on<ProjectCreated>(_onProjectCreated);
    // on<_LogChanged>(_onInstallationChanged);
  }
  final ServerMachine machine;
  final InstallationCubit installationCubit;
  late final StreamSubscription<InstallationState> _installationSub;
  late final StreamSubscription<Iterable<ConsoleLine>> _machineLogSub;
  late final StreamSubscription<IState> _machineStateSub;
  late final StreamSubscription<bool> _machineStableSub;

  EventTransformer<ServerEvent> _transformer() {
    bool isSequenceEvent(ServerEvent event) {
      return event is ProjectSelected ||
          event is _UserActionNeeded ||
          event is _MachineStableFetched;
    }

    return (events, mapper) {
      final normalStream =
          events.where((event) => !isSequenceEvent(event)).flatMap(mapper);

      final sequenceStream =
          events.where((event) => isSequenceEvent(event)).asyncExpand(mapper);

      return MergeStream([normalStream, sequenceStream]);
    };
  }

  @override
  Future<void> close() async {
    _installationSub.cancel();
    _machineLogSub.cancel();
    _machineStateSub.cancel();
    _machineStableSub.cancel();
    await machine.dispose();
    return super.close();
  }

  _onServerEvent(ServerEvent event, Emitter<ServerState> emit) async {
    if (event is ProjectCreated) {
      await _onProjectCreated(event, emit);
    } else if (event is _LogChanged) {
      await _onLogChanged(event, emit);
    } else if (event is ProjectSelected) {
      await _onProjectSelected(event, emit);
    } else if (event is AgreementConfirmed) {
      machine.agree();
    } else if (event is AgreementRejected) {
      machine.disagree();
    } else if (event is CommandInputted) {
      machine.input(event.command);
    } else if (event is StopCommandInputted) {
      machine.input('stop');
    } else if (event is _UserActionNeeded) {
      await _onUserActionNeeded(event, emit);
    } else if (event is _MachineStableFetched) {
      await _onMachineStableFetched(event, emit);
    } else if (event is _MachineIdleChanged) {
      await _onMachineIdleChanged(event, emit);
    }
  }

  _onProjectCreated(ProjectCreated event, Emitter<ServerState> emit) async {
    emit(state.copyWith(lines: [], isIdle: false));
    await installationCubit.install(
      installer: event.installer,
      projectName: event.serverName,
      installerPath: event.installerPath,
    );
  }

  _onProjectSelected(ProjectSelected event, Emitter<ServerState> emit) async {
    emit(state.copyWith(lines: [], isIdle: false));
    machine.start(event.projectPath);
  }

  _onLogChanged(
    _LogChanged event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(lines: _addLine(event.lines)));
  }

  _onUserActionNeeded(
    _UserActionNeeded event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(type: event.type));
  }

  _onMachineStableFetched(
    _MachineStableFetched event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(stable: event.stable));
  }

  _onMachineIdleChanged(
    _MachineIdleChanged event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(isIdle: event.isIdle));
  }
  // _onProjectSelect(ProjectSelected event, Emitter<ServerState> emit) async {
  //   machine.start(event.projectPath);
  // }

  List<ConsoleLine> _addLine(Iterable<ConsoleLine> lines) {
    final currentLines = List<ConsoleLine>.from(state.lines);
    currentLines.addAll(lines);
    return currentLines.sublist(
      Math.max(0, currentLines.length - 100),
      currentLines.length,
    );
  }
}
