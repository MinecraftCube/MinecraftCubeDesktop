import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/post_process_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/server_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_repository/server_repository.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockPostProcessCleanerState extends Mock
    implements PostProcessCleanerState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockServerRepository extends Mock implements ServerRepository {}

// class MockConsoleRepository extends Mock implements ConsoleRepository {}

class MockJarArchiveInfo extends Mock implements JarArchiveInfo {}

class MockCubeProperties extends Mock implements CubeProperties {}

void main() {
  late IState machineState;
  late PostProcessCleanerState postProcessCleanerState;
  late ServerRunState state;
  late ServerRepository repository;
  // Not used currently
  late ConsoleRepository consoleRepository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockServerRepository();
    consoleRepository = ConsoleRepository();
    state = ServerRunState(
      machine,
      consoleRepository: consoleRepository,
      serverRepository: repository,
    );
    machineState = MockState();
    postProcessCleanerState = MockPostProcessCleanerState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.postProcessCleanerState)
        .thenReturn(postProcessCleanerState);
  });

  setUpAll(() {
    registerFallbackValue(MockJarArchiveInfo());
    registerFallbackValue(MockCubeProperties());
  });

  group('PostProcessCleanerState', () {
    group('start', () {
      test(
          'transition to PostProcessCleanerState when machine.executable is null',
          () async {
        when(() => machine.executable).thenReturn(null);
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(() => machine.properties).thenReturn(const CubeProperties());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = postProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
      test('transition to PostProcessCleanerState when machine.jarInfo is null',
          () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(null);
        when(() => machine.properties).thenReturn(const CubeProperties());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = postProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
      test(
          'transition to PostProcessCleanerState when machine.properties is null',
          () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(() => machine.properties).thenReturn(null);
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = postProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
      test(
          'transition to PostProcessCleanerState when repository throws exception',
          () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(() => machine.properties).thenReturn(const CubeProperties());
        when(
          () => repository.startServer(
            executable: any(named: 'executable'),
            cubeProperties: any(named: 'cubeProperties'),
            javaExecutable: any(named: 'javaExecutable'),
          ),
        ).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = postProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
      test('transition to unstable', () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(() => machine.properties).thenReturn(const CubeProperties());
        when(
          () => repository.startServer(
            executable: any(named: 'executable'),
            cubeProperties: any(named: 'cubeProperties'),
            javaExecutable: any(named: 'javaExecutable'),
          ),
        ).thenAnswer((_) => Stream.fromIterable(['ABC']));
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(3);
        verify(() => machine.stable = false).called(1);
        verify(() => machine.state = postProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
      test('transition to postProcessCleanerState', () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(() => machine.properties).thenReturn(const CubeProperties());

        when(
          () => repository.startServer(
            executable: any(named: 'executable'),
            cubeProperties: any(named: 'cubeProperties'),
            javaExecutable: any(named: 'javaExecutable'),
          ),
        ).thenAnswer((_) => Stream.fromIterable(['ABC', 'For help']));
        await expectLater(state.start(), completes);
        verify(() => machine.stable = true).called(1);
        verify(() => machine.stable = false).called(1);
        verify(() => machine.addLog(any())).called(4);
        verify(() => machine.state = postProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
    });
  });
}
