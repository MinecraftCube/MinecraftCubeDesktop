import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:java_info_repository/src/java_info.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

// class LinuxMissingPackageException implements Exception {}

class JavaInfoRepository {
  const JavaInfoRepository({
    ProcessManager? processManager,
    Platform? platform,
    FileSystem? fileSystem,
  })  : _processManager = processManager ?? const LocalProcessManager(),
        _platform = platform ?? const LocalPlatform(),
        _fileSystem = fileSystem ?? const LocalFileSystem();
  final ProcessManager _processManager;
  final Platform _platform;
  final FileSystem _fileSystem;
  // ignore: non_constant_identifier_names
  final JAVA_PORTABLE_FOLDER = 'java';

  Future<JavaInfo> getSystemJava() async {
    String javaCmd = 'java -version';
    String findJavadCmd = '';

    if (_platform.isLinux) {
      findJavadCmd = 'which java';
    } else if (_platform.isMacOS) {
      findJavadCmd = 'which java';
    } else if (_platform.isWindows) {
      findJavadCmd = 'where.exe java';
    } else {
      throw UnsupportedError('out of OS');
    }

    final javaResult = await _processManager.run(
      [javaCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );
    final findJavaResult = await _processManager.run(
      [findJavadCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );

    String? javaVersion = transformProcessResult(javaResult);
    String? javaLocation = transformProcessResult(findJavaResult);

    List<String> paths = const LineSplitter().convert(javaLocation ?? '');
    paths = paths.where((p) => p.isNotEmpty && p.contains('java')).toList();

    return JavaInfo(
      executablePaths: paths,
      name: 'java',
      output: javaVersion ?? '',
    );
  }

  Stream<JavaInfo> getPortableJavas() async* {
    Directory javaDir = _fileSystem.directory(JAVA_PORTABLE_FOLDER);
    final reg = RegExp(r'bin[\/|\\|]+java(\.exe|)$');
    if (!await javaDir.exists()) return;

    await for (final entity in javaDir.list()) {
      if (entity is Directory) {
        final subDir = entity;
        final List<String> executables = [];
        await for (final e in subDir.list(recursive: true)) {
          if (e is File && reg.hasMatch(e.path)) {
            executables.add(e.path);
          }
        }
        if (executables.isNotEmpty) {
          executables.sort(((a, b) => a.compareTo(b)));
          yield JavaInfo(executablePaths: executables, name: subDir.basename);
        }
      }
    }
  }
}
