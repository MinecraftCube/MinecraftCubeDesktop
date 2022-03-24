import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_stage_state.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';

class EulaStageState extends IState {
  EulaStageState(
    ServerMachine machine, {
    required this.eulaStageRepository,
  }) : super(machine: machine);
  final EulaStageRepository eulaStageRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        eulaStageProgress.i18n,
      ),
    );
    try {
      final path = machine.projectPath;
      if (path != null) {
        final checked = await eulaStageRepository.checkEulaAt(folder: path);
        if (checked) {
          machine.addLog(
            generateOneLineConsoleLine(
              eulaStageSuccess.i18n,
            ),
          );
          machine.state = machine.jarAnalyzerState;
          machine.state.start();
          return;
        }
        machine.addLog(
          generateOneLineConsoleLine(
            eulaStageFailure.i18n,
          ),
        );
        machine.state = machine.eulaAskState;
        machine.state.start();
        return;
      }
      machine.addLog(
        generateOneLineConsoleLine(
          eulaStageFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
      machine.state.start();
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          eulaStageFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
