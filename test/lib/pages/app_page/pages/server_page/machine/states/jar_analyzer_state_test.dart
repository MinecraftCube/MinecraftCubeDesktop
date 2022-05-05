import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/configuration_loader_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_analyzer_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_dangerous_ask_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_configuration_repository/server_configuration_repository.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockConfigurationLoaderState extends Mock
    implements ConfigurationLoaderState {}

class MockJarDangerousAskState extends Mock implements JarDangerousAskState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockJarAnalyzerRepository extends Mock implements JarAnalyzerRepository {}

class MockServerConfigurationRepository extends Mock
    implements ServerConfigurationRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late JarDangerousAskState jarDangerousAskState;
  late ConfigurationLoaderState configurationLoaderState;
  late JarAnalyzerState state;
  late JarAnalyzerRepository repository;
  late ServerConfigurationRepository serverConfigurationRepository;
  late ServerMachine machine;

  setUpAll(() {
    registerFallbackValue(const ServerConfiguration());
  });

  setUp(() {
    machine = MockServerMachine();
    repository = MockJarAnalyzerRepository();
    serverConfigurationRepository = MockServerConfigurationRepository();
    state = JarAnalyzerState(
      machine,
      jarAnalyzerRepository: repository,
      serverConfigurationRepository: serverConfigurationRepository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    configurationLoaderState = MockConfigurationLoaderState();
    jarDangerousAskState = MockJarDangerousAskState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.configurationLoaderState)
        .thenReturn(configurationLoaderState);
    when(() => machine.jarDangerousAskState).thenReturn(jarDangerousAskState);
  });

  group('JarAnalyzerState', () {
    group('start', () {
      test('transition to IdleState when projectPath is null', () async {
        when(() => machine.projectPath).thenReturn(null);
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.projectPath).thenReturn('');
        when(
          () => repository.analyzeDirectory(directory: any(named: 'directory')),
        ).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when repository return null jarInfo',
          () async {
        when(() => machine.projectPath).thenReturn('');
        when(
          () => repository.analyzeDirectory(directory: any(named: 'directory')),
        ).thenAnswer((_) async => null);
        when(
          () => serverConfigurationRepository.getConfiguration(
            directory: any(named: 'directory'),
          ),
        ).thenAnswer(
          (_) async => const ServerConfiguration(isAgreeDangerous: false),
        );
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to configurationLoaderState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(
          () => repository.analyzeDirectory(directory: any(named: 'directory')),
        ).thenAnswer(
          (_) async =>
              const JarArchiveInfo(type: JarType.vanilla, executable: ''),
        );
        when(
          () => serverConfigurationRepository.getConfiguration(
            directory: any(named: 'directory'),
          ),
        ).thenAnswer(
          (_) async => const ServerConfiguration(isAgreeDangerous: false),
        );
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = configurationLoaderState);
        verify(
          () => machine.jarInfo =
              const JarArchiveInfo(type: JarType.vanilla, executable: ''),
        );
        verify(() => machine.state.start()).called(1);
      });
      test('transition to jarDangerousAskState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(
          () => repository.analyzeDirectory(directory: any(named: 'directory')),
        ).thenAnswer(
          (_) async =>
              const JarArchiveInfo(type: JarType.unknown, executable: ''),
        );
        when(
          () => serverConfigurationRepository.getConfiguration(
            directory: any(named: 'directory'),
          ),
        ).thenAnswer(
          (_) async => const ServerConfiguration(isAgreeDangerous: false),
        );
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = jarDangerousAskState);
        verify(
          () => machine.jarInfo =
              const JarArchiveInfo(type: JarType.unknown, executable: ''),
        );
        // verify(() => machine.state.start()).called(1);
      });
      test(
          'skip jarDangerousAskState when serverConfigurationRepository had agreed',
          () async {
        when(() => machine.projectPath).thenReturn('');
        when(
          () => repository.analyzeDirectory(directory: any(named: 'directory')),
        ).thenAnswer(
          (_) async =>
              const JarArchiveInfo(type: JarType.unknown, executable: ''),
        );
        when(
          () => serverConfigurationRepository.getConfiguration(
            directory: any(named: 'directory'),
          ),
        ).thenAnswer(
          (_) async => const ServerConfiguration(isAgreeDangerous: true),
        );
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = configurationLoaderState);
        verify(
          () => machine.jarInfo =
              const JarArchiveInfo(type: JarType.unknown, executable: ''),
        );
        // verify(() => machine.state.start()).called(1);
      });
    });
  });
}
