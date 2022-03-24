import 'dart:async';

import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';

// enum ServerState {
//   idle,
//   preProcess,
//   preDuplicate,
//   eulaStage,
//   eulaAsk,
//   jarAnalyze,
//   configurationLoad,
//   javaPrint,
//   javaDuplicate,
//   forgeInstall,
//   server,
//   postProcess,
//   postDuplicate,
// }

abstract class IState {
  IState({required this.machine});
  final ServerMachine machine;
  FutureOr<void> agree() {}
  FutureOr<void> disagree() {}
  FutureOr<void> stop() {}
  FutureOr<void> start() {}
  FutureOr<void> input(String command) {}

  // ServerState get pureState;
}
