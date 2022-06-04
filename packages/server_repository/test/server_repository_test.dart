// ignore_for_file: unnecessary_string_escapes

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';
import 'package:server_repository/server_repository.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcess extends Mock implements io.Process {}

class MockIOSink extends Mock implements io.IOSink {}

void main() {
  group('ServerRepository', () {
    late ProcessManager processManager;
    late ServerRepository repository;

    setUp(() {
      processManager = MockProcessManager();
      repository = ServerRepository(processManager: processManager);
    });

    group('constructor', () {
      test('instantiates internal processManager when not injected', () {
        expect(ServerRepository(), isNotNull);
      });
    });

    group('startServer', () {
      test('throws Exception when processManager unable to start a process',
          () async {
        const serverExecutable = 'nothing';
        const cubeProperties = CubeProperties();
        const jarArchiveInfo =
            JarArchiveInfo(type: JarType.vanilla, executable: serverExecutable);
        const projectPath = '/';
        when(
          () => processManager.start(
            captureAny(),
            workingDirectory: captureAny(named: 'workingDirectory'),
            runInShell: captureAny(named: 'runInShell'),
          ),
        ).thenThrow(Exception());

        await expectLater(
          repository.startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          ),
          emitsError(isException),
        );

        final captured = verify(
          () => processManager.start(
            captureAny(),
            runInShell: captureAny(named: 'runInShell'),
            workingDirectory: captureAny(named: 'workingDirectory'),
          ),
        ).captured;
        expect(captured, [
          [
            cubeProperties.java,
            '-Xmx${cubeProperties.xmx}',
            '-Xms${cubeProperties.xms}',
            '-jar',
            serverExecutable,
            'nogui',
          ],
          true,
          '/',
        ]);
      });

      test('called processManager.start with specifiedJava', () async {
        const serverExecutable = 'nothing';
        const specifiedJava = 'specifiedJava';
        const cubeProperties = CubeProperties();
        const jarArchiveInfo =
            JarArchiveInfo(type: JarType.vanilla, executable: serverExecutable);
        const projectPath = '/';
        when(
          () => processManager.start(
            captureAny(),
            workingDirectory: captureAny(named: 'workingDirectory'),
            runInShell: captureAny(named: 'runInShell'),
          ),
        ).thenThrow(Exception());

        await expectLater(
          repository.startServer(
            javaExecutable: specifiedJava,
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          ),
          emitsError(isException),
        );

        final captured = verify(
          () => processManager.start(
            captureAny(),
            runInShell: captureAny(named: 'runInShell'),
            workingDirectory: captureAny(named: 'workingDirectory'),
          ),
        ).captured;
        expect(captured, [
          [
            specifiedJava,
            '-Xmx${cubeProperties.xmx}',
            '-Xms${cubeProperties.xms}',
            '-jar',
            serverExecutable,
            'nogui',
          ],
          true,
          '/',
        ]);
      });

      group('forge 1.12.2', () {
        test('throws Exception when use java17 on unsupported forge', () async {
          const serverExecutable = 'server.jar';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo =
              JarArchiveInfo(type: JarType.forge, executable: serverExecutable);
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) =>
                convertStringToStream(FORGE_JAVA_FAILURE['content'] as String),
          );
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(FORGE_JAVA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
              expect(e, isA<ServerCloseUnexpectedException>());
            },
            onDone: () {
              completer.complete();
            },
          );

          await completer.future;

          expect(isErrorCalled, isTrue);
          expect(collects.join('\n'), equals(FORGE_JAVA_FAILURE['content']));
        });

        test('return Safe when use java8 on forge without EULA', () async {
          const serverExecutable = 'server.jar';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.vanilla,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) =>
                convertStringToStream(FORGE_EULA_FAILURE['content'] as String),
          );
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(FORGE_EULA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
            },
            onDone: () {
              completer.complete();
            },
          );

          await completer.future;

          expect(isErrorCalled, isFalse);
          final content = FORGE_EULA_FAILURE['content'] as String;
          expect(
            collects.join('\n'),
            equals(content + '\nSafe Complete!'),
          );
        });

        test('Success when use java8 on forge without EULA', () async {
          const serverExecutable = 'server.jar';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.forge,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) => Stream.fromIterable([]),
          );

          final controller = StreamController<List<int>>();
          when(() => process.stdout).thenAnswer((_) async* {
            yield* convertStringToStream(
              FORGE_SUCCESS_PART_A['content'] as String,
            );
            yield* controller.stream;
            yield* convertStringToStream(
              FORGE_SUCCESS_PART_B['content'] as String,
            );
          });

          final mockStdin = MockIOSink();
          when(() => process.stdin).thenReturn(mockStdin);
          when(() => mockStdin.writeln(any(that: startsWith('stop'))))
              .thenAnswer((_) {
            controller.close();
          });
          when(() => mockStdin.writeln(any(that: isNot(startsWith('stop')))))
              .thenAnswer((_) {
            controller.sink.add(FORGE_ECHO.codeUnits);
          });

          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(FORGE_EULA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
            },
            onDone: () {
              completer.complete();
            },
          );

          await Future.delayed(const Duration(seconds: 1));
          repository.inputCommand(command: '123');
          repository.inputCommand(command: 'stop');
          await completer.future;

          expect(isErrorCalled, isFalse);
          expect(
            collects.join('\n'),
            allOf([
              contains(FORGE_ECHO),
              contains(FORGE_SUCCESS_PART_B['content']),
              contains(FORGE_SUCCESS_PART_A['content']),
              endsWith('Safe Complete!'),
            ]),
          );
        });
      });

      group('vanilla 1.18', () {
        test('throws Exception when use java8', () async {
          const serverExecutable = 'server.jar';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.vanilla,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) => convertStringToStream(
              VANILLA_JAVA_FAILURE['content'] as String,
            ),
          );
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(VANILLA_JAVA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
              expect(e, isA<ServerCloseUnexpectedException>());
            },
            onDone: () {
              completer.complete();
            },
          );

          await completer.future;

          expect(isErrorCalled, isTrue);
          expect(collects.join('\n'), equals(VANILLA_JAVA_FAILURE['content']));
        });

        test('return Safe when use java17 on forge without EULA', () async {
          const serverExecutable = 'server.jar';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.vanilla,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) => convertStringToStream(
              VANILLA_EULA_FAILURE['content'] as String,
            ),
          );
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(VANILLA_EULA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
            },
            onDone: () {
              completer.complete();
            },
          );

          await completer.future;

          expect(isErrorCalled, isFalse);
          final content = VANILLA_EULA_FAILURE['content'] as String;
          expect(
            collects.join('\n'),
            equals(content + '\nSafe Complete!'),
          );
        });

        test('Success when use java8 on forge without EULA', () async {
          const serverExecutable = 'server.jar';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.vanilla,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) => Stream.fromIterable([]),
          );

          final controller = StreamController<List<int>>();
          when(() => process.stdout).thenAnswer((_) async* {
            yield* convertStringToStream(
              VANILLA_SUCCESS_PART_A['content'] as String,
            );
            yield* controller.stream;
            yield* convertStringToStream(
              VANILLA_SUCCESS_PART_B['content'] as String,
            );
          });

          final mockStdin = MockIOSink();
          when(() => process.stdin).thenReturn(mockStdin);
          when(() => mockStdin.writeln(any(that: startsWith('stop'))))
              .thenAnswer((_) {
            controller.close();
          });
          when(() => mockStdin.writeln(any(that: isNot(startsWith('stop')))))
              .thenAnswer((_) {
            controller.sink.add(VANILLA_ECHO.codeUnits);
          });

          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(VANILLA_EULA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
            },
            onDone: () {
              completer.complete();
            },
          );

          await Future.delayed(const Duration(seconds: 1));
          repository.inputCommand(command: '123');
          repository.inputCommand(command: 'stop');
          await completer.future;

          expect(isErrorCalled, isFalse);
          expect(
            collects.join('\n'),
            allOf([
              contains(VANILLA_ECHO),
              contains(VANILLA_SUCCESS_PART_B['content']),
              contains(VANILLA_SUCCESS_PART_A['content']),
              endsWith('Safe Complete!'),
            ]),
          );
        });
      });

      group('forge 1.18.2+', () {
        test('throws Exception when use java8 on unsupported forge', () async {
          final serverExecutable = p.join(
            'server',
            'specificProject',
            'libraries',
            'net',
            'minecraftforge',
            'forge',
            '1.18.2-40.1.30',
            'win_args.txt',
          );
          const cubeProperties = CubeProperties();
          final jarArchiveInfo = JarArchiveInfo(
            type: JarType.forge1182,
            executable: serverExecutable,
          );
          final projectPath = p.join('server', 'specificProject');
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) =>
                convertStringToStream(FORGE_JAVA_FAILURE['content'] as String),
          );
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(FORGE_JAVA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
              expect(e, isA<ServerCloseUnexpectedException>());
            },
            onDone: () {
              completer.complete();
            },
          );

          await completer.future;

          expect(isErrorCalled, isTrue);
          expect(collects.join('\n'), equals(FORGE_JAVA_FAILURE['content']));
          final captures = verify(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).captured;
          expect(captures, [
            [
              cubeProperties.java,
              '-Xmx${cubeProperties.xmx}',
              '-Xms${cubeProperties.xms}',
              '@' +
                  p.join(
                    'libraries',
                    'net',
                    'minecraftforge',
                    'forge',
                    '1.18.2-40.1.30',
                    'win_args.txt',
                  ),
              'nogui',
            ],
            true,
            projectPath,
          ]);
        });

        test('return Safe when use java17 on forge without EULA', () async {
          const serverExecutable =
              'libraries/net/minecraftforge/forge/1.18.2-40.1.30/win_args.txt';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.forge1182,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) =>
                convertStringToStream(FORGE_EULA_FAILURE['content'] as String),
          );
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(FORGE_EULA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
            },
            onDone: () {
              completer.complete();
            },
          );

          await completer.future;

          expect(isErrorCalled, isFalse);
          final content = FORGE_EULA_FAILURE['content'] as String;
          expect(
            collects.join('\n'),
            equals(content + '\nSafe Complete!'),
          );
        });

        test('Success when use java17 on forge without EULA', () async {
          const serverExecutable =
              'libraries/net/minecraftforge/forge/1.18.2-40.1.30/win_args.txt';
          const cubeProperties = CubeProperties();
          const jarArchiveInfo = JarArchiveInfo(
            type: JarType.forge1182,
            executable: serverExecutable,
          );
          const projectPath = '/';
          final process = MockProcess();
          when(
            () => processManager.start(
              captureAny(),
              workingDirectory: captureAny(named: 'workingDirectory'),
              runInShell: captureAny(named: 'runInShell'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stderr).thenAnswer(
            (_) => Stream.fromIterable([]),
          );

          final controller = StreamController<List<int>>();
          when(() => process.stdout).thenAnswer((_) async* {
            yield* convertStringToStream(
              FORGE_SUCCESS_PART_A['content'] as String,
            );
            yield* controller.stream;
            yield* convertStringToStream(
              FORGE_SUCCESS_PART_B['content'] as String,
            );
          });

          final mockStdin = MockIOSink();
          when(() => process.stdin).thenReturn(mockStdin);
          when(() => mockStdin.writeln(any(that: startsWith('stop'))))
              .thenAnswer((_) {
            controller.close();
          });
          when(() => mockStdin.writeln(any(that: isNot(startsWith('stop')))))
              .thenAnswer((_) {
            controller.sink.add(FORGE_ECHO.codeUnits);
          });

          when(() => process.exitCode).thenAnswer((_) async {
            await Future.delayed(const Duration(seconds: 2));
            return int.parse(FORGE_EULA_FAILURE['code'] as String);
          });

          final Completer completer = Completer();
          final List<String> collects = [];
          bool isErrorCalled = false;

          repository
              .startServer(
            jarArchiveInfo: jarArchiveInfo,
            projectPath: projectPath,
            cubeProperties: cubeProperties,
          )
              .listen(
            (event) {
              collects.add(event);
            },
            onError: (e) {
              isErrorCalled = true;
            },
            onDone: () {
              completer.complete();
            },
          );

          await Future.delayed(const Duration(seconds: 1));
          repository.inputCommand(command: '123');
          repository.inputCommand(command: 'stop');
          await completer.future;

          expect(isErrorCalled, isFalse);
          expect(
            collects.join('\n'),
            allOf([
              contains(FORGE_ECHO),
              contains(FORGE_SUCCESS_PART_B['content']),
              contains(FORGE_SUCCESS_PART_A['content']),
              endsWith('Safe Complete!'),
            ]),
          );
        });
      });
    });
  });
}

