import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_dangerous_ask_state.i18n.dart';

class JarDangerousAskState extends IState {
  JarDangerousAskState(
    ServerMachine machine,
  ) : super(machine: machine);

  @override
  Future<void> agree() async {
    machine.addLog(
      generateOneLineConsoleLine(
        jarDangerousAskAgree.i18n,
      ),
    );
    machine.state = machine.configurationLoaderState;
    machine.state.start();
  }

  @override
  void disagree() {
    machine.addLog(
      generateOneLineConsoleLine(
        jarDangerousAskDisagree.i18n,
      ),
    );
    machine.state = machine.idleState;
  }
}
