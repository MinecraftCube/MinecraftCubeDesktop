import 'dart:convert';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements io.ProcessResult {}

class MockPlatform extends Mock implements Platform {}

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockEncoding extends Mock implements Encoding {}

void main() {
  Encoding mockEncoding = MockEncoding();
  setUpAll(() {
    registerFallbackValue(mockEncoding);
  });
  group('JavaInfoRepository', () {
    late Platform platform;
    late ProcessManager processManager;
    late FileSystem fileSystem;
    late JavaInfoRepository repository;

    setUp(
      () {
        platform = MockPlatform();
        processManager = MockProcessManager();
        fileSystem = MockFileSystem();
        repository = JavaInfoRepository(
          processManager: processManager,
          platform: platform,
          fileSystem: fileSystem,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(const JavaInfoRepository(), isNotNull);
      });
    });

    group('getSystemJava', () {
      test('throws UnsupportedError on unknown os', () {
        when(() => platform.isLinux).thenReturn(false);
        when(() => platform.isWindows).thenReturn(false);
        when(() => platform.isMacOS).thenReturn(false);
        expect(
          repository.getSystemJava(),
          throwsA(isA<UnsupportedError>()),
        );
      });
      group('[windows]', () {
        const windowsJavaVersionCmd = 'java -version';
        const windowsJavaLocationCmd = 'where.exe java';
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(true);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getSystemJava(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default JavaInfo when nothing return', () async {
          io.ProcessResult javaVersionResult = MockProcessResult();
          io.ProcessResult javaLocationResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaVersionResult);
          when(() => javaVersionResult.exitCode).thenReturn(0);
          when(() => javaVersionResult.stderr).thenReturn('');
          when(() => javaVersionResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(windowsJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaLocationResult);
          when(() => javaLocationResult.exitCode).thenReturn(0);
          when(() => javaLocationResult.stderr).thenReturn('');
          when(() => javaLocationResult.stdout).thenReturn('');
          expect(
            await repository.getSystemJava(),
            const JavaInfo(executablePaths: [], name: 'java', output: ''),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct JavaInfo', () async {
          io.ProcessResult javaVersionResult = MockProcessResult();
          io.ProcessResult javaLocationResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaVersionResult);
          when(() => javaVersionResult.exitCode).thenReturn(0);
          when(() => javaVersionResult.stderr).thenReturn('');
          when(() => javaVersionResult.stdout).thenReturn(windowsJavaVersion);
          when(
            () => processManager.run(
              captureAny(that: contains(windowsJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaLocationResult);
          when(() => javaLocationResult.exitCode).thenReturn(0);
          when(() => javaLocationResult.stderr).thenReturn('');
          when(() => javaLocationResult.stdout).thenReturn(windowsJavaLocation);
          expect(
            await repository.getSystemJava(),
            const JavaInfo(
              name: 'java',
              executablePaths: [
                r'C:\Program Files\Common Files\Oracle\Java\javapath\java.exe',
                r'C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe',
                r'C:\ProgramData\Oracle\Java\javapath\java.exe',
              ],
              output: windowsJavaVersion,
            ),
          );
        });
      });
      group('[linux]', () {
        const linuxJavaVersionCmd = "java -version";
        const linuxJavaLocationCmd = "which java";
        setUp(() {
          when(() => platform.isLinux).thenReturn(true);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getSystemJava(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default JavaInfo when nothing return', () async {
          io.ProcessResult javaVersionResult = MockProcessResult();
          io.ProcessResult javaLocationResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaVersionResult);
          when(() => javaVersionResult.exitCode).thenReturn(0);
          when(() => javaVersionResult.stderr).thenReturn('');
          when(() => javaVersionResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(linuxJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaLocationResult);
          when(() => javaLocationResult.exitCode).thenReturn(0);
          when(() => javaLocationResult.stderr).thenReturn('');
          when(() => javaLocationResult.stdout).thenReturn('');
          expect(
            await repository.getSystemJava(),
            const JavaInfo(
              executablePaths: [],
              name: 'java',
            ),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct JavaInfo', () async {
          io.ProcessResult javaVersionResult = MockProcessResult();
          io.ProcessResult javaLocationResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaVersionResult);
          when(() => javaVersionResult.exitCode).thenReturn(0);
          when(() => javaVersionResult.stderr).thenReturn('');
          when(() => javaVersionResult.stdout).thenReturn(linuxJavaVersion);
          when(
            () => processManager.run(
              captureAny(that: contains(linuxJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaLocationResult);
          when(() => javaLocationResult.exitCode).thenReturn(0);
          when(() => javaLocationResult.stderr).thenReturn('');
          when(() => javaLocationResult.stdout).thenReturn(linuxJavaLocation);
          expect(
            await repository.getSystemJava(),
            const JavaInfo(
              name: 'java',
              executablePaths: ['/openjdk/bin/java', '/bin/java'],
              output: linuxJavaVersion,
            ),
          );
        });
      });

      group('[macos]', () {
        const macosJavaVersionCmd = "java -version";
        const macosJavaLocationCmd = "which java";
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(true);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getSystemJava(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default JavaInfo when nothing return', () async {
          io.ProcessResult javaVersionResult = MockProcessResult();
          io.ProcessResult javaLocationResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaVersionResult);
          when(() => javaVersionResult.exitCode).thenReturn(0);
          when(() => javaVersionResult.stderr).thenReturn('');
          when(() => javaVersionResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(macosJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaLocationResult);
          when(() => javaLocationResult.exitCode).thenReturn(0);
          when(() => javaLocationResult.stderr).thenReturn('');
          when(() => javaLocationResult.stdout).thenReturn('');
          expect(
            await repository.getSystemJava(),
            const JavaInfo(name: 'java', executablePaths: []),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(macosJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(macosJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct JavaInfo', () async {
          io.ProcessResult javaVersionResult = MockProcessResult();
          io.ProcessResult javaLocationResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosJavaVersionCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaVersionResult);
          when(() => javaVersionResult.exitCode).thenReturn(0);
          when(() => javaVersionResult.stderr).thenReturn('');
          when(() => javaVersionResult.stdout).thenReturn(macosJavaVersion);
          when(
            () => processManager.run(
              captureAny(that: contains(macosJavaLocationCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => javaLocationResult);
          when(() => javaLocationResult.exitCode).thenReturn(0);
          when(() => javaLocationResult.stderr).thenReturn('');
          when(() => javaLocationResult.stdout).thenReturn(macosJavaLocation);
          expect(
            await repository.getSystemJava(),
            const JavaInfo(
              name: 'java',
              executablePaths: ['/openjdk/bin/java', '/bin/java'],
              output: linuxJavaVersion,
            ),
          );
        });
      });
    });

    group('getPortableJavas', () {
      test('return nothing when no java directory', () async {
        Directory javaDir = MockDirectory();
        when(() => fileSystem.directory('java')).thenReturn(javaDir);
        when(() => javaDir.exists()).thenAnswer((_) async => false);
        expect(repository.getPortableJavas(), emitsDone);
      });
      test('return nothing when no any sub directory', () async {
        Directory javaDir = MockDirectory();
        when(() => fileSystem.directory('java')).thenReturn(javaDir);
        when(() => javaDir.exists()).thenAnswer((_) async => true);
        when(() => javaDir.list()).thenAnswer((_) => Stream.fromIterable([]));
        expect(repository.getPortableJavas(), emitsDone);
      });

      test('return nothing when no file match the bin/java rule', () async {
        Directory javaDir = MockDirectory();
        Directory dirA = MockDirectory();
        File fileA = MockFile();
        Directory dirB = MockDirectory();
        File fileB = MockFile();
        Directory dirC = MockDirectory();
        File fileC = MockFile();
        when(() => fileSystem.directory('java')).thenReturn(javaDir);
        when(() => javaDir.exists()).thenAnswer((_) async => true);
        when(() => javaDir.list())
            .thenAnswer((_) => Stream.fromIterable([dirA, dirB, dirC]));
        when(() => dirA.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([fileA]));
        when(() => dirB.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([fileB]));
        when(() => dirC.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([fileC]));
        when(() => fileA.path).thenReturn('AProjectJava/bin/cube_java');
        when(() => fileB.path).thenReturn('AProjectJava/bin/cube_java.exe');
        when(() => fileC.path).thenReturn('AProjectJava/bin/java/file.exe');
        expect(repository.getPortableJavas(), emitsDone);
      });

      test('return matche-only result on bin/java rule', () async {
        Directory javaDir = MockDirectory();
        Directory dirA = MockDirectory();
        File fileA = MockFile();
        Directory dirB = MockDirectory();
        File fileB = MockFile();
        Directory dirC = MockDirectory();
        File fileC = MockFile();
        when(() => fileSystem.directory('java')).thenReturn(javaDir);
        when(() => javaDir.exists()).thenAnswer((_) async => true);
        when(() => javaDir.list())
            .thenAnswer((_) => Stream.fromIterable([dirA, dirB, dirC]));
        when(() => dirA.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([fileA]));
        when(() => dirB.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([fileB]));
        when(() => dirC.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([fileC]));
        when(() => dirA.basename).thenReturn('AProjectJava');
        when(() => dirB.basename).thenReturn('BProjectJava');
        when(() => dirC.basename).thenReturn('CProjectJava');
        when(() => fileA.path).thenReturn('java/AProjectJava/bin/java');
        when(() => fileB.path).thenReturn('java/BProjectJava/bin/java.exe');
        when(() => fileC.path)
            .thenReturn('java/CProjectJava/bin/java/file.exe');
        expect(
          repository.getPortableJavas(),
          emitsInOrder([
            const JavaInfo(
              executablePaths: ['java/AProjectJava/bin/java'],
              name: 'AProjectJava',
            ),
            const JavaInfo(
              executablePaths: ['java/BProjectJava/bin/java.exe'],
              name: 'BProjectJava',
            ),
          ]),
        );
      });
    });
  });
}

const windowsJavaVersion = r'''java 17.0.1 2021-10-19 LTS
Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.1+12-LTS-39, mixed mode, sharing)
''';
const windowsJavaLocation =
    r'''C:\Program Files\Common Files\Oracle\Java\javapath\java.exe
C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
C:\ProgramData\Oracle\Java\javapath\java.exe
''';
const linuxJavaVersion = r'''openjdk version "1.8.0_302"
OpenJDK Runtime Environment (Zulu 8.56.0.21-CA-win64) (build 1.8.0_302-b08)
OpenJDK 64-Bit Server VM (Zulu 8.56.0.21-CA-win64) (build 25.302-b08, mixed mode)''';
const linuxJavaLocation = r'''/openjdk/bin/java
/bin/java''';
const macosJavaVersion = r'''openjdk version "1.8.0_302"
OpenJDK Runtime Environment (Zulu 8.56.0.21-CA-win64) (build 1.8.0_302-b08)
OpenJDK 64-Bit Server VM (Zulu 8.56.0.21-CA-win64) (build 25.302-b08, mixed mode)''';
const macosJavaLocation = r'''/openjdk/bin/java
/bin/java''';
