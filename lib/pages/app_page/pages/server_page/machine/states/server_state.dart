import 'package:console_repository/console_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/server_state.i18n.dart';
import 'package:server_repository/server_repository.dart';

class ServerRunState extends IState {
  ServerRunState(
    ServerMachine machine, {
    required this.serverRepository,
    required this.consoleRepository,
  }) : super(machine: machine);
  final ServerRepository serverRepository;
  final ConsoleRepository consoleRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        serverStateProgress.i18n,
      ),
    );
    try {
      final executable = machine.executable;
      final jarInfo = machine.jarInfo;
      final properties = machine.properties;
      final projectPath = machine.projectPath;
      if (properties != null &&
          jarInfo != null &&
          executable != null &&
          projectPath != null) {
        await for (final log in serverRepository.startServer(
          jarArchiveInfo: jarInfo,
          cubeProperties: properties,
          javaExecutable: executable,
          projectPath: projectPath,
        )) {
          if (log.toLowerCase().contains('for help')) {
            machine.stable = true;
          }
          final lines = consoleRepository.parse(log);
          machine.addLog(lines);
        }
        machine.addLog(
          generateOneLineConsoleLine(
            serverStateSuccess.i18n,
          ),
        );
        machine.stable = false;
        machine.state = machine.postProcessCleanerState;
        machine.state.start();
        return;
      }
      machine.addLog(
        generateOneLineConsoleLine(
          '${serverStateUnexpectedFailure.i18n}(1)',
        ),
      );
    } on ServerCloseUnexpectedException {
      machine.addLog(
        generateOneLineConsoleLine(
          serverStateExitCodeFailure.i18n,
        ),
      );
    } catch (e) {
      machine.addLog(
        generateOneLineConsoleLine(
          serverStateUnexpectedFailure.i18n,
        ),
      );
    }
    machine.stable = false;
    machine.state = machine.postProcessCleanerState;
    machine.state.start();
  }

  @override
  void input(String command) {
    serverRepository.inputCommand(command: command);
  }
}
