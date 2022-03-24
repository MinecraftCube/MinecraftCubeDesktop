import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/post_duplicate_cleaner_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/post_process_cleaner_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockPostDuplicateCleanerState extends Mock
    implements PostDuplicateCleanerState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockProcessCleanerRepository extends Mock
    implements ProcessCleanerRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late PostDuplicateCleanerState postDuplicateCleanerState;
  late PostProcessCleanerState state;
  late ProcessCleanerRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockProcessCleanerRepository();
    state = PostProcessCleanerState(
      machine,
      processCleanerRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    postDuplicateCleanerState = MockPostDuplicateCleanerState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.postDuplicateCleanerState)
        .thenReturn(postDuplicateCleanerState);
  });

  group('PostProcessCleanerState', () {
    group('start', () {
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.killJavaProcesses()).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to postDuplicateCleanerState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => repository.killJavaProcesses()).thenAnswer((_) async => {});
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = postDuplicateCleanerState);
        verify(() => machine.state.start()).called(1);
      });
    });
  });
}
