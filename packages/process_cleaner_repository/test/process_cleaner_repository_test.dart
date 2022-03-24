import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:process_cleaner_repository/process_cleaner_repository.dart';

const pid = 27087;
const windowsRaw = '''
System Idle Process              0 Services                   0          8 K
System                           4 Services                   0      7,380 K
Registry                       140 Services                   0     41,736 K
smss.exe                       560 Services                   0        292 K
csrss.exe                      824 Services                   0      2,336 K
wininit.exe                    912 Services                   0      1,580 K
csrss.exe                      $pid Console                    1      3,648 K
''';
const otherRaw = '$pid';

class MockProcessManager extends Mock implements ProcessManager {}

class MockPlatform extends Mock implements Platform {}

class MockProcessResult extends Mock implements io.ProcessResult {}

void main() {
  group('ProcessCleanerRepository', () {
    late ProcessManager processManager;
    late Platform platform;
    late ProcessCleanerRepository repository;

    setUp(
      () {
        processManager = MockProcessManager();
        platform = MockPlatform();
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
      group(
        '[windows]',
        () {
          setUp(() {
            when(() => platform.isWindows).thenReturn(true);
            when(() => platform.isLinux).thenReturn(false);
            when(() => platform.isMacOS).thenReturn(false);
          });
          test(
            'calls run(tasklist | findstr cube_java)',
            () async {
              try {
                await repository.listJavaProcesses();
              } catch (_) {}
              verify(() => platform.isWindows).called(1);
              verify(
                () => processManager.run(
                  ['tasklist | findstr cube_java'],
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).called(1);
            },
          );
          test(
            'return correct pids on success',
            () async {
              final io.ProcessResult processResult = MockProcessResult();
              when(() => processResult.stdout).thenReturn(windowsRaw);
              when(
                () => processManager.run(
                  any(),
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).thenAnswer((_) async => processResult);
              final actual = await repository.listJavaProcesses();
              expect(
                actual,
                [pid.toString()],
              );
            },
          );
        },
      );
      group(
        '[linux]',
        () {
          setUp(() {
            when(() => platform.isWindows).thenReturn(false);
            when(() => platform.isLinux).thenReturn(true);
            when(() => platform.isMacOS).thenReturn(false);
          });
          test(
            'calls run(ps -ejH | grep cube_java | awk \'{print \$1}\')',
            () async {
              try {
                await repository.listJavaProcesses();
              } catch (_) {}
              verify(() => platform.isLinux).called(1);
              verify(
                () => processManager.run(
                  ['ps -ejH | grep cube_java | awk \'{print \$1}\''],
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).called(1);
            },
          );
          test(
            'return correct pids on success',
            () async {
              final io.ProcessResult processResult = MockProcessResult();
              when(() => processResult.stdout).thenReturn(otherRaw);
              when(
                () => processManager.run(
                  any(),
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).thenAnswer((_) async => processResult);
              final actual = await repository.listJavaProcesses();
              expect(
                actual,
                [pid.toString()],
              );
            },
          );
        },
      );
      group(
        '[macos]',
        () {
          setUp(() {
            when(() => platform.isWindows).thenReturn(false);
            when(() => platform.isLinux).thenReturn(false);
            when(() => platform.isMacOS).thenReturn(true);
          });
          test(
            'calls run(ps aux | grep cube_java | grep -v grep | awk \'{print \$2}\')',
            () async {
              try {
                await repository.listJavaProcesses();
              } catch (_) {}
              verify(() => platform.isMacOS).called(1);
              verify(
                () => processManager.run(
                  [
                    'ps aux | grep cube_java | grep -v grep | awk \'{print \$2}\''
                  ],
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).called(1);
            },
          );
          test(
            'return correct pids on success',
            () async {
              final io.ProcessResult processResult = MockProcessResult();
              when(() => processResult.stdout).thenReturn(otherRaw);
              when(
                () => processManager.run(
                  any(),
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).thenAnswer((_) async => processResult);
              final actual = await repository.listJavaProcesses();
              expect(
                actual,
                [pid.toString()],
              );
            },
          );
        },
      );
    });

    group('killJavaProcesses', () {
      group(
        '[windows]',
        () {
          setUp(() {
            when(() => platform.isWindows).thenReturn(true);
            when(() => platform.isLinux).thenReturn(false);
            when(() => platform.isMacOS).thenReturn(false);
          });
          test(
            'calls run(taskkill /f /PID $pid)',
            () async {
              final io.ProcessResult processResult = MockProcessResult();
              when(() => processResult.stdout).thenReturn(windowsRaw);
              when(
                () => processManager.run(
                  any(),
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).thenAnswer((_) async => processResult);
              try {
                await repository.killJavaProcesses();
              } catch (_) {}
              verify(() => platform.isWindows).called(2);
              verify(
                () => processManager.run(
                  ['taskkill /f /PID', '$pid'],
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).called(1);
            },
          );
        },
      );
      group(
        '[linux]',
        () {
          setUp(() {
            when(() => platform.isWindows).thenReturn(false);
            when(() => platform.isLinux).thenReturn(true);
            when(() => platform.isMacOS).thenReturn(false);
          });
          test(
            'calls run(kill $pid)',
            () async {
              final io.ProcessResult processResult = MockProcessResult();
              when(() => processResult.stdout).thenReturn(otherRaw);
              when(
                () => processManager.run(
                  any(),
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).thenAnswer((_) async => processResult);
              try {
                await repository.killJavaProcesses();
              } catch (_) {}
              verify(() => platform.isLinux).called(1);
              verify(
                () => processManager.run(
                  ['kill', '$pid'],
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).called(1);
            },
          );
        },
      );
      group(
        '[macos]',
        () {
          setUp(() {
            when(() => platform.isWindows).thenReturn(false);
            when(() => platform.isLinux).thenReturn(false);
            when(() => platform.isMacOS).thenReturn(true);
          });
          test(
            'calls run(kill $pid)',
            () async {
              final io.ProcessResult processResult = MockProcessResult();
              when(() => processResult.stdout).thenReturn(otherRaw);
              when(
                () => processManager.run(
                  any(),
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).thenAnswer((_) async => processResult);
              try {
                await repository.killJavaProcesses();
              } catch (_) {}
              verify(() => platform.isMacOS).called(1);
              verify(
                () => processManager.run(
                  ['kill', '$pid'],
                  sanitize: captureAny(named: 'sanitize'),
                  runInShell: captureAny(named: 'runInShell'),
                ),
              ).called(1);
            },
          );
        },
      );
    });
  });
}
