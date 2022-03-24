import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/java_printer_state.i18n.dart';

class JavaPrinterState extends IState {
  JavaPrinterState(
    ServerMachine machine, {
    required this.javaPrinterRepository,
  }) : super(machine: machine);
  final JavaPrinterRepository javaPrinterRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(
        javaPrinterProgress.i18n,
      ),
    );
    try {
      final properties = machine.properties;
      if (properties != null) {
        final info = await javaPrinterRepository.getVersionInfo(
          javaExecutablePath: properties.java,
        );
        machine.addLog(
          generateOneLineConsoleLine(
            info,
          ),
        );
        machine.addLog(
          generateOneLineConsoleLine(
            javaPrinterSuccess.i18n,
          ),
        );
        machine.state = machine.javaDuplicatorState;
        machine.state.start();
        return;
      }
      machine.addLog(
        generateOneLineConsoleLine(
          javaPrinterFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    } catch (_) {
      machine.addLog(
        generateOneLineConsoleLine(
          javaPrinterFailure.i18n,
        ),
      );
      machine.state = machine.idleState;
    }
  }
}
