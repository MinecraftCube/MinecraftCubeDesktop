import 'dart:async';
import 'dart:io';

import 'package:cube_api/cube_api.dart';
import 'package:path/path.dart' as p;
import 'package:process/process.dart';

class ServerCloseUnexpectedException implements Exception {}

class ServerRepository {
  final ProcessManager _processManager;
  Process? _process;
  ServerRepository({
    ProcessManager? processManager,
  }) : _processManager = processManager ?? const LocalProcessManager();

  Stream<String> startServer({
    CubeProperties cubeProperties = const CubeProperties(),
    String? javaExecutable,
    required JarArchiveInfo jarArchiveInfo,
    required String projectPath,
  }) async* {
    _clearProcess();
    final javaSource = javaExecutable ?? cubeProperties.java;
    final javaArguments = [
      '-Xmx${cubeProperties.xmx}',
      '-Xms${cubeProperties.xms}'
    ];
    const javaExecuteArg = '-jar';
    final serverExecutable = p.basename(jarArchiveInfo.executable);
    final forgeTxtArguments =
        '@${p.relative(jarArchiveInfo.executable, from: projectPath)}';
    const serverArgument = 'nogui';

    // Don't use const, const means unmodifiable list.
    final List<String> commands = [];
    commands.add(javaSource);
    commands.addAll(javaArguments);
    if (jarArchiveInfo.type == JarType.forge1182) {
      commands.add(forgeTxtArguments);
    } else {
      commands.add(javaExecuteArg);
      commands.add(serverExecutable);
    }
    commands.add(serverArgument);

    final serverExecutableDir = projectPath;
    final process = await _processManager.start(
      commands,
      runInShell: true,
      workingDirectory: serverExecutableDir,
    );
    _process = process;

    // use another StreamController instead
    // since dev don't know the relation between [stdout, stderr] and exitCode
    // dev trust exitCode more than stream, so the method looks wierd.
    final controller = StreamController<String>();
    final terminalStream = mergeStream(process.stdout, process.stderr);
    final sub = terminalStream.listen(
      (log) {
        controller.sink.add(log);
      },
      onError: (e) {
        controller.sink.add(e.toString());
      }, // FormatException will cause an uncatachable exception...
    );

    // Trust on exitCode to terminate stream
    process.exitCode.then((value) async {
      await controller.close();
      await sub.cancel();
    });

    yield* controller.stream;

    final exitCode = await process.exitCode;
    if (exitCode == 0) yield 'Safe Complete!';
    if (exitCode != 0) throw ServerCloseUnexpectedException();
  }

  void inputCommand({required String command}) {
    _process?.stdin.writeln(command);
  }

  Future<void> _clearProcess() async {
    _process?.kill();
    _process = null;
  }
}
