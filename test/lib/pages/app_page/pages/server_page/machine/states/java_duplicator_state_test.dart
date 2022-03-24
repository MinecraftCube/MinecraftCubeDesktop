import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/forge_install_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_duplicator_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockForgeInstallState extends Mock implements ForgeInstallState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockJavaDuplicatorRepository extends Mock
    implements JavaDuplicatorRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late ForgeInstallState forgeInstallState;
  late JavaDuplicatorState state;
  late JavaDuplicatorRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockJavaDuplicatorRepository();
    state = JavaDuplicatorState(
      machine,
      javaDuplicatorRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    forgeInstallState = MockForgeInstallState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.forgeInstallState).thenReturn(forgeInstallState);
  });

  group('JavaDuplicatorState', () {
    group('start', () {
      test('transition to IdleState when machine.properties is null', () async {
        when(() => machine.properties).thenReturn(null);
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.properties).thenReturn(const CubeProperties());
        when(
          () => repository.cloneCubeJava(
            javaExecutablePath: any(named: 'javaExecutablePath'),
          ),
        ).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to forgeInstallState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => machine.properties).thenReturn(const CubeProperties());
        when(
          () => repository.cloneCubeJava(
            javaExecutablePath: any(named: 'javaExecutablePath'),
          ),
        ).thenAnswer((_) async => '');
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = forgeInstallState);
        verify(() => machine.state.start()).called(1);
      });
    });
  });
}
