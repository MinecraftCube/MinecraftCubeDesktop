import 'package:process/process.dart';

class JavaPrinterRepository {
  const JavaPrinterRepository({
    ProcessManager? processManager,
  }) : _processManager = processManager ?? const LocalProcessManager();
  final ProcessManager _processManager;

  Future<String> getVersionInfo({required String javaExecutablePath}) async {
    final result = await _processManager.run(
      [javaExecutablePath, '-version'],
      runInShell: true,
      includeParentEnvironment: true,
    );
    final stdout = result.stdout;
    final stderr = result.stderr;
    if (result.exitCode != 0) {
      if (stderr != null && stderr is String && stderr.isNotEmpty) {
        throw Exception(stderr);
      }
      throw Exception('get version error');
    }

    if (stdout is String && stdout.isNotEmpty) return stdout;
    if (stderr is String && stderr.isNotEmpty) return stderr;
    return 'missing version info...';
  }
}
