import 'package:cube_api/cube_api.dart';
import 'package:path/path.dart';
import 'package:process/process.dart';

class ForgeInstallationException implements Exception {}

class ForgeInstallerRepository {
  ForgeInstallerRepository({
    ProcessManager? processManager,
  }) : _processManager = processManager ?? const LocalProcessManager();
  final ProcessManager _processManager;

  Stream<String> installForge({
    required String javaExecutablePath,
    required JarArchiveInfo jarArchiveInfo,
  }) async* {
    if (jarArchiveInfo.type != JarType.forgeInstaller) return;
    final executable = jarArchiveInfo.executable;
    final p = await _processManager.start(
      [javaExecutablePath, '-jar', basename(executable), '--installServer'],
      runInShell: true,
      workingDirectory: dirname(executable),
    );
    final stream = mergeStream(p.stdout, p.stderr);
    await for (final feedback in stream) {
      yield feedback;
    }
    final exitCode = await p.exitCode;
    p.kill();

    if (exitCode != 0) throw ForgeInstallationException();
  }
}