Stream<List<int>> convertStringToStream(String raw) {
  final lines = const LineSplitter().convert(raw);
  final codes = lines.map<List<int>>((e) => e.codeUnits);
  return Stream.fromIterable(codes);
}

// enum ForgeType {
//   javaFailure,
//   eulaFailure,
//   successButFailure,
//   success
// }
// io.Process forgeStream(ForgeType type) {
//   io.Process process = MockProcess();
//   when(() => process.exitCode, )
//   StreamController<String> controller = StreamController.broadcast(sync: );
//   if(type == ForgeType.eulaFailure) {
//     controller.sink.add()
//   }
//   return controller;
// }

// vanilla 1.18
// ignore: constant_identifier_names
const VANILLA_JAVA_FAILURE = {
  'code': '1',
  'content':
      r'''Error: A JNI error has occurred, please check your installation and try again
Exception in thread "main" java.lang.UnsupportedClassVersionError: net/minecraft/bundler/Main has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 52.0
        at java.lang.ClassLoader.defineClass1(Native Method)
        at java.lang.ClassLoader.defineClass(ClassLoader.java:757)
        at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
        at java.net.URLClassLoader.defineClass(URLClassLoader.java:468)
        at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
        at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
        at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
        at java.security.AccessController.doPrivileged(Native Method)
        at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
        at java.lang.ClassLoader.loadClass(ClassLoader.java:419)
        at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:352)
        at java.lang.ClassLoader.loadClass(ClassLoader.java:352)
        at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)''',
};

