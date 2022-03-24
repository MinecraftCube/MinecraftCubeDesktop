import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_process_cleaner_state.i18n.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';

class PreProcessCleanerState extends IState {
  PreProcessCleanerState(
    ServerMachine machine, {
    required this.processCleanerRepository,
  }) : super(machine: machine);
  final ProcessCleanerRepository processCleanerRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        preProcessCleanerProgress.i18n,
      ),
    );
    try {
      await processCleanerRepository.killJavaProcesses();
      machine.addLog(
        generateOneLineConsoleLine(
          preProcessCleanerSuccess.i18n,
        ),
      );
      machine.state = machine.preDuplicateCleanerState;
      machine.state.start();
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          preProcessCleanerFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
