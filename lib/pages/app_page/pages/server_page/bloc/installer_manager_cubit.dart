import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:server_management_repository/server_management_repository.dart';

class InstallerManagerState extends Equatable {
  const InstallerManagerState({
    required this.status,
    required this.installers,
  });
  final NetworkStatus status;
  final List<InstallerFile> installers;

  @override
  List<Object> get props => [status, installers];

  InstallerManagerState copyWith({
    NetworkStatus? status,
    List<InstallerFile>? installers,
  }) {
    return InstallerManagerState(
      status: status ?? this.status,
      installers: installers ?? this.installers,
    );
  }
}

enum InstallerManagerType { installers, servers }

class InstallerManagerCubit extends Cubit<InstallerManagerState> {
  InstallerManagerCubit({
    required this.serverManagementRepository,
  }) : super(
          const InstallerManagerState(
            status: NetworkStatus.uninit,
            installers: [],
          ),
        );
  final ServerManagementRepository serverManagementRepository;

  Future<void> getInstallers() async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final List<InstallerFile> files = [];
      await for (final file in serverManagementRepository.getInstallers()) {
        files.add(file);
      }
      emit(state.copyWith(status: NetworkStatus.success, installers: files));
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }
}
