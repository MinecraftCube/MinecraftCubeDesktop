import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_process_cleaner_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockPreProcessCleanerState extends Mock
    implements PreProcessCleanerState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockCubePropertiesRepository extends Mock
    implements CubePropertiesRepository {}

void main() {
  late IState machineState;
  late PreProcessCleanerState preProcessCleanerState;
  late IdleState state;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    state = IdleState(
      machine: machine,
    );
    machineState = MockState();
    preProcessCleanerState = MockPreProcessCleanerState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.preProcessCleanerState)
        .thenReturn(preProcessCleanerState);
  });

  group('IdleState', () {
    group('start', () {
      test('transition to PreProcessCleanerState', () async {
        when(() => machine.projectPath).thenReturn(null);
        expect(() => state.start(), returnsNormally);
        verifyNever(() => machine.addLog(any()));
        verify(() => machine.state = preProcessCleanerState);
      });
    });
  });
}
