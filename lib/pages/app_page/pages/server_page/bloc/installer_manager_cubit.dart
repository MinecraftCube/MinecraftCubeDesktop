import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:server_management_repository/server_management_repository.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

class InstallerManagerState extends Equatable {
  const InstallerManagerState({
    required this.status,
    required this.installers,
    required this.vanillaVersions,
  });
  final NetworkStatus status;
  final List<InstallerFile> installers;
  final List<VanillaManifestVersionInfo> vanillaVersions;

  @override
  List<Object> get props => [status, installers];

  InstallerManagerState copyWith({
    NetworkStatus? status,
    List<InstallerFile>? installers,
    List<VanillaManifestVersionInfo>? vanillaVersions,
  }) {
    return InstallerManagerState(
      status: status ?? this.status,
      installers: installers ?? this.installers,
      vanillaVersions: vanillaVersions ?? this.vanillaVersions,
    );
  }
}

enum InstallerManagerType { installers, servers }

class InstallerManagerCubit extends Cubit<InstallerManagerState> {
  InstallerManagerCubit({
    required this.serverManagementRepository,
    required this.vanillaServerRepository,
    required this.installerCreatorRepository,
  }) : super(
          const InstallerManagerState(
            status: NetworkStatus.uninit,
            installers: [],
            vanillaVersions: [],
          ),
        );
  final ServerManagementRepository serverManagementRepository;
  final VanillaServerRepository vanillaServerRepository;
  final InstallerCreatorRepository installerCreatorRepository;

  Future<void> getInstallers() async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final List<InstallerFile> files = [];
      await for (final file in serverManagementRepository.getInstallers()) {
        files.add(file);
      }
      final servers = await vanillaServerRepository.getServers();
      emit(
        state.copyWith(
          status: NetworkStatus.success,
          installers: files,
          vanillaVersions: servers,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }

  Future<InstallerFile?> getVanillaInstaller({
    required VanillaManifestVersionInfo vanillaManifest,
  }) async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final downloadInfo = await vanillaServerRepository.getServerByVersionInfo(
        url: vanillaManifest.url,
      );
      await serverManagementRepository.createInstallersDir(
        subfolder: '_vanilla',
      );
      final pathToInstaller = await installerCreatorRepository.create(
        name: vanillaManifest.id,
        description: vanillaManifest.type,
        server: downloadInfo.url,
        type: JarType.vanilla,
        map: '',
        settings: [],
        pack: null,
        subfolder: '_vanilla',
      );
      emit(state.copyWith(status: NetworkStatus.success));
      return InstallerFile(
        installer: pathToInstaller.value,
        path: pathToInstaller.key,
      );
    } catch (err) {
      emit(state.copyWith(status: NetworkStatus.failure));
      return null;
    }
  }
}
