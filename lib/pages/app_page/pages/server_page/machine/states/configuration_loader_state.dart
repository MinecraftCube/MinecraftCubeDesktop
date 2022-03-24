import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/configuration_loader_state.i18n.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/istate.dart';

class ConfigurationLoaderState extends IState {
  ConfigurationLoaderState(
    ServerMachine machine, {
    required this.cubePropertiesRepository,
  }) : super(machine: machine);
  final CubePropertiesRepository cubePropertiesRepository;

  @override
  Future<void> start() async {
    machine.addLog(
      generateOneLineConsoleLine(configurationLoaderProgress.i18n),
    );
    try {
      final path = machine.projectPath;
      if (path != null) {
        final properites =
            await cubePropertiesRepository.getCubeProperties(directory: path);
        machine.properties = properites;
        machine.addLog(
          generateOneLineConsoleLine(configurationLoaderSuccess.i18n),
        );
        machine.state = machine.javaPrinterState;
        machine.state.start();
        return;
      }
      machine
          .addLog(generateOneLineConsoleLine(configurationLoaderFailure.i18n));
      machine.state = machine.idleState;
    } catch (_) {
      machine
          .addLog(generateOneLineConsoleLine(configurationLoaderFailure.i18n));
      machine.state = machine.idleState;
    }
  }
}
