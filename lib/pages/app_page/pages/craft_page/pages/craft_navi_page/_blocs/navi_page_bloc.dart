import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:server_management_repository/server_management_repository.dart';

abstract class NaviPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NaviInstallerNameChanged extends NaviPageEvent {
  final String value;
  NaviInstallerNameChanged(this.value);
  @override
  List<Object> get props => [value];
}

class NaviDescriptionChanged extends NaviPageEvent {
  final String value;
  NaviDescriptionChanged(this.value);
  @override
  List<Object> get props => [value];
}

class NaviJarTypeChanged extends NaviPageEvent {
  final JarType value;
  NaviJarTypeChanged(this.value);
  @override
  List<Object> get props => [value];
}

class NaviServerDownloadPathChanged extends NaviPageEvent {
  final String value;
  NaviServerDownloadPathChanged(this.value);
  @override
  List<Object> get props => [value];
}

class NaviMapDownloadPathChanged extends NaviPageEvent {
  final String value;
  NaviMapDownloadPathChanged(this.value);
  @override
  List<Object> get props => [value];
}

class AddPackUrlEvent extends NaviPageEvent {
  final String path;

  AddPackUrlEvent(this.path);

  @override
  List<Object> get props => [path];
}

class AddPackDescEvent extends NaviPageEvent {
  final String desc;

  AddPackDescEvent(this.desc);

  @override
  List<Object> get props => [desc];
}

class NaviModelPackChanged extends NaviPageEvent {
  final ModelPack pack;
  NaviModelPackChanged(this.pack);

  @override
  List<Object?> get props => [pack];
}

class SwitchModelerEvent extends NaviPageEvent {
  SwitchModelerEvent();
}

class ModifyModelSettingEvent extends NaviPageEvent {
  final int index;
  final String name;
  final String program;
  final String path;
  ModifyModelSettingEvent({
    required this.index,
    required this.name,
    required this.program,
    required this.path,
  });
  @override
  List<Object> get props => [index, name, program, path];
}

class AddModelSettingEvent extends NaviPageEvent {
  AddModelSettingEvent();
  @override
  List<Object> get props => [DateTime.now()];
}

class NaviModelSettingsChanged extends NaviPageEvent {
  final List<ModelSetting> settings;
  NaviModelSettingsChanged({
    required this.settings,
  });

  @override
  List<Object?> get props => [settings];
}

class DeleteModelSettingPathEvent extends NaviPageEvent {
  final int index;
  DeleteModelSettingPathEvent(this.index);
  @override
  List<Object> get props => [DateTime.now(), index];
}

class NaviInstallerCreated extends NaviPageEvent {
  @override
  List<Object> get props => [DateTime.now()];
}

class NaviPageState extends Equatable {
  final String installerName;
  final String description;
  final JarType type;
  final String serverDownloadPath;
  final String mapDownloadPath;
  final List<ModelSetting> settings;
  final ModelPack? pack;
  final NetworkStatus status;

  // bool get installerValid => installerName != null && installerName.isNotEmpty;
  // bool get descriptionValid => description != null && description.isNotEmpty;
  // bool get serverDownloadValid =>
  //     serverDownloadPath != null &&
  //     serverDownloadPath.isNotEmpty &&
  //     Validators.isUrlValid(serverDownloadPath);
  // bool get mapDownloadValid =>
  //     mapDownloadPath != null &&
  //     mapDownloadPath.isNotEmpty &&
  //     Validators.isUrlValid(mapDownloadPath);

  // bool checkModelSettingValid(ModelSetting setting) {
  //   return setting.name != null &&
  //       setting.name.isNotEmpty &&
  //       setting.program != null &&
  //       setting.program.isNotEmpty &&
  //       setting.path != null &&
  //       setting.path.isNotEmpty &&
  //       Validators.isUrlValid(serverDownloadPath);
  // }

  // bool isModelSettingNameValid(int index) {
  //   if (settings.length < index) return false;
  //   return settings[index].name != null && settings[index].name.isNotEmpty;
  // }

  // bool isModelSettingProgramValid(int index) {
  //   if (settings.length < index) return false;
  //   return settings[index].program != null &&
  //       settings[index].program.isNotEmpty;
  // }

  // bool isModelSettingPathValid(int index) {
  //   if (settings.length < index) return false;
  //   return settings[index].path != null &&
  //       settings[index].path.isNotEmpty &&
  //       Validators.isUrlValid(settings[index].path);
  // }

  // bool isModelSettingValid(int index) {
  //   if (settings.length < index) return false;
  //   return isModelSettingNameValid(index) &&
  //       isModelSettingProgramValid(index) &&
  //       isModelSettingPathValid(index);
  // }

