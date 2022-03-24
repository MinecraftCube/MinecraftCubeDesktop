import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:server_management_repository/server_management_repository.dart';

class ServerManagementLauncherState extends Equatable {
  const ServerManagementLauncherState({
    required this.status,
  });
  final NetworkStatus status;

  @override
  List<Object> get props => [status];

  ServerManagementLauncherState copyWith({
    NetworkStatus? status,
  }) {
    return ServerManagementLauncherState(
      status: status ?? this.status,
    );
  }
}

enum ServerManagementLauncherType { installers, servers }

class ServerManagementLauncherCubit
    extends Cubit<ServerManagementLauncherState> {
  ServerManagementLauncherCubit({
    required this.serverManagementRepository,
    required this.launcherRepository,
  }) : super(
          const ServerManagementLauncherState(status: NetworkStatus.uninit),
        );
  final ServerManagementRepository serverManagementRepository;
  final LauncherRepository launcherRepository;

  Future<void> launch(ServerManagementLauncherType? type) async {
    if (type == null) return;
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final path = type == ServerManagementLauncherType.installers
          ? await serverManagementRepository.createInstallersDir()
          : await serverManagementRepository.createServersDir();
      await launcherRepository.launch(path: 'file:$path');
      emit(state.copyWith(status: NetworkStatus.success));
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }
}