// ignore: constant_identifier_names
const VANILLA_EULA_FAILURE = {
  'code': '0',
  'content':
      r'''Unpacking 1.18.1/server-1.18.1.jar (versions:1.18.1) to versions\1.18.1\server-1.18.1.jar
Unpacking com/github/oshi/oshi-core/5.8.2/oshi-core-5.8.2.jar (libraries:com.github.oshi:oshi-core:5.8.2) to libraries\com\github\oshi\oshi-core\5.8.2\oshi-core-5.8.2.jar
Unpacking com/google/code/gson/gson/2.8.8/gson-2.8.8.jar (libraries:com.google.code.gson:gson:2.8.8) to libraries\com\google\code\gson\gson\2.8.8\gson-2.8.8.jar
Unpacking com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar (libraries:com.google.guava:failureaccess:1.0.1) to libraries\com\google\guava\failureaccess\1.0.1\failureaccess-1.0.1.jar
Unpacking com/google/guava/guava/31.0.1-jre/guava-31.0.1-jre.jar (libraries:com.google.guava:guava:31.0.1-jre) to libraries\com\google\guava\guava\31.0.1-jre\guava-31.0.1-jre.jar
Unpacking com/mojang/authlib/3.2.38/authlib-3.2.38.jar (libraries:com.mojang:authlib:3.2.38) to libraries\com\mojang\authlib\3.2.38\authlib-3.2.38.jar
Unpacking com/mojang/brigadier/1.0.18/brigadier-1.0.18.jar (libraries:com.mojang:brigadier:1.0.18) to libraries\com\mojang\brigadier\1.0.18\brigadier-1.0.18.jar
Unpacking com/mojang/datafixerupper/4.0.26/datafixerupper-4.0.26.jar (libraries:com.mojang:datafixerupper:4.0.26) to libraries\com\mojang\datafixerupper\4.0.26\datafixerupper-4.0.26.jar
Unpacking com/mojang/javabridge/1.2.24/javabridge-1.2.24.jar (libraries:com.mojang:javabridge:1.2.24) to libraries\com\mojang\javabridge\1.2.24\javabridge-1.2.24.jar
Unpacking commons-io/commons-io/2.11.0/commons-io-2.11.0.jar (libraries:commons-io:commons-io:2.11.0) to libraries\commons-io\commons-io\2.11.0\commons-io-2.11.0.jar
Unpacking io/netty/netty-all/4.1.68.Final/netty-all-4.1.68.Final.jar (libraries:io.netty:netty-all:4.1.68.Final) to libraries\io\netty\netty-all\4.1.68.Final\netty-all-4.1.68.Final.jar
Unpacking it/unimi/dsi/fastutil/8.5.6/fastutil-8.5.6.jar (libraries:it.unimi.dsi:fastutil:8.5.6) to libraries\it\unimi\dsi\fastutil\8.5.6\fastutil-8.5.6.jar
Unpacking net/java/dev/jna/jna/5.9.0/jna-5.9.0.jar (libraries:net.java.dev.jna:jna:5.9.0) to libraries\net\java\dev\jna\jna\5.9.0\jna-5.9.0.jar
Unpacking net/java/dev/jna/jna-platform/5.9.0/jna-platform-5.9.0.jar (libraries:net.java.dev.jna:jna-platform:5.9.0) to libraries\net\java\dev\jna\jna-platform\5.9.0\jna-platform-5.9.0.jar
Unpacking net/sf/jopt-simple/jopt-simple/5.0.4/jopt-simple-5.0.4.jar (libraries:net.sf.jopt-simple:jopt-simple:5.0.4) to libraries\net\sf\jopt-simple\jopt-simple\5.0.4\jopt-simple-5.0.4.jar
Unpacking org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar (libraries:org.apache.commons:commons-lang3:3.12.0) to libraries\org\apache\commons\commons-lang3\3.12.0\commons-lang3-3.12.0.jar
Unpacking org/apache/logging/log4j/log4j-api/2.14.1/log4j-api-2.14.1.jar (libraries:org.apache.logging.log4j:log4j-api:2.14.1) to libraries\org\apache\logging\log4j\log4j-api\2.14.1\log4j-api-2.14.1.jar
Unpacking org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.jar (libraries:org.apache.logging.log4j:log4j-core:2.14.1) to libraries\org\apache\logging\log4j\log4j-core\2.14.1\log4j-core-2.14.1.jar
Unpacking org/apache/logging/log4j/log4j-slf4j18-impl/2.14.1/log4j-slf4j18-impl-2.14.1.jar (libraries:org.apache.logging.log4j:log4j-slf4j18-impl:2.14.1) to libraries\org\apache\logging\log4j\log4j-slf4j18-impl\2.14.1\log4j-slf4j18-impl-2.14.1.jar
Unpacking org/slf4j/slf4j-api/1.8.0-beta4/slf4j-api-1.8.0-beta4.jar (libraries:org.slf4j:slf4j-api:1.8.0-beta4) to libraries\org\slf4j\slf4j-api\1.8.0-beta4\slf4j-api-1.8.0-beta4.jar
Starting net.minecraft.server.Main
[00:12:55] [ServerMain/ERROR]: Failed to load properties from file: server.properties
[00:12:55] [ServerMain/WARN]: Failed to load eula.txt
[00:12:55] [ServerMain/INFO]: You need to agree to the EULA in order to run the server. Go to eula.txt for more info.''',
};
// ignore: constant_identifier_names
const VANILLA_SUCCESS_PART_A = {
  'code': '0',
  'content': r'''Starting net.minecraft.server.Main
[00:15:20] [ServerMain/INFO]: Environment: authHost='https://authserver.mojang.com', accountsHost='https://api.mojang.com', sessionHost='https://sessionserver.mojang.com', servicesHost='https://api.minecraftservices.com', name='PROD'
[00:15:20] [ServerMain/WARN]: Ambiguity between arguments [teleport, location] and [teleport, destination] with inputs: [0.1 -0.5 .9, 0 0 0]
[00:15:20] [ServerMain/WARN]: Ambiguity between arguments [teleport, location] and [teleport, targets] with inputs: [0.1 -0.5 .9, 0 0 0]
[00:15:20] [ServerMain/WARN]: Ambiguity between arguments [teleport, destination] and [teleport, targets] with inputs: [Player, 0123, @e, dd12be42-52a9-4a91-a8a1-11c01849e498]
[00:15:20] [ServerMain/WARN]: Ambiguity between arguments [teleport, targets] and [teleport, destination] with inputs: [Player, 0123, dd12be42-52a9-4a91-a8a1-11c01849e498]
[00:15:20] [ServerMain/WARN]: Ambiguity between arguments [teleport, targets, location] and [teleport, targets, destination] with inputs: [0.1 -0.5 .9, 0 0 0]
[00:15:20] [ServerMain/INFO]: Reloading ResourceManager: Default
[00:15:21] [Worker-Main-10/INFO]: Loaded 7 recipes
[00:15:21] [Worker-Main-10/INFO]: Loaded 1141 advancements
[00:15:23] [Server thread/INFO]: Starting minecraft server version 1.18.1
[00:15:23] [Server thread/INFO]: Loading properties
[00:15:23] [Server thread/INFO]: Default game type: SURVIVAL
[00:15:23] [Server thread/INFO]: Generating keypair
[00:15:23] [Server thread/INFO]: Starting Minecraft server on *:25565
[00:15:23] [Server thread/INFO]: Using default channel type
[00:15:23] [Server thread/INFO]: Preparing level "world"
[00:15:28] [Server thread/INFO]: Preparing start region for dimension minecraft:overworld
[00:15:28] [Worker-Main-8/INFO]: Preparing spawn area: 0%
[00:15:28] [Worker-Main-8/INFO]: Preparing spawn area: 0%
[00:15:29] [Worker-Main-9/INFO]: Preparing spawn area: 0%
[00:15:29] [Worker-Main-9/INFO]: Preparing spawn area: 0%
[00:15:30] [Worker-Main-11/INFO]: Preparing spawn area: 0%
[00:15:30] [Worker-Main-15/INFO]: Preparing spawn area: 1%
[00:15:31] [Worker-Main-16/INFO]: Preparing spawn area: 2%
[00:15:31] [Worker-Main-15/INFO]: Preparing spawn area: 4%
[00:15:32] [Worker-Main-16/INFO]: Preparing spawn area: 5%
[00:15:32] [Worker-Main-15/INFO]: Preparing spawn area: 6%
[00:15:33] [Worker-Main-10/INFO]: Preparing spawn area: 9%
[00:15:33] [Worker-Main-15/INFO]: Preparing spawn area: 10%
[00:15:34] [Worker-Main-10/INFO]: Preparing spawn area: 13%
[00:15:34] [Worker-Main-8/INFO]: Preparing spawn area: 15%
[00:15:35] [Worker-Main-15/INFO]: Preparing spawn area: 17%
[00:15:35] [Worker-Main-9/INFO]: Preparing spawn area: 19%
[00:15:36] [Worker-Main-9/INFO]: Preparing spawn area: 21%
[00:15:36] [Worker-Main-10/INFO]: Preparing spawn area: 23%
[00:15:37] [Worker-Main-11/INFO]: Preparing spawn area: 26%
[00:15:37] [Worker-Main-12/INFO]: Preparing spawn area: 29%
[00:15:38] [Worker-Main-16/INFO]: Preparing spawn area: 31%
[00:15:38] [Worker-Main-12/INFO]: Preparing spawn area: 33%
[00:15:39] [Worker-Main-10/INFO]: Preparing spawn area: 36%
[00:15:39] [Worker-Main-11/INFO]: Preparing spawn area: 39%
[00:15:40] [Worker-Main-11/INFO]: Preparing spawn area: 42%
[00:15:40] [Worker-Main-9/INFO]: Preparing spawn area: 44%
[00:15:41] [Worker-Main-15/INFO]: Preparing spawn area: 46%
[00:15:41] [Worker-Main-15/INFO]: Preparing spawn area: 50%
[00:15:42] [Worker-Main-15/INFO]: Preparing spawn area: 51%
[00:15:42] [Worker-Main-12/INFO]: Preparing spawn area: 54%
[00:15:43] [Worker-Main-12/INFO]: Preparing spawn area: 55%
[00:15:43] [Worker-Main-11/INFO]: Preparing spawn area: 59%
[00:15:44] [Worker-Main-16/INFO]: Preparing spawn area: 61%
[00:15:44] [Worker-Main-12/INFO]: Preparing spawn area: 65%
[00:15:45] [Worker-Main-11/INFO]: Preparing spawn area: 68%
[00:15:45] [Worker-Main-8/INFO]: Preparing spawn area: 70%
[00:15:46] [Worker-Main-9/INFO]: Preparing spawn area: 72%
[00:15:46] [Worker-Main-16/INFO]: Preparing spawn area: 75%
[00:15:47] [Worker-Main-8/INFO]: Preparing spawn area: 79%
[00:15:47] [Worker-Main-10/INFO]: Preparing spawn area: 82%
[00:15:48] [Worker-Main-16/INFO]: Preparing spawn area: 84%
[00:15:48] [Worker-Main-9/INFO]: Preparing spawn area: 87%
[00:15:49] [Worker-Main-11/INFO]: Preparing spawn area: 92%
[00:15:49] [Worker-Main-16/INFO]: Preparing spawn area: 97%
[00:15:49] [Server thread/INFO]: Time elapsed: 21657 ms
[00:15:49] [Server thread/INFO]: Done (25.933s)! For help, type "help"''',
};
// ignore: constant_identifier_names
const VANILLA_ECHO =
    '[00:16:08] [Server thread/INFO]: Unknown or incomplete command, see below for error';
