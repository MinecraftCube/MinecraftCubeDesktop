import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:server_management_repository/server_management_repository.dart';

abstract class ServersDropdownEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServersValueChanged extends ServersDropdownEvent {
  ServersValueChanged({
    required this.projectPath,
  });
  final String? projectPath;

  @override
  List<Object?> get props => [projectPath];
}

class _ServersMapSynced extends ServersDropdownEvent {}

class ServersDropdownState extends Equatable {
  const ServersDropdownState({
    this.projectPath,
    this.serverPathToName = const {},
  });
  final String? projectPath;
  final Map<String, String> serverPathToName;

  ServersDropdownState copyWith({
    String? projectPath,
    Map<String, String>? serverPathToName,
    bool clearSelected = false,
  }) {
    return ServersDropdownState(
      projectPath: clearSelected ? null : projectPath ?? this.projectPath,
      serverPathToName: serverPathToName ?? this.serverPathToName,
    );
  }

  @override
  List<Object?> get props => [projectPath, serverPathToName];
}

class ServersDropdownBloc
    extends Bloc<ServersDropdownEvent, ServersDropdownState> {
  ServersDropdownBloc({
    required ServerManagementRepository serverManagementRepository,
    Ticker ticker = const Ticker(),
  })  : _serverManagementRepository = serverManagementRepository,
        super(const ServersDropdownState()) {
    on<ServersValueChanged>(_onServersValueChanged);
    on<_ServersMapSynced>(_onServersMapSynced);
    _tickerSub = ticker.loop(period: 2).listen((_) {
      add(_ServersMapSynced());
    });
  }
  final ServerManagementRepository _serverManagementRepository;
  late final StreamSubscription<int> _tickerSub;

  @override
  Future<void> close() {
    _tickerSub.cancel();
    return super.close();
  }

  FutureOr<void> _onServersMapSynced(
    _ServersMapSynced event,
    Emitter<ServersDropdownState> emit,
  ) async {
    final Map<String, String> nameToPath = {};
    await for (final projectPath in _serverManagementRepository.getServers()) {
      nameToPath[projectPath] = p.basename(projectPath);
    }
    final selected =
        nameToPath.containsKey(state.projectPath) ? state.projectPath : null;

    emit(
      state.copyWith(
        serverPathToName: nameToPath,
        projectPath: selected,
        clearSelected: selected == null,
      ),
    );
  }

  FutureOr<void> _onServersValueChanged(
    ServersValueChanged event,
    Emitter<ServersDropdownState> emit,
  ) async {
    await _onServersMapSynced(_ServersMapSynced(), emit);

    final selected = state.serverPathToName.containsKey(event.projectPath)
        ? event.projectPath
        : null;

    emit(
      state.copyWith(
        projectPath: selected,
        clearSelected: selected == null,
      ),
    );
  }
}
