import 'dart:ui';

import 'package:ansi_up/ansi_up.dart';
import 'package:console_repository/src/console_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // This is not a unit test! Don't mock AnsiUp for validate correctness.
  group('ConsoleRepository', () {
    late ConsoleRepository consoleRepository;
    setUp(() {
      consoleRepository = ConsoleRepository(AnsiUp());
    });
    group('parse', () {
      test('rawA correctly', () {
        // For advanced: https://github.com/dart-lang/sdk/blob/e995cb5f7cd67d39c1ee4bdbe95c8241db36725f/tests/corelib/iterable_to_list_test.dart
        expect(
          consoleRepository.parse(rawA),
          [
            ConsoleLine(
              texts: Iterable.castFrom([
                const ConsoleText(
                  text:
                      r'''2022-03-01 16:08:51,840 main WARN Advanced terminal features are not available in this environment''',
                ),
              ]),
            ),
            ConsoleLine(
              texts: Iterable.castFrom([
                const ConsoleText(
                  text:
                      '[16:08:52] [main/INFO] [cp.mo.mo.Launcher/MODLAUNCHER]: ModLauncher running: args [--gameDir, ., --launchTarget, fmlserver, --fml.forgeVersion, 31.1.1, --fml.mcpVersion, 20200122.131323, --fml.mcVersion, 1.15.2, --fml.forgeGroup, net.minecraftforge]',
                  foreground: Color.fromRGBO(0, 187, 0, 1),
                ),
              ]),
            ),
            ConsoleLine(
              texts: Iterable.castFrom([
                const ConsoleText(
                  text:
                      '[16:08:52] [main/INFO] [cp.mo.mo.Launcher/MODLAUNCHER]: ModLauncher 5.0.0-milestone.4+67+b1a340b starting: java version 17.0.1 by Oracle Corporation',
                  foreground: Color.fromRGBO(0, 187, 0, 1),
                ),
              ]),
            )
          ],
        );
      });
      test('rawB correctly', () {
        expect(
          consoleRepository.parse(rawB),
          [
            ConsoleLine(
              texts: Iterable.castFrom([
                const ConsoleText(
                  text:
                      r'''[19:14:59] [main/INFO] [cp.mo.mo.LaunchServiceHandler/MODLAUNCHER]: Launching target 'fmlserver' with arguments [--gameDir, .]''',
                  foreground: Color.fromRGBO(0, 187, 0, 1),
                ),
              ]),
            ),
            ConsoleLine(
              texts: Iterable.castFrom([
                const ConsoleText(
                  text:
                      '[19:15:06] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, destination] and [teleport, targets] with inputs: [Player, 0123, @e, dd12be42-52a9-4a91-a8a1-11c01849e498]',
                  foreground: Color.fromRGBO(187, 187, 0, 1),
                ),
              ]),
            ),
            ConsoleLine(
              texts: Iterable.castFrom([
                const ConsoleText(
                  text:
                      '[19:15:06] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, location] and [teleport, destination] with inputs: [0.1 -0.5 .9, 0 0 0]',
                  foreground: Color.fromRGBO(187, 187, 0, 1),
                ),
              ]),
            )
          ],
        );
      });
    });
  });
}

const rawA =
    '''2022-03-01 16:08:51,840 main WARN Advanced terminal features are not available in this environment
[32m[16:08:52] [main/INFO] [cp.mo.mo.Launcher/MODLAUNCHER]: ModLauncher running: args [--gameDir, ., --launchTarget, fmlserver, --fml.forgeVersion, 31.1.1, --fml.mcpVersion, 20200122.131323, --fml.mcVersion, 1.15.2, --fml.forgeGroup, net.minecraftforge]
[m[32m[16:08:52] [main/INFO] [cp.mo.mo.Launcher/MODLAUNCHER]: ModLauncher 5.0.0-milestone.4+67+b1a340b starting: java version 17.0.1 by Oracle Corporation''';

const rawB =
    '''[m[32m[19:14:59] [main/INFO] [cp.mo.mo.LaunchServiceHandler/MODLAUNCHER]: Launching target 'fmlserver' with arguments [--gameDir, .]
[m[33m[19:15:06] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, destination] and [teleport, targets] with inputs: [Player, 0123, @e, dd12be42-52a9-4a91-a8a1-11c01849e498]
[m[33m[19:15:06] [main/WARN] [minecraft/Commands]: Ambiguity between arguments [teleport, location] and [teleport, destination] with inputs: [0.1 -0.5 .9, 0 0 0]''';
