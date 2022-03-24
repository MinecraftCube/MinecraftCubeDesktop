import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/configuration_loader_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_dangerous_ask_state.dart';
import 'package:mocktail/mocktail.dart';

class MockState extends Mock implements IState {}

class MockIdleState extends Mock implements IdleState {}

class MockConfigurationLoaderState extends Mock
    implements ConfigurationLoaderState {}

class MockServerMachine extends Mock implements ServerMachine {}

void main() {
  late IState machineState;
  late IdleState idleState;
  late ConfigurationLoaderState configurationLoaderState;
  late JarDangerousAskState state;
  late ServerMachine machine;

  setUp(() {
    machine = MockServerMachine();
    state = JarDangerousAskState(
      machine,
    );
    machineState = MockState();
    idleState = MockIdleState();
    configurationLoaderState = MockConfigurationLoaderState();
    when(() => machine.state).thenReturn(machineState);
    when(() => machine.idleState).thenReturn(idleState);
    when(() => machine.configurationLoaderState)
        .thenReturn(configurationLoaderState);
  });

  group('JarDangerousAskState', () {
    group('agree', () {
      test('transition to configurationLoaderState', () async {
        when(() => machine.projectPath).thenReturn('');
        await expectLater(state.agree(), completes);
        verify(() => machine.addLog(any())).called(1);
        verify(() => machine.state = configurationLoaderState);
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
