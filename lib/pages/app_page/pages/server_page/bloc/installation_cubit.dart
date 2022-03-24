import 'package:bloc/bloc.dart';
import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installation_cubit.i18n.dart';

class InstallationState extends Equatable {
  const InstallationState({
    required this.status,
    required this.serverName,
    required this.projectPath,
    this.installer,
    required this.logs,
  });
  final NetworkStatus status;
  final Installer? installer;
  final String serverName;
  final String projectPath;
  final Iterable<ConsoleLine> logs;

  @override
  List<Object?> get props => [status, installer, serverName, logs];

  InstallationState copyWith({
    NetworkStatus? status,
    Installer? installer,
    String? serverName,
    String? projectPath,
    Iterable<ConsoleLine>? logs,
  }) {
    return InstallationState(
      status: status ?? this.status,
      installer: installer ?? this.installer,
      serverName: serverName ?? this.serverName,
      projectPath: projectPath ?? this.projectPath,
      logs: logs ?? this.logs,
    );
  }
}

enum InstallationType { installers, servers }

class InstallationCubit extends Cubit<InstallationState> {
  InstallationCubit({
    required this.installerRepository,
  }) : super(
          const InstallationState(
            status: NetworkStatus.uninit,
            serverName: '',
            projectPath: '',
            installer: null,
            logs: [],
          ),
        );
  final InstallerRepository installerRepository;

  Future<void> install({
    required Installer installer,
    required String projectName,
    required String installerPath,
  }) async {
    emit(
      state.copyWith(
        status: NetworkStatus.uninit,
        projectPath: '',
        serverName: '',
        logs: [],
      ),
    );
    try {
      await _createProject(installer, projectName);
      await _copyInstaller(installerPath, projectName);
      await _installMap(installer.mapZipPath, projectName);
      await _installMods(installer.modelSettings, projectName);
      await _installModpack(installer.modelPack, projectName);
      await _installServer(installer.serverPath, projectName);
      emit(
        state.copyWith(
          status: NetworkStatus.success,
          logs: generateOneLineConsoleLine(installationComplete.i18n),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NetworkStatus.failure,
          logs: generateOneLineConsoleLine(e.toString()),
        ),
      );
    }
  }

  Future<void> _createProject(Installer installer, String projectName) async {
    final projectPath =
        await installerRepository.createProject(projectName: projectName);
    emit(
      state.copyWith(
        installer: installer,
        serverName: projectName,
        status: NetworkStatus.inProgress,
        projectPath: projectPath,
        logs: generateOneLineConsoleLine(
          installationCreateProject.i18n.fill([projectName]),
        ),
      ),
    );
  }

  Future<void> _copyInstaller(String installerPath, String projectName) async {
    emit(
      state.copyWith(
        logs: generateOneLineConsoleLine(
          installationCopyInstaller.i18n.fill([installerPath]),
        ),
      ),
    );
    await installerRepository.copyInstaller(
      installerPath: installerPath,
      projectName: projectName,
    );
  }

  Future<void> _installMap(String? mapZipPath, String projectName) async {
    final mapPath = mapZipPath;
    if (mapPath != null && mapPath.isNotEmpty) {
      emit(
        state.copyWith(
          logs: generateOneLineConsoleLine(
            installationInstallMap.i18n.fill([mapPath]),
          ),
        ),
      );
      await for (final _ in installerRepository.installMap(
        url: mapPath,
        projectName: projectName,
      )) {}
    }
  }

  Future<void> _installMods(
    Iterable<ModelSetting> settings,
    String projectName,
  ) async {
    final modelSettings = settings;
    if (modelSettings.isNotEmpty) {
      for (final mod in modelSettings) {
        emit(
          state.copyWith(
            logs: generateOneLineConsoleLine(
              installationInstallMod.i18n.fill([mod.path]),
            ),
          ),
        );
        await for (final _ in installerRepository.installMod(
          url: mod.path,
          modName: mod.program,
          projectName: projectName,
        )) {}
      }
    }
  }

  Future<void> _installModpack(ModelPack? pack, String projectName) async {
    final modpack = pack;
    if (modpack != null) {
      emit(
        state.copyWith(
          logs: generateOneLineConsoleLine(
            installationInstallModpack.i18n.fill([modpack.path]),
          ),
        ),
      );
      await for (final _ in installerRepository.installModpack(
        url: modpack.path,
        projectName: projectName,
      )) {}
    }
  }

  Future<void> _installServer(String serverPath, String projectName) async {
    emit(
      state.copyWith(
        logs: generateOneLineConsoleLine(
          installationInstallServer.i18n.fill([serverPath]),
        ),
      ),
    );
    await for (final _ in installerRepository.installServer(
      url: serverPath,
      projectName: projectName,
    )) {}
  }
}
