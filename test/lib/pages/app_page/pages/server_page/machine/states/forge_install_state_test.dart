import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/forge_install_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_process_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/server_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockPreProcessCleanerState extends Mock
    implements PreProcessCleanerState {}

class MockServerRunState extends Mock implements ServerRunState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockForgeInstallerRepository extends Mock
    implements ForgeInstallerRepository {}

class MockConsoleRepository extends Mock implements ConsoleRepository {}

class MockJarArchiveInfo extends Mock implements JarArchiveInfo {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late PreProcessCleanerState preProcessCleanerState;
  late ServerRunState serverRunState;
  late ForgeInstallState state;
  late ForgeInstallerRepository repository;
  // Not used currently
  late ConsoleRepository consoleRepository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockForgeInstallerRepository();
    consoleRepository = ConsoleRepository(); //MockConsoleRepository();
    state = ForgeInstallState(
      machine,
      consoleRepository: consoleRepository,
      forgeInstallRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    preProcessCleanerState = MockPreProcessCleanerState();
    serverRunState = MockServerRunState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.preProcessCleanerState)
        .thenReturn(preProcessCleanerState);
    when(() => machine.serverRunState).thenReturn(serverRunState);
  });

  setUpAll(() {
    registerFallbackValue(MockJarArchiveInfo());
  });

  group('ServerRunState', () {
    group('start', () {
      test('transition to IdleState when machine.executable is null', () async {
        when(() => machine.executable).thenReturn(null);
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when machine.jarInfo is null', () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(null);
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(
          () => repository.installForge(
            javaExecutablePath: any(named: 'javaExecutablePath'),
            jarArchiveInfo: any(named: 'jarArchiveInfo'),
          ),
        ).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to preProcessCleanerState', () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(
          () => repository.installForge(
            javaExecutablePath: any(named: 'javaExecutablePath'),
            jarArchiveInfo: any(named: 'jarArchiveInfo'),
          ),
        ).thenAnswer((_) => Stream.fromIterable(['1', '2']));
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = preProcessCleanerState);
        verify(() => machine.state.start()).called(1);
      });
      test('transition to serverRunState', () async {
        when(() => machine.executable).thenReturn('java');
        when(() => machine.jarInfo).thenReturn(
          const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'server.jar',
          ),
        );
        when(
          () => repository.installForge(
            javaExecutablePath: any(named: 'javaExecutablePath'),
            jarArchiveInfo: any(named: 'jarArchiveInfo'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = serverRunState);
        verify(() => machine.state.start()).called(1);
      });
    });
  });
}
