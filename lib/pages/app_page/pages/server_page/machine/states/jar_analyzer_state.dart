import 'package:cube_api/cube_api.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_analyzer_state.i18n.dart';

class JarAnalyzerState extends IState {
  JarAnalyzerState(
    ServerMachine machine, {
    required this.jarAnalyzerRepository,
  }) : super(machine: machine);
  final JarAnalyzerRepository jarAnalyzerRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        jarAnalyzerProgress.i18n,
      ),
    );
    try {
      final path = machine.projectPath;
      if (path != null) {
        final jarArchiveInfo =
            await jarAnalyzerRepository.analyzeDirectory(directory: path);
        if (jarArchiveInfo != null) {
          machine.jarInfo = jarArchiveInfo;
          machine.addLog(
            generateOneLineConsoleLine(
              jarAnalyzerSuccess.i18n,
            ),
          );
          if (jarArchiveInfo.type == JarType.unknown) {
            machine.state = machine.jarDangerousAskState;
            return;
          }
          machine.state = machine.configurationLoaderState;
          machine.state.start();
          return;
        }
      }
      machine.addLog(
        generateOneLineConsoleLine(
          jarAnalyzerFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          jarAnalyzerFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
