import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_ask_state.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';

class EulaAskState extends IState {
  EulaAskState(
    ServerMachine machine, {
    required this.eulaStageRepository,
  }) : super(machine: machine);
  final EulaStageRepository eulaStageRepository;

  @override
  Future<void> agree() async {
    machine.addLog(
      generateOneLineConsoleLine(
        eulaAskAgreeProgress.i18n,
      ),
    );
    try {
      final path = machine.projectPath;
      if (path != null) {
        await eulaStageRepository.writeEulaAt(folder: path);
        machine.addLog(
          generateOneLineConsoleLine(
            eulaAskAgreeSuccess.i18n,
          ),
        );
        machine.state = machine.jarAnalyzerState;
        machine.state.start();
        return;
      }
      machine.addLog(
        generateOneLineConsoleLine(
          eulaAskAgreeFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          eulaAskAgreeFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }

  @override
  void disagree() {
    machine.addLog(
      generateOneLineConsoleLine(
        eulaAskDisagree.i18n,
      ),
    );
    machine.state = machine.idleState;
  }
}
