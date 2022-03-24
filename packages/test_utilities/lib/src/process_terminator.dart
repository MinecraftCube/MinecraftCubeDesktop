import 'dart:convert';
import 'dart:io';

Future<void> terminateProcessName(String name) async {
  List<String> processes = [];
  // windows: tasklist | findstr cube_java
  // linux: ps -aux | grep cube_java | grep -v grep | awk '{print $2}'
  // macos: ps aux | grep cube_java | grep -v grep | awk '{print $2}'
  addPidByPattern(RegExp pidPattern, String stdout) {
    final matches = pidPattern.allMatches(stdout);
    if (matches.isEmpty) return [];
    for (final match in matches) {
      final pid = match.group(1);
      if (pid != null) processes.add(pid);
    }
  }

  if (Platform.isWindows) {
    final cubeCommand = 'tasklist | findstr $name';
    // const javaCommand = 'tasklist | findstr java.exe';
    RegExp pidReg = RegExp(r'\ +(\d+)\ Console', multiLine: true);
    ProcessResult result = await Process.run(
      cubeCommand,
      [],
      runInShell: true,
    );
    if (result.stdout is String) addPidByPattern(pidReg, result.stdout);
    // result = await Process.run(javaCommand, [], runInShell: true);
    // if (result.stdout is String) addPidByPattern(pidReg, result.stdout);
  } else if (Platform.isLinux) {
    final cubeCommand = 'ps -ejH | grep $name | awk \'{print \$1}\'';
    ProcessResult result =
        await Process.run('bash', ['-c', cubeCommand], runInShell: true);
    if (result.stdout is String) {
      final pids = LineSplitter.split(result.stdout);
      processes.addAll(pids);
    }
  } else if (Platform.isMacOS) {
    final cubeCommand =
        'ps aux | grep $name | grep -v grep | awk \'{print \$2}\'';
    ProcessResult result =
        await Process.run('bash', ['-c', cubeCommand], runInShell: true);
    if (result.stdout is String) {
      final pids = LineSplitter.split(result.stdout);
      processes.addAll(pids);
    }
  }

  final prefix = Platform.isWindows ? 'taskkill /f /PID' : 'bash';
  for (String pid in processes) {
    final List<String> command = Platform.isWindows
        ? [pid.toString()]
        : ['-c', 'kill ${pid.toString()}'];
    await Process.run(
      prefix,
      command,
      runInShell: true,
    );
  }
}
