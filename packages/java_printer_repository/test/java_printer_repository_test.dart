import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements io.ProcessResult {}

void main() {
  group('JavaPrinterRepository', () {
    late ProcessManager processManager;
    late JavaPrinterRepository repository;

    setUp(
      () {
        processManager = MockProcessManager();
        repository = JavaPrinterRepository(
          processManager: processManager,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(const JavaPrinterRepository(), isNotNull);
      });
    });

    group('getJavaVersion', () {
      test('return correct java info', () async {
        io.ProcessResult result = MockProcessResult();
        when(
          () => processManager.run(
            captureAny(),
            runInShell: true,
            includeParentEnvironment: true,
          ),
        ).thenAnswer((_) async => result);
        when(() => result.exitCode).thenReturn(0);
        when(() => result.stderr).thenReturn('');
        when(() => result.stdout).thenReturn(javaRaw);
        expect(
          await repository.getVersionInfo(javaExecutablePath: 'java'),
          matches(
            RegExp(r'version \".*\"'),
          ),
        );
      });

      test('throws exception when exitCode not equal to 0', () async {
        io.ProcessResult result = MockProcessResult();
        when(
          () => processManager.run(
            captureAny(),
            runInShell: true,
            includeParentEnvironment: true,
          ),
        ).thenAnswer((_) async => result);
        when(() => result.exitCode).thenReturn(-1);
        when(() => result.stderr).thenReturn('123');
        when(() => result.stdout).thenReturn('anything');
        expect(
          () async =>
              await repository.getVersionInfo(javaExecutablePath: 'java'),
          throwsException,
        );
      });

      test('return stderr when exitCode 0 but has empty stdout', () async {
        io.ProcessResult result = MockProcessResult();
        when(
          () => processManager.run(
            captureAny(),
            runInShell: true,
            includeParentEnvironment: true,
          ),
        ).thenAnswer((_) async => result);
        when(() => result.exitCode).thenReturn(0);
        when(() => result.stderr).thenReturn('123');
        when(() => result.stdout).thenReturn('');
        expect(
          await repository.getVersionInfo(javaExecutablePath: 'java'),
          '123',
        );
      });
    });
  });
}

const javaRaw = '''java version "17.0.1" 2021-10-19 LTS
Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.1+12-LTS-39, mixed mode, sharing)''';
