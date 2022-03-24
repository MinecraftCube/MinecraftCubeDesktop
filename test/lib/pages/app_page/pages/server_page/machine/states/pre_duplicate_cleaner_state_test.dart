import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_stage_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_duplicate_cleaner_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockEulaStageState extends Mock implements EulaStageState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockDuplicateCleanerRepository extends Mock
    implements DuplicateCleanerRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late EulaStageState eulaStageState;
  late PreDuplicateCleanerState state;
  late DuplicateCleanerRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockDuplicateCleanerRepository();
    state = PreDuplicateCleanerState(
      machine,
      duplicateCleanerRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    eulaStageState = MockEulaStageState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.eulaStageState).thenReturn(eulaStageState);
  });

  group('PreDuplicateCleanerState', () {
    group('start', () {
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.deleteCubeJava()).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to eulaStageState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.deleteCubeJava()).thenAnswer((_) async => {});
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = eulaStageState);
      });
    });
  });
}