  // bool isModelPackValid() {
  //   return pack != null &&
  //       pack.path != null &&
  //       pack.path.isNotEmpty &&
  //       Validators.isUrlValid(pack.path);
  // }

  const NaviPageState({
    this.installerName = '',
    this.description = '',
    this.type = JarType.vanilla,
    this.serverDownloadPath = '',
    this.mapDownloadPath = '',
    this.settings = const [],
    this.pack,
    this.status = NetworkStatus.uninit,
  });

  @override
  List<Object?> get props => [
        installerName,
        description,
        type,
        serverDownloadPath,
        mapDownloadPath,
        settings,
        pack,
        status
      ];

  NaviPageState copyWith({
    String? installerName,
    String? description,
    JarType? type,
    String? serverDownloadPath,
    String? mapDownloadPath,
    List<ModelSetting>? settings,
    ModelPack? pack,
    NetworkStatus? status,
    bool clearModelPack = false,
  }) {
    return NaviPageState(
      installerName: installerName ?? this.installerName,
      description: description ?? this.description,
      type: type ?? this.type,
      serverDownloadPath: serverDownloadPath ?? this.serverDownloadPath,
      mapDownloadPath: mapDownloadPath ?? this.mapDownloadPath,
      settings: settings ?? this.settings,
      pack: clearModelPack ? null : pack ?? this.pack,
      status: status ?? this.status,
    );
  }
}

class NaviPageBloc extends Bloc<NaviPageEvent, NaviPageState> {
  final LauncherRepository _launcherRepository;
  final ServerManagementRepository _serverManagementRepository;
  final InstallerCreatorRepository _installerCreatorRepository;

  NaviPageBloc({
    required LauncherRepository launcherRepository,
    required ServerManagementRepository serverManagementRepository,
    required InstallerCreatorRepository installerCreatorRepository,
  })  : _launcherRepository = launcherRepository,
        _installerCreatorRepository = installerCreatorRepository,
        _serverManagementRepository = serverManagementRepository,
        super(const NaviPageState()) {
    on<NaviInstallerNameChanged>(_onNaviInstallerNameChanged);
    on<NaviDescriptionChanged>(_onNaviDescriptionChanged);
    on<NaviJarTypeChanged>(_onNaviJarTypeChanged);
    on<NaviServerDownloadPathChanged>(_onNaviServerDownloadPathChanged);
    on<NaviMapDownloadPathChanged>(_onNaviMapDownloadPathChanged);
    on<NaviModelSettingsChanged>(_onNaviModelSettingsChangedEvent);
    // on<AddModelSettingEvent>((event, emit) => null);
    // on<DeleteModelSettingPathEvent>((event, emit) => null);
    on<NaviModelPackChanged>(_onNaviModelPackChanged);
    // on<AddPackUrlEvent>((event, emit) => null);
    // on<AddPackDescEvent>((event, emit) => null);
    on<NaviInstallerCreated>(_onNaviInstallerCreated);
    // on<SwitchModelerEvent>((event, emit) => null);
  }

