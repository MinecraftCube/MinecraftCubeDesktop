import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_ask_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_stage_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_analyzer_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockJarAnalyzerState extends Mock implements JarAnalyzerState {}

class MockEulaAskState extends Mock implements EulaAskState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockEulaStageRepository extends Mock implements EulaStageRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late EulaAskState eulaAskState;
  late JarAnalyzerState jarAnalyzerState;
  late EulaStageState state;
  late EulaStageRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockEulaStageRepository();
    state = EulaStageState(
      machine,
      eulaStageRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    jarAnalyzerState = MockJarAnalyzerState();
    eulaAskState = MockEulaAskState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.jarAnalyzerState).thenReturn(jarAnalyzerState);
    when(() => machine.eulaAskState).thenReturn(eulaAskState);
  });

  group('EulaStageState', () {
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
        when(() => repository.checkEulaAt(folder: any(named: 'folder')))
            .thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to jarAnalyzerState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.checkEulaAt(folder: any(named: 'folder')))
            .thenAnswer((_) async => true);
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = jarAnalyzerState);
        verify(() => machine.state.start()).called(1);
      });
      test('transition to eulaAskState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.checkEulaAt(folder: any(named: 'folder')))
            .thenAnswer((_) async => false);
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = eulaAskState);
        // verify(() => machine.state.start()).called(1);
      });
    });
  });
}
