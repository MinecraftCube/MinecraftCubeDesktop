import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/pre_duplicate_cleaner_state.i18n.dart';

class PostDuplicateCleanerState extends IState {
  PostDuplicateCleanerState(
    ServerMachine machine, {
    required this.duplicateCleanerRepository,
  }) : super(machine: machine);
  final DuplicateCleanerRepository duplicateCleanerRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        preDuplicateCleanerProgress.i18n,
      ),
    );
    try {
      await duplicateCleanerRepository.deleteCubeJava();

      machine.addLog(
        generateOneLineConsoleLine(
          preDuplicateCleanerSuccess.i18n,
        ),
      );
      machine.state = machine.idleState;
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          preDuplicateCleanerFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
