import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_duplicator_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_printer_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockJavaDuplicatorState extends Mock implements JavaDuplicatorState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockJavaPrinterRepository extends Mock implements JavaPrinterRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late JavaDuplicatorState javaDuplicatorState;
  late JavaPrinterState state;
  late JavaPrinterRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockJavaPrinterRepository();
    state = JavaPrinterState(
      machine,
      javaPrinterRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    javaDuplicatorState = MockJavaDuplicatorState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.javaDuplicatorState).thenReturn(javaDuplicatorState);
  });

  group('JavaPrinterState', () {
    group('start', () {
      test('transition to IdleState when machine.properties is null', () async {
        when(() => machine.properties).thenReturn(null);
        when(
          () => repository.getVersionInfo(
            javaExecutablePath: any(named: 'javaExecutablePath'),
          ),
        ).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to IdleState when repository throws exception',
          () async {
        when(() => machine.properties).thenReturn(const CubeProperties());
        when(
          () => repository.getVersionInfo(
            javaExecutablePath: any(named: 'javaExecutablePath'),
          ),
        ).thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to javaDuplicatorState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(() => machine.properties).thenReturn(const CubeProperties());
        when(
          () => repository.getVersionInfo(
            javaExecutablePath: any(named: 'javaExecutablePath'),
          ),
        ).thenAnswer((_) async => '');
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(3);
        verify(() => machine.state = javaDuplicatorState);
        verify(() => machine.state.start()).called(1);
      });
    });
  });
}
