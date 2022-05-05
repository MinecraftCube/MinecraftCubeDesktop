import 'dart:async';

import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';
import 'package:server_configuration_repository/server_configuration_repository.dart';
import 'package:server_repository/server_repository.dart';

class MockProcessCleanerRepository extends Mock
    implements ProcessCleanerRepository {}

class MockDuplicateCleanerRepository extends Mock
    implements DuplicateCleanerRepository {}

class MockEulaStageRepository extends Mock implements EulaStageRepository {}

class MockJarAnalyzerRepository extends Mock implements JarAnalyzerRepository {}

class MockCubePropertiesRepository extends Mock
    implements CubePropertiesRepository {}

class MockJavaPrinterRepository extends Mock implements JavaPrinterRepository {}

class MockJavaDuplicatorRepository extends Mock
    implements JavaDuplicatorRepository {}

class MockForgeInstallerRepository extends Mock
    implements ForgeInstallerRepository {}

class MockServerRepository extends Mock implements ServerRepository {}

class MockServerConfigurationRepository extends Mock
    implements ServerConfigurationRepository {}

class MockConsoleRepository extends Mock implements ConsoleRepository {}

class MockCubeProperties extends Mock implements CubeProperties {}

class MockFakeState extends Mock implements IState {}

void main() {
  late ProcessCleanerRepository processCleanerRepository;
  late DuplicateCleanerRepository duplicateCleanerRepository;
  late EulaStageRepository eulaStageRepository;
  late JarAnalyzerRepository jarAnalyzerRepository;
  late CubePropertiesRepository cubePropertiesRepository;
  late JavaPrinterRepository javaPrinterRepository;
  late JavaDuplicatorRepository javaDuplicatorRepository;
  late ForgeInstallerRepository forgeInstallerRepository;
  late ServerConfigurationRepository serverConfigurationRepository;
  late ServerRepository serverRepository;
  late ConsoleRepository consoleRepository;
  setUp(() {
    processCleanerRepository = MockProcessCleanerRepository();
    duplicateCleanerRepository = MockDuplicateCleanerRepository();
    eulaStageRepository = MockEulaStageRepository();
    jarAnalyzerRepository = MockJarAnalyzerRepository();
    cubePropertiesRepository = MockCubePropertiesRepository();
    javaPrinterRepository = MockJavaPrinterRepository();
    javaDuplicatorRepository = MockJavaDuplicatorRepository();
    forgeInstallerRepository = MockForgeInstallerRepository();
    serverConfigurationRepository = MockServerConfigurationRepository();
    serverRepository = MockServerRepository();
    consoleRepository = MockConsoleRepository();
    when(() => processCleanerRepository.killJavaProcesses())
        .thenAnswer((_) async => {});
    when(() => duplicateCleanerRepository.deleteCubeJava())
        .thenAnswer((_) async => {});
    when(() => eulaStageRepository.checkEulaAt(folder: any(named: 'folder')))
        .thenAnswer((_) async => true);
    when(() => eulaStageRepository.writeEulaAt(folder: any(named: 'folder')))
        .thenAnswer((_) async => {});
    when(
      () => jarAnalyzerRepository.analyzeDirectory(
        directory: any(named: 'directory'),
      ),
    ).thenAnswer(
      (_) async =>
          const JarArchiveInfo(type: JarType.vanilla, executable: 'nope.jar'),
    );
    when(
      () => serverConfigurationRepository.getConfiguration(
        directory: any(named: 'directory'),
      ),
    ).thenAnswer((_) async => const ServerConfiguration());
    when(
      () => cubePropertiesRepository.getCubeProperties(
        directory: any(named: 'directory'),
      ),
    ).thenAnswer((_) async => const CubeProperties());
    when(
      () => javaPrinterRepository.getVersionInfo(
        javaExecutablePath: any(named: 'javaExecutablePath'),
      ),
    ).thenAnswer((_) async => 'version info');
    when(
      () => javaDuplicatorRepository.cloneCubeJava(
        javaExecutablePath: any(named: 'javaExecutablePath'),
      ),
    ).thenAnswer((_) async => 'newJava');
    when(
      () => forgeInstallerRepository.installForge(
        javaExecutablePath: any(named: 'javaExecutablePath'),
        jarArchiveInfo: const JarArchiveInfo(
          type: JarType.vanilla,
          executable: 'nope.jar',
        ),
      ),
    ).thenAnswer((_) => Stream.fromIterable(['elements']));
    when(
      () => serverRepository.startServer(
        executable: any(named: 'executable'),
        javaExecutable: any(named: 'javaExecutable'),
        cubeProperties: any(named: 'cubeProperties'),
      ),
    ).thenAnswer((_) => Stream.fromIterable([]));
    when(() => serverRepository.inputCommand(command: any(named: 'command')))
        .thenAnswer((_) => Stream.fromIterable([]));
    when(() => consoleRepository.parse(any())).thenReturn(Iterable.generate(0));
  });
  setUpAll(() {
    registerFallbackValue(MockCubeProperties());
  });
  group('ServerMachine', () {
    group('consturcotr', () {
      test('all states init correctly', () {
        final machine = ServerMachine(
          processCleanerRepository: processCleanerRepository,
          duplicateCleanerRepository: duplicateCleanerRepository,
          eulaStageRepository: eulaStageRepository,
          jarAnalyzerRepository: jarAnalyzerRepository,
          cubePropertiesRepository: cubePropertiesRepository,
          javaPrinterRepository: javaPrinterRepository,
          javaDuplicatorRepository: javaDuplicatorRepository,
          forgeInstallerRepository: forgeInstallerRepository,
          serverRepository: serverRepository,
          consoleRepository: consoleRepository,
          serverConfigurationRepository: serverConfigurationRepository,
        );
        expect(machine.state, isA<IdleState>());
        expect(machine.idleState, isNotNull);
        expect(machine.preProcessCleanerState, isNotNull);
        expect(machine.preDuplicateCleanerState, isNotNull);
        expect(machine.eulaStageState, isNotNull);
        expect(machine.eulaAskState, isNotNull);
        expect(machine.jarAnalyzerState, isNotNull);
        expect(machine.jarDangerousAskState, isNotNull);
        expect(machine.configurationLoaderState, isNotNull);
        expect(machine.javaPrinterState, isNotNull);
        expect(machine.javaDuplicatorState, isNotNull);
        expect(machine.forgeInstallState, isNotNull);
        expect(machine.serverRunState, isNotNull);
        expect(machine.postProcessCleanerState, isNotNull);
        expect(machine.postDuplicateCleanerState, isNotNull);
      });
    });

    group('logStream', () {
      test('play with addLog', () async {
        final machine = ServerMachine(
          processCleanerRepository: processCleanerRepository,
          duplicateCleanerRepository: duplicateCleanerRepository,
          eulaStageRepository: eulaStageRepository,
          jarAnalyzerRepository: jarAnalyzerRepository,
          cubePropertiesRepository: cubePropertiesRepository,
          javaPrinterRepository: javaPrinterRepository,
          javaDuplicatorRepository: javaDuplicatorRepository,
          forgeInstallerRepository: forgeInstallerRepository,
          serverRepository: serverRepository,
          consoleRepository: consoleRepository,
          serverConfigurationRepository: serverConfigurationRepository,
        );

        machine.logStream.listen(
          expectAsync1(
            (log) {
              expect(log, isA<Iterable<ConsoleLine>>());
            },
            count: 1,
          ),
        );
        machine.addLog([const ConsoleLine(texts: [])]);
      });
    });

    group('stateStream', () {
      test('play with state', () async {
        final machine = ServerMachine(
          processCleanerRepository: processCleanerRepository,
          duplicateCleanerRepository: duplicateCleanerRepository,
          eulaStageRepository: eulaStageRepository,
          jarAnalyzerRepository: jarAnalyzerRepository,
          cubePropertiesRepository: cubePropertiesRepository,
          javaPrinterRepository: javaPrinterRepository,
          javaDuplicatorRepository: javaDuplicatorRepository,
          forgeInstallerRepository: forgeInstallerRepository,
          serverRepository: serverRepository,
          consoleRepository: consoleRepository,
          serverConfigurationRepository: serverConfigurationRepository,
        );

        final fakeState = MockFakeState();

        machine.stateStream.listen(
          expectAsync1(
            (state) {
              expect(state, fakeState);
            },
            count: 1,
          ),
        );
        machine.state = fakeState;
      });
    });

    group('stateStream', () {
      test('play with state', () async {
        final machine = ServerMachine(
          processCleanerRepository: processCleanerRepository,
          duplicateCleanerRepository: duplicateCleanerRepository,
          eulaStageRepository: eulaStageRepository,
          jarAnalyzerRepository: jarAnalyzerRepository,
          cubePropertiesRepository: cubePropertiesRepository,
          javaPrinterRepository: javaPrinterRepository,
          javaDuplicatorRepository: javaDuplicatorRepository,
          forgeInstallerRepository: forgeInstallerRepository,
          serverRepository: serverRepository,
          consoleRepository: consoleRepository,
          serverConfigurationRepository: serverConfigurationRepository,
        );

        when(() => processCleanerRepository.killJavaProcesses())
            .thenThrow(Exception());

        machine.start('anyPath');
        expect(machine.projectPath, 'anyPath');
      });
    });

    group('stableStream', () {
      test('play with stable', () async {
        final machine = ServerMachine(
          processCleanerRepository: processCleanerRepository,
          duplicateCleanerRepository: duplicateCleanerRepository,
          eulaStageRepository: eulaStageRepository,
          jarAnalyzerRepository: jarAnalyzerRepository,
          cubePropertiesRepository: cubePropertiesRepository,
          javaPrinterRepository: javaPrinterRepository,
          javaDuplicatorRepository: javaDuplicatorRepository,
          forgeInstallerRepository: forgeInstallerRepository,
          serverRepository: serverRepository,
          consoleRepository: consoleRepository,
          serverConfigurationRepository: serverConfigurationRepository,
        );

        expect(machine.stableStream, emitsInOrder([false, false, true]));

        machine.stable = false;
        machine.stable = true;
      });
    });
  });
}