// ignore: constant_identifier_names
const VANILLA_SUCCESS_PART_B = {
  'code': '0',
  'content': r'''[00:16:34] [Server thread/INFO]: Stopping the server
[00:16:34] [Server thread/INFO]: Stopping server
[00:16:34] [Server thread/INFO]: Saving players
[00:16:34] [Server thread/INFO]: Saving worlds
[00:16:34] [Server thread/INFO]: Saving chunks for level 'ServerLevel[world]'/minecraft:overworld
[00:16:34] [Server thread/INFO]: Saving chunks for level 'ServerLevel[world]'/minecraft:the_nether
[00:16:34] [Server thread/INFO]: Saving chunks for level 'ServerLevel[world]'/minecraft:the_end
[00:16:34] [Server thread/INFO]: ThreadedAnvilChunkStorage (world): All chunks are saved
[00:16:34] [Server thread/INFO]: ThreadedAnvilChunkStorage (DIM-1): All chunks are saved
[00:16:34] [Server thread/INFO]: ThreadedAnvilChunkStorage (DIM1): All chunks are saved
[00:16:34] [Server thread/INFO]: ThreadedAnvilChunkStorage: All dimensions are saved''',
};

// forge 1.12
// ignore: constant_identifier_names
const FORGE_JAVA_FAILURE = {
  'code': '1',
  'content':
      r'''A problem occurred running the Server launcher.java.lang.reflect.InvocationTargetException
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:568)
        at net.minecraftforge.fml.relauncher.ServerLaunchWrapper.run(ServerLaunchWrapper.java:70)
        at net.minecraftforge.fml.relauncher.ServerLaunchWrapper.main(ServerLaunchWrapper.java:34)
Caused by: java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader cannot be cast to class java.net.URLClassLoader (jdk.internal.loader.ClassLoaders$AppClassLoader and java.net.URLClassLoader are in module java.base of loader 'bootstrap')
        at net.minecraft.launchwrapper.Launch.<init>(Launch.java:34)''',
};
// ignore: constant_identifier_names
const FORGE_EULA_FAILURE = {
  'code': '0',
  'content':
      r'''2022-02-16 20:26:32,186 main WARN Disabling terminal, you're running in an unsupported environment.
[20:26:32] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.FMLServerTweaker
[20:26:32] [main/INFO] [LaunchWrapper]: Using primary tweak class name net.minecraftforge.fml.common.launcher.FMLServerTweaker
[20:26:32] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLServerTweaker
[20:26:32] [main/INFO] [FML]: Forge Mod Loader version 14.23.5.2860 for Minecraft 1.12.2 loading
[20:26:32] [main/INFO] [FML]: Java is OpenJDK 64-Bit Server VM, version 1.8.0_302, running on Windows 10:amd64:10.0, installed at D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\java\zulu8.56.0.21-ca-jdk8.0.302-win_x64\jre
[20:26:32] [main/INFO] [FML]: Searching D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\server_repository\forge\1.12\.\mods for mods
[20:26:32] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.FMLInjectionAndSortingTweaker
[20:26:32] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.FMLDeobfTweaker
[20:26:32] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLInjectionAndSortingTweaker
[20:26:32] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLInjectionAndSortingTweaker
[20:26:32] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.relauncher.CoreModManager$FMLPluginWrapper
[20:26:34] [main/INFO] [FML]: Found valid fingerprint for Minecraft Forge. Certificate fingerprint e3c3d50c7c986df74c645c0ac54639741c90a557
[20:26:34] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.relauncher.CoreModManager$FMLPluginWrapper
[20:26:34] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLDeobfTweaker
[20:26:34] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.TerminalTweaker
[20:26:34] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.TerminalTweaker
[20:26:34] [main/INFO] [LaunchWrapper]: Launching wrapped minecraft {net.minecraft.server.MinecraftServer}
[20:26:34] [main/WARN] [minecraft/ServerEula]: Failed to load eula.txt
[20:26:34] [main/INFO] [minecraft/MinecraftServer]: You need to agree to the EULA in order to run the server. Go to eula.txt for more info.''',
};
// ignore: constant_identifier_names
const FORGE_SUCCESS_PART_A = {
  'code': '0',
  'content':
      r'''2022-02-16 20:28:01,784 main WARN Disabling terminal, you're running in an unsupported environment.
[20:28:01] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.FMLServerTweaker
[20:28:01] [main/INFO] [LaunchWrapper]: Using primary tweak class name net.minecraftforge.fml.common.launcher.FMLServerTweaker
[20:28:01] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLServerTweaker
[20:28:01] [main/INFO] [FML]: Forge Mod Loader version 14.23.5.2860 for Minecraft 1.12.2 loading
[20:28:01] [main/INFO] [FML]: Java is OpenJDK 64-Bit Server VM, version 1.8.0_302, running on Windows 10:amd64:10.0, installed at D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\java\zulu8.56.0.21-ca-jdk8.0.302-win_x64\jre
[20:28:02] [main/INFO] [FML]: Searching D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\server_repository\forge\1.12\.\mods for mods
[20:28:02] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.FMLInjectionAndSortingTweaker
[20:28:02] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.FMLDeobfTweaker
[20:28:02] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLInjectionAndSortingTweaker
[20:28:02] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLInjectionAndSortingTweaker
[20:28:02] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.relauncher.CoreModManager$FMLPluginWrapper
[20:28:03] [main/INFO] [FML]: Found valid fingerprint for Minecraft Forge. Certificate fingerprint e3c3d50c7c986df74c645c0ac54639741c90a557
[20:28:03] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.relauncher.CoreModManager$FMLPluginWrapper
[20:28:03] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.FMLDeobfTweaker
[20:28:03] [main/INFO] [LaunchWrapper]: Loading tweak class name net.minecraftforge.fml.common.launcher.TerminalTweaker
[20:28:03] [main/INFO] [LaunchWrapper]: Calling tweak class net.minecraftforge.fml.common.launcher.TerminalTweaker
[20:28:03] [main/INFO] [LaunchWrapper]: Launching wrapped minecraft {net.minecraft.server.MinecraftServer}
[20:28:09] [Server thread/INFO] [minecraft/DedicatedServer]: Starting minecraft server version 1.12.2
[20:28:09] [Server thread/INFO] [FML]: MinecraftForge v14.23.5.2860 Initialized
[20:28:09] [Server thread/INFO] [FML]: Starts to replace vanilla recipe ingredients with ore ingredients.
[20:28:09] [Server thread/INFO] [FML]: Invalid recipe found with multiple oredict ingredients in the same ingredient...
[20:28:09] [Server thread/INFO] [FML]: Replaced 1227 ore ingredients
[20:28:09] [Server thread/INFO] [FML]: Config directory created successfully
[20:28:09] [Server thread/INFO] [FML]: Searching D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\server_repository\forge\1.12\.\mods for mods
[20:28:10] [Server thread/INFO] [FML]: Forge Mod Loader has identified 4 mods to load
[20:28:10] [Server thread/WARN] [FML]: Missing English translation for FML: assets/fml/lang/en_us.lang
[20:28:10] [Server thread/INFO] [FML]: Attempting connection with missing mods [minecraft, mcp, FML, forge] at CLIENT
[20:28:10] [Server thread/INFO] [FML]: Attempting connection with missing mods [minecraft, mcp, FML, forge] at SERVER
[20:28:10] [Server thread/INFO] [FML]: Processing ObjectHolder annotations
[20:28:10] [Server thread/INFO] [FML]: Found 1168 ObjectHolder annotations
[20:28:10] [Server thread/INFO] [FML]: Identifying ItemStackHolder annotations
[20:28:10] [Server thread/INFO] [FML]: Found 0 ItemStackHolder annotations
[20:28:11] [Server thread/INFO] [FML]: Configured a dormant chunk cache size of 0
[20:28:11] [Forge Version Check/INFO] [forge.VersionCheck]: [forge] Starting version check at http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json
[20:28:11] [Server thread/INFO] [FML]: Applying holder lookups
[20:28:11] [Server thread/INFO] [FML]: Holder lookups applied
[20:28:11] [Server thread/INFO] [FML]: Applying holder lookups
[20:28:11] [Server thread/INFO] [FML]: Holder lookups applied
[20:28:11] [Server thread/INFO] [FML]: Applying holder lookups
[20:28:11] [Server thread/INFO] [FML]: Holder lookups applied
[20:28:11] [Server thread/INFO] [FML]: Applying holder lookups
[20:28:11] [Server thread/INFO] [FML]: Holder lookups applied
[20:28:11] [Server thread/INFO] [FML]: Injecting itemstacks
[20:28:11] [Server thread/INFO] [FML]: Itemstack injection complete
[20:28:11] [Server thread/INFO] [minecraft/DedicatedServer]: Loading properties
[20:28:11] [Server thread/WARN] [minecraft/PropertyManager]: server.properties does not exist
[20:28:11] [Server thread/INFO] [minecraft/PropertyManager]: Generating new properties file
[20:28:11] [Server thread/INFO] [minecraft/DedicatedServer]: Default game type: SURVIVAL
[20:28:11] [Server thread/INFO] [minecraft/DedicatedServer]: Generating keypair
[20:28:11] [Server thread/INFO] [minecraft/DedicatedServer]: Starting Minecraft server on *:25565
[20:28:11] [Server thread/INFO] [minecraft/NetworkSystem]: Using default channel type
[20:28:11] [Server thread/INFO] [FML]: Applying holder lookups
[20:28:11] [Server thread/INFO] [FML]: Holder lookups applied
[20:28:12] [Server thread/INFO] [FML]: Injecting itemstacks
[20:28:12] [Server thread/INFO] [FML]: Itemstack injection complete
[20:28:12] [Server thread/INFO] [FML]: Forge Mod Loader has successfully loaded 4 mods
[20:28:12] [Server thread/INFO] [minecraft/DedicatedServer]: Preparing level "world"
[20:28:13] [Server thread/INFO] [FML]: Loading dimension 0 (world) (net.minecraft.server.dedicated.DedicatedServer@1ab2c20)
[20:28:13] [Server thread/INFO] [minecraft/AdvancementList]: Loaded 488 advancements
[20:28:14] [Server thread/INFO] [FML]: Loading dimension -1 (world) (net.minecraft.server.dedicated.DedicatedServer@1ab2c20)
[20:28:14] [Server thread/INFO] [FML]: Loading dimension 1 (world) (net.minecraft.server.dedicated.DedicatedServer@1ab2c20)
[20:28:14] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing start region for level 0
[20:28:15] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing spawn area: 9%
[20:28:15] [Forge Version Check/INFO] [forge.VersionCheck]: [forge] Found status: AHEAD Target: null
[20:28:16] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing spawn area: 23%
[20:28:17] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing spawn area: 39%
[20:28:18] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing spawn area: 58%
[20:28:19] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing spawn area: 75%
[20:28:20] [Server thread/INFO] [minecraft/MinecraftServer]: Preparing spawn area: 92%
[20:28:20] [Server thread/INFO] [minecraft/DedicatedServer]: Done (8.631s)! For help, type "help" or "?"
[20:28:21] [Server thread/INFO] [FML]: Unloading dimension -1
[20:28:21] [Server thread/INFO] [FML]: Unloading dimension 1''',
};
// ignore: constant_identifier_names
const FORGE_ECHO =
    '[20:28:59] [Server thread/INFO] [minecraft/DedicatedServer]: Unknown command. Try /help for a list of commands';
// ignore: constant_identifier_names
const FORGE_SUCCESS_PART_B = {
  'code': '0',
  'content':
      r'''[20:29:31] [Server thread/INFO] [minecraft/DedicatedServer]: Stopping the server
[20:29:31] [Server thread/INFO] [minecraft/MinecraftServer]: Stopping server
[20:29:31] [Server thread/INFO] [minecraft/MinecraftServer]: Saving players
[20:29:31] [Server thread/INFO] [minecraft/MinecraftServer]: Saving worlds
[20:29:31] [Server thread/INFO] [minecraft/MinecraftServer]: Saving chunks for level 'world'/overworld
[20:29:31] [Server thread/INFO] [FML]: Unloading dimension 0
[20:29:31] [Server Shutdown Thread/INFO] [minecraft/MinecraftServer]: Stopping server
[20:29:31] [Server Shutdown Thread/INFO] [minecraft/MinecraftServer]: Saving players
[20:29:31] [Server Shutdown Thread/INFO] [minecraft/MinecraftServer]: Saving worlds''',
};
