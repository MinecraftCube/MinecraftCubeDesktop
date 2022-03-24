import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/configuration_loader_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_printer_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockJavaPrinterState extends Mock implements JavaPrinterState {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockCubePropertiesRepository extends Mock
    implements CubePropertiesRepository {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late JavaPrinterState javaPrinterState;
  late ConfigurationLoaderState state;
  late CubePropertiesRepository repository;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    repository = MockCubePropertiesRepository();
    state = ConfigurationLoaderState(
      machine,
      cubePropertiesRepository: repository,
    );
    machineState = MockState();
    idleState = MockIdleState();
    javaPrinterState = MockJavaPrinterState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.javaPrinterState).thenReturn(javaPrinterState);
  });

  group('ConfigurationLoaderState', () {
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
        when(() => repository.getProperties(directory: any(named: 'directory')))
            .thenThrow(Exception());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = idleState);
      });
      test('transition to javaPrinterState', () async {
        when(() => machine.projectPath).thenReturn('');
        when(
          () => repository.getCubeProperties(
            directory: any(named: 'directory'),
          ),
        ).thenAnswer((_) async => const CubeProperties());
        await expectLater(state.start(), completes);
        verify(() => machine.addLog(any())).called(2);
        verify(() => machine.state = javaPrinterState);
        verify(() => machine.properties = const CubeProperties());
        verify(() => machine.state.start()).called(1);
      });
    });
  });
}
