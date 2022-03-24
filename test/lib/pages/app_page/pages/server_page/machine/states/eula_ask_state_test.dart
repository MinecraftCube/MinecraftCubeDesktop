import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_ask_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_analyzer_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockJarAnalyzerState extends Mock implements JarAnalyzerState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockEulaStageRepository extends Mock implements EulaStageRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late JarAnalyzerState jarAnalyzerState;
  late EulaAskState state;
  late EulaStageRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockEulaStageRepository();
    state = EulaAskState(
      machine,
      eulaStageRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    jarAnalyzerState = MockJarAnalyzerState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.jarAnalyzerState).thenReturn(jarAnalyzerState);
  });

  group('EulaAskState', () {
    group('agree', () {
      test('transition to IdleState when projectPath is null', () async {
        when(() => machine.projectPath).thenReturn(null);
        await expectLater(state.agree(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.writeEulaAt(folder: any(named: 'folder')))
            .thenThrow(Exception());
        await expectLater(state.agree(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to jarAnalyzerState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.writeEulaAt(folder: any(named: 'folder')))
            .thenAnswer((_) async => {});
        await expectLater(state.agree(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = jarAnalyzerState);
        verify(() => machine.state.start()).called(1);
      });
    });
    group('disagree', () {
      test('transition to IdleState', () async {
        await expectLater(() => state.disagree(), returnsNormally);
        verify(() => machine.addLog(any())).called(1);
        verify(() => machine.state = idleState);
      });
    });
  });
}
