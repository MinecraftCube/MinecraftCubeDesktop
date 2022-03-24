import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';

class IdleState extends IState {
  IdleState({required ServerMachine machine}) : super(machine: machine);

  @override
  void start() {
    machine.state = machine.preProcessCleanerState;
    machine.state.start();
  }
}
