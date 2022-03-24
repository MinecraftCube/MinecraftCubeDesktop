import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_duplicator_state.i18n.dart';

class JavaDuplicatorState extends IState {
  JavaDuplicatorState(
    ServerMachine machine, {
    required this.javaDuplicatorRepository,
  }) : super(machine: machine);
  final JavaDuplicatorRepository javaDuplicatorRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        javaDuplicatorProgress.i18n,
      ),
    );
    try {
      final properties = machine.properties;
      if (properties != null) {
        final executable = await javaDuplicatorRepository.cloneCubeJava(
          javaExecutablePath: properties.java,
        );
        machine.executable = executable;
        machine.addLog(
          generateOneLineConsoleLine(
            javaDuplicatorSuccess.i18n,
          ),
        );
        machine.state = machine.forgeInstallState;
        machine.state.start();
        return;
      }
      machine.addLog(
        generateOneLineConsoleLine(
          javaDuplicatorFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          javaDuplicatorFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