  Future<void> _onNaviInstallerNameChanged(
    NaviInstallerNameChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(installerName: event.value),
    );
  }

  Future<void> _onNaviDescriptionChanged(
    NaviDescriptionChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(description: event.value),
    );
  }

  Future<void> _onNaviJarTypeChanged(
    NaviJarTypeChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(type: event.value),
    );
  }

  Future<void> _onNaviServerDownloadPathChanged(
    NaviServerDownloadPathChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(serverDownloadPath: event.value),
    );
  }

  Future<void> _onNaviMapDownloadPathChanged(
    NaviMapDownloadPathChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(mapDownloadPath: event.value),
    );
  }

  Future<void> _onNaviModelSettingsChangedEvent(
    NaviModelSettingsChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(settings: event.settings, clearModelPack: true),
    );
  }

  Future<void> _onNaviModelPackChanged(
    NaviModelPackChanged event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(
      state.copyWith(pack: event.pack, settings: []),
    );
  }

  Future<void> _onNaviInstallerCreated(
    NaviInstallerCreated event,
    Emitter<NaviPageState> emit,
  ) async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final installerPath =
          await _serverManagementRepository.createInstallersDir();
      await _installerCreatorRepository.create(
        name: state.installerName,
        description: state.description,
        server: state.serverDownloadPath,
        type: state.type,
        map: state.mapDownloadPath,
        settings: state.settings,
        pack: state.pack,
      );
      final path = 'file:$installerPath';
      if (await _launcherRepository.canLaunch(path: path)) {
        await _launcherRepository.launch(path: path);
      }
      emit(state.copyWith(status: NetworkStatus.success));
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }

  // Stream<NaviPageState> _mapAddPackUrlEventToState(
  //     AddPackUrlEvent event) async* {
  //   NaviPageState currentState = state;
  //   ModelPack pack;
  //   if (currentState.pack != null) pack = currentState.pack;
  //   pack ??= ModelPack('', '');
  //   pack = pack.copyWith(path: event.path);
  //   yield currentState.copyWith(pack: pack, isPack: true);
  // }

  // Stream<NaviPageState> _mapAddPackDescEventToState(
  //     AddPackDescEvent event) async* {
  //   NaviPageState currentState = state;
  //   ModelPack pack;
  //   if (currentState.pack != null) pack = currentState.pack;
  //   pack ??= ModelPack('', '');
  //   pack = pack.copyWith(description: event.desc);
  //   yield currentState.copyWith(pack: pack, isPack: true);
  // }

  // Stream<NaviPageState> _mapSwitchModelerEventToState(
  //     SwitchModelerEvent event) async* {
  //   NaviPageState currentState = state;
  //   yield currentState.copyWith(isPack: !currentState.isPack);
  // }

  // Stream<NaviPageState> _mapNaviInstallerNameChangedToState(
  //     NaviInstallerNameChanged event) async* {
  //   NaviPageState currentState = state;
  //   yield currentState.copyWith(installerName: event.value);
  // }

  // Stream<NaviPageState> _mapNaviDescriptionChangedToState(
  //     NaviDescriptionChanged event) async* {
  //   NaviPageState currentState = state;
  //   yield currentState.copyWith(description: event.value);
  // }

  // Stream<NaviPageState> _mapNaviJarTypeChangedToState(
  //     NaviJarTypeChanged event) async* {
  //   NaviPageState currentState = state;
  //   yield currentState.copyWith(type: event.value);
  // }

  // Stream<NaviPageState> _mapNaviServerDownloadPathChangedToState(
  //     NaviServerDownloadPathChanged event) async* {
  //   NaviPageState currentState = state;
  //   yield currentState.copyWith(serverDownloadPath: event.value);
  // }

  // Stream<NaviPageState> _mapNaviMapDownloadPathChangedToState(
  //     NaviMapDownloadPathChanged event) async* {
  //   NaviPageState currentState = state;
  //   yield currentState.copyWith(mapDownloadPath: event.value);
  // }

  // Stream<NaviPageState> _mapModifyModelSettingEventToState(
  //     ModifyModelSettingEvent event) async* {
  //   NaviPageState currentState = state;
  //   List<ModelSetting> settings = currentState.settings.toList();
  //   ModelSetting currentSetting = settings[event.index];
  //   settings[event.index] = ModelSetting(
  //       event.name ?? currentSetting.name,
  //       event.program ?? currentSetting.program,
  //       event.path ?? currentSetting.path);
  //   yield currentState.copyWith(settings: settings);
  // }

  // Stream<NaviPageState> _mapAddModelSettingEventToState(
  //     AddModelSettingEvent event) async* {
  //   NaviPageState currentState = state;
  //   List<ModelSetting> settings = currentState.settings.toList();
  //   //ModelSetting currentSetting = settings[event.index];
  //   settings.add(ModelSetting('', '', ''));
  //   yield currentState.copyWith(settings: settings);
  // }

  // Stream<NaviPageState> _mapDeleteModelSettingPathEventToState(
  //     DeleteModelSettingPathEvent event) async* {
  //   NaviPageState currentState = state;
  //   List<ModelSetting> settings = currentState.settings.toList();
  //   settings.removeAt(event.index);
  //   yield currentState.copyWith(settings: settings);
  // }

  // Stream<NaviPageState> _mapNaviInstallerCreatedToState(
  //     NaviInstallerCreated event) async* {
  //   yield state.copyWith(isLoading: true);
  //   String path = Directory.current.path + '/install';
  //   if (!await Directory(path).exists()) await Directory(path).create();
  //   File file = File(path + '/${state.installerName}.dmc');
  //   await file.create();

  //   Install install = Install(
  //     state.installerName,
  //     state.description,
  //     state.type,
  //     state.serverDownloadPath,
  //     modelSettings: state.isPack ? null : state.settings,
  //     modelPack: state.isPack ? state.pack : null,
  //     mapZipPath: state.mapDownloadPath,
  //   );
  //   await file.writeAsString(jsonEncode(install));
  //   await _terminalRepository.openFolder(path);
  //   yield state.copyWith(isLoading: false);
  // }
}
