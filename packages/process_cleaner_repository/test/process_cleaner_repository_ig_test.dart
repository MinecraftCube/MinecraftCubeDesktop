@Tags(['integration'])

import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' hide equals;
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('ProcessCleanerRepository', () {
    late ProcessManager processManager;
    late Platform platform;
    late ProcessCleanerRepository repository;

    setUp(
      () {
        processManager = const LocalProcessManager();
        platform = const LocalPlatform();
        repository = ProcessCleanerRepository(
          processManager: processManager,
          platform: platform,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(ProcessCleanerRepository(), isNotNull);
      });
    });

    group('listJavaProcesses', () {
      late io.Process p;
      setUp(() async {
        p = await createCubeJavaProcess();
        await Future.delayed(const Duration(seconds: 2));
      });

      tearDown(() async {
        p.kill();
        await p.exitCode;
        await terminateProcessName('cube_java');
      });

      test(
        'calls platform-command to list cube_java processes',
        () async {
          expect(await repository.listJavaProcesses(), hasLength(1));
        },
      );
    });

    group(
      'killJavaProcesses',
      () {
        late io.Process p;
        setUp(() async {
          p = await createCubeJavaProcess();
          await Future.delayed(const Duration(seconds: 2));
        });

        tearDown(() async {
          p.kill();
          await p.exitCode;
          await terminateProcessName('cube_java');
          await Future.delayed(const Duration(seconds: 1));
        });
        test(
          'calls platform-command to kill cube_java processes',
          () async {
            expect(await repository.listJavaProcesses(), hasLength(1));
            await repository.killJavaProcesses();
            expect(await repository.listJavaProcesses(), hasLength(0));
          },
        );
      },
    );
  });
}

Future<io.Process> createCubeJavaProcess() async {
  List<String> command = [];
  String prefix = 'bash';
  if (io.Platform.isLinux) {
    command = ['-c', './cube_java_linux'];
  } else if (io.Platform.isMacOS) {
    command = ['-c', './cube_java_macos'];
  } else {
    prefix = 'cube_java.exe';
    command = [];
  }
  return await io.Process.start(
    prefix,
    command,
    runInShell: true,
    workingDirectory:
        join(TestUtilities().rootResources, 'process_cleaner_repository'),
  );
}
