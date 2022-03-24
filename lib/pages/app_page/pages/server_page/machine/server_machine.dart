import 'dart:async';

import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/configuration_loader_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_ask_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_stage_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/forge_install_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_analyzer_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_dangerous_ask_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_duplicator_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_printer_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/post_duplicate_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/post_process_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_duplicate_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_process_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/server_state.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';
import 'package:server_repository/server_repository.dart';

import 'package:meta/meta.dart';

class ServerMachine {
  ServerMachine({
    required ProcessCleanerRepository processCleanerRepository,
    required DuplicateCleanerRepository duplicateCleanerRepository,
    required EulaStageRepository eulaStageRepository,
    required JarAnalyzerRepository jarAnalyzerRepository,
    required CubePropertiesRepository cubePropertiesRepository,
    required JavaPrinterRepository javaPrinterRepository,
    required JavaDuplicatorRepository javaDuplicatorRepository,
    required ForgeInstallerRepository forgeInstallerRepository,
    required ServerRepository serverRepository,
    required ConsoleRepository consoleRepository,
  })  : _logController = StreamController<Iterable<ConsoleLine>>(),
        _stateController = StreamController<IState>(),
        _stableController = StreamController<bool>() {
    idleState = IdleState(machine: this);
    _innerState = idleState;
    preProcessCleanerState = PreProcessCleanerState(
      this,
      processCleanerRepository: processCleanerRepository,
    );
    preDuplicateCleanerState = PreDuplicateCleanerState(
      this,
      duplicateCleanerRepository: duplicateCleanerRepository,
    );
    eulaStageState =
        EulaStageState(this, eulaStageRepository: eulaStageRepository);
    eulaAskState = EulaAskState(this, eulaStageRepository: eulaStageRepository);

    jarAnalyzerState =
        JarAnalyzerState(this, jarAnalyzerRepository: jarAnalyzerRepository);
    jarDangerousAskState = JarDangerousAskState(this);
    configurationLoaderState = ConfigurationLoaderState(
      this,
      cubePropertiesRepository: cubePropertiesRepository,
    );
    javaPrinterState =
        JavaPrinterState(this, javaPrinterRepository: javaPrinterRepository);
    javaDuplicatorState = JavaDuplicatorState(
      this,
      javaDuplicatorRepository: javaDuplicatorRepository,
    );
    forgeInstallState = ForgeInstallState(
      this,
      consoleRepository: consoleRepository,
      forgeInstallRepository: forgeInstallerRepository,
    );
    serverRunState = ServerRunState(
      this,
      consoleRepository: consoleRepository,
      serverRepository: serverRepository,
    );
    postProcessCleanerState = PostProcessCleanerState(
      this,
      processCleanerRepository: processCleanerRepository,
    );
    postDuplicateCleanerState = PostDuplicateCleanerState(
      this,
      duplicateCleanerRepository: duplicateCleanerRepository,
    );
    _stableController.sink.add(false);
  }
  // final List<ConsoleLine> _logs;
  final StreamController<Iterable<ConsoleLine>> _logController;
  final StreamController<IState> _stateController;
  final StreamController<bool> _stableController;

  late IState _innerState;

  /// **DO NOT** use this unless in the state.
  set state(IState newState) {
    _innerState = newState;
    _stateController.sink.add(newState);
  }

  IState get state => _innerState;

  get isIdle => _innerState is IdleState;

  // Untestable...
  set stable(bool value) {
    _stableController.sink.add(value);
  }

  /// **DO NOT** use this unless in the state.
  late final IdleState idleState;

  /// **DO NOT** use this unless in the state.
  late final PreProcessCleanerState preProcessCleanerState;

  /// **DO NOT** use this unless in the state.
  late final PreDuplicateCleanerState preDuplicateCleanerState;

  /// **DO NOT** use this unless in the state.
  late final EulaStageState eulaStageState;

  /// **DO NOT** use this unless in the state.
  late final EulaAskState eulaAskState;

  /// **DO NOT** use this unless in the state.
  late final JarAnalyzerState jarAnalyzerState;

  /// **DO NOT** use this unless in the state.
  late final JarDangerousAskState jarDangerousAskState;

  /// **DO NOT** use this unless in the state.
  late final ConfigurationLoaderState configurationLoaderState;

  /// **DO NOT** use this unless in the state.
  late final JavaPrinterState javaPrinterState;

  /// **DO NOT** use this unless in the state.
  late final JavaDuplicatorState javaDuplicatorState;

  /// **DO NOT** use this unless in the state.
  late final ForgeInstallState forgeInstallState;

  /// **DO NOT** use this unless in the state.
  late final ServerRunState serverRunState;

  /// **DO NOT** use this unless in the state.
  late final PostProcessCleanerState postProcessCleanerState;

  /// **DO NOT** use this unless in the state.
  late final PostDuplicateCleanerState postDuplicateCleanerState;

  /// **DO NOT** use this unless in the state.
  String? projectPath;

  /// **DO NOT** use this unless in the state.
  JarArchiveInfo? jarInfo;

  /// **DO NOT** use this unless in the state.
  CubeProperties? properties;

  /// **DO NOT** use this unless in the state.
  String? executable;

  /// Add [Iterable]<[ConsoleLine]> to log stream
  ///
  /// **DO NOT** use this unless in the state.
  void addLog(Iterable<ConsoleLine> logs) {
    // _logs.addAll(logs);
    _logController.sink.add(logs);
  }

  FutureOr<void> agree() {
    return state.agree();
  }

  FutureOr<void> disagree() {
    return state.disagree();
  }

  // Not implement
  FutureOr<void> stop() {
    return state.stop();
  }

  void start(final String projectPath) {
    this.projectPath = projectPath;
    state.start();
  }

  void input(final String command) {
    state.input(command);
  }

  @mustCallSuper
  Future<void> dispose() async {
    await _logController.close();
    await _stateController.close();
    await _stableController.close();
  }

  /// The stream of [Iterable]<[ConsoleLine]>.
  ///
  /// Should be readonly
  Stream<Iterable<ConsoleLine>> get logStream => _logController.stream;

  /// The Stream of [IState].
  ///
  /// Should be readonly, DO NOT call any method on [IState]
  Stream<IState> get stateStream => _stateController.stream;

  /// The Stream of [bool].
  ///
  /// Should be readonly, DO NOT call any method on [stable]
  Stream<bool> get stableStream => _stableController.stream;
}

// processClean
//  -duplicateClean
//   -eulaStage
//    -jarAnalyzer
//     -configurationLoader
//      -javaPrinter
//       -javaDuplicator
//        -forgeInstaller
//         -serverBloc
//          -processClean
//           -duplicateClean
