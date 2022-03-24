import 'dart:convert';
import 'dart:io';

import 'package:platform/platform.dart';
import 'package:process/process.dart';

class ProcessCleanerRepository {
  ProcessCleanerRepository({
    ProcessManager? processManager,
    Platform? platform,
  })  : _processManager = processManager ?? const LocalProcessManager(),
        _platform = platform ?? const LocalPlatform();
  final ProcessManager _processManager;
  final Platform _platform;

  Future<List<String>> listJavaProcesses() async {
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

    if (_platform.isWindows) {
      const cubeCommand = 'tasklist | findstr cube_java';
      // const javaCommand = 'tasklist | findstr java.exe';
      RegExp pidReg = RegExp(r'\ +(\d+)\ Console', multiLine: true);
      ProcessResult result = await _processManager.run(
        [cubeCommand],
        sanitize: false,
        runInShell: true,
        includeParentEnvironment: true,
      );
      if (result.stdout is String) addPidByPattern(pidReg, result.stdout);
      // result = await Process.run(javaCommand, [], runInShell: true);
      // if (result.stdout is String) addPidByPattern(pidReg, result.stdout);
    } else if (_platform.isLinux) {
      const cubeCommand = 'ps -ejH | grep cube_java | awk \'{print \$1}\'';
      ProcessResult result = await _processManager.run(
        [cubeCommand],
        sanitize: false,
        runInShell: true,
        includeParentEnvironment: true,
      );
      if (result.stdout is String) {
        final pids = LineSplitter.split(result.stdout);
        processes.addAll(pids);
      }
    } else if (_platform.isMacOS) {
      const cubeCommand =
          'ps aux | grep cube_java | grep -v grep | awk \'{print \$2}\'';
      ProcessResult result = await _processManager.run(
        [cubeCommand],
        sanitize: false,
        runInShell: true,
        includeParentEnvironment: true,
      );
      if (result.stdout is String) {
        final pids = LineSplitter.split(result.stdout);
        processes.addAll(pids);
      }
    }

    return processes;
  }

  Future<void> killJavaProcesses() async {
    // windows: taskkill /f /PID 19380
    // linux: kill 19380
    // macos: kill 19380
    final prefix = _platform.isWindows ? 'taskkill /f /PID' : 'kill';
    final List<String> processes = await listJavaProcesses();
    for (String pid in processes) {
      await _processManager.run(
        [prefix, pid],
        runInShell: true,
        sanitize: false,
        includeParentEnvironment: true,
      );
    }
  }
}
