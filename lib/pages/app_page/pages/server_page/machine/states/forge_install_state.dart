import 'package:console_repository/console_repository.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/forge_install_state.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';

class ForgeInstallState extends IState {
  ForgeInstallState(
    ServerMachine machine, {
    required this.forgeInstallRepository,
    required this.consoleRepository,
  }) : super(machine: machine);
  final ForgeInstallerRepository forgeInstallRepository;
  final ConsoleRepository consoleRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        forgeInstallProgress.i18n,
      ),
    );
    try {
      final jarInfo = machine.jarInfo;
      final executable = machine.executable;
      if (jarInfo != null && executable != null) {
        int count = 0;
        await for (final _ in forgeInstallRepository.installForge(
          javaExecutablePath: executable,
          jarArchiveInfo: jarInfo,
        )) {
          count++;
          // IMPROVED: Currently, addLog will crash ui and slow down whole process...
          // machine.addLog(
          //   consoleRepository.parse(log),
          // );
        }

        // no need
        if (count == 0) {
          machine.addLog(
            generateOneLineConsoleLine(
              forgeInstallPassSuccess.i18n,
            ),
          );
          machine.state = machine.serverRunState;
          machine.state.start();
        } else {
          machine.addLog(
            generateOneLineConsoleLine(
              forgeInstallForgeSuccess.i18n,
            ),
          );
          machine.state = machine.preProcessCleanerState;
          machine.state.start();
        }
        return;
      }
      machine.addLog(
        generateOneLineConsoleLine(
          forgeInstallFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          forgeInstallFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
