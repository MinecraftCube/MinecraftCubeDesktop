@Tags(['integration'])
@Timeout(Duration(minutes: 3))

import 'dart:async';

import 'dart:io' as io;

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:process/process.dart';
import 'package:server_repository/server_repository.dart';
import 'package:test_utilities/test_utilities.dart';

import 'consts.dart';

/// This integration test need setup ENVIRONMENT variables.
/// For manuals with vscode...
///{
/// "dart.env": {
///   "ENABLE_FLUTTER_DESKTOP": true,
///   "DART_TEST_RESOURCES": "D:\\Project\\McDedicatedServer\\minecraft_scepter_desktop\\resources",
///   "JAVA_VERSION": "pass",
///   "JAVA_8": "D:\\Project\\McDedicatedServer\\minecraft_scepter_desktop\\java\\zulu8.56.0.21-ca-jdk8.0.302-win_x64\\bin\\java.exe",
///   "JAVA_17": "java" // my dev machine java is 17
/// },
/// "terminal.integrated.env.windows": {
///   "PATH": "D:\\Library\\flutter\\.pub-cache\\bin;C:\\Windows\\System32;C:\\Windows\\System32\\WindowsPowerShell\\v1.0;C:\\Program Files\\Git\\bin\\git.exe;C:\\Program Files\\Microsoft VS Code\\bin;C:\\Program Files\\Git\\cmd;C:\\Windows\\System32;${workspaceFolder}\\.fvm\\flutter_sdk\\bin\\cache\\dart-sdk\\bin;${workspaceFolder}\\.fvm\\flutter_sdk\\bin;C:\\Windows\\System32\\wbem;C:\\Program Files\\Common Files\\Oracle\\Java\\javapath;",
///   "PUB_CACHE": ".pub-cache",
///   "DART_TEST_RESOURCES": "D:\\Project\\McDedicatedServer\\minecraft_scepter_desktop\\resources",
///   "JAVA_VERSION": "pass",
///   "JAVA_8": "D:\\Project\\McDedicatedServer\\minecraft_scepter_desktop\\java\\zulu8.56.0.21-ca-jdk8.0.302-win_x64\\bin\\java.exe",
///   "JAVA_17": "java" // my dev machine java is 17
/// },
///     "dart.flutterSdkPath": "${workspaceFolder}\\.fvm\\flutter_sdk",
/// }
///
///
void main() {
  final version = io.Platform.environment[TestEnviroments.javaVersion];
  final java8 = io.Platform.environment[TestEnviroments.java8Path] ?? 'java';
  final java17 = io.Platform.environment[TestEnviroments.java17Path] ?? 'java';
  bool isPass = version == 'pass';
  bool isJava8 = version == '8' || isPass;
  bool isJava17 = version == '17' || isPass;

  // ignore: avoid_print
  // print('$version');
  // ignore: avoid_print
  // print(java8);
  // ignore: avoid_print
  // print(java17);

  group('ServerRepository', () {
    late FileSystem fileSystem;
    late ProcessManager processManager;
    late ServerRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      processManager = const LocalProcessManager();
      repository = ServerRepository(processManager: processManager);
    });

    group('constructor', () {
      test('instantiates internal processManager when not injected', () {
        expect(ServerRepository(), isNotNull);
      });
    });
    final rootPath =
        TestUtilities().getTestProjectDir(name: 'server_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) {
        // await Future.delayed(const Duration(seconds: ));
        await deleteDirectory(rootPath.path);
      }
    });
    group('startServer', () {
      // no idea
      // test('throws Exception when processManager unable to start a process',
      //     () async {
      //   const serverExecutable = 'nothing';
      //   const cubeProperties = CubeProperties();

      //   await expectLater(
      //     repository.startServer(
      //       executable: serverExecutable,
      //       cubeProperties: cubeProperties,
      //     ),
      //     emitsError(isException),
      //   );
      // });

      group(
        'forge 1.12.2',
        () {
          const serverExecutable = 'forge-1.12.2-14.23.5.2860.jar';
          test(
            'throws Exception when use java17 on unsupported forge',
            () async {
              await copyPath(
                p.join(
                  TestUtilities().rootResources,
                  p.join('server_repository', 'forge', '1.12.2'),
                ),
                p.join(rootPath.path),
              );
              final cubeProperties = CubeProperties(java: java17);
              final Completer completer = Completer();
              final List<String> collects = [];
              bool isErrorCalled = false;

              repository
                  .startServer(
                jarArchiveInfo: const JarArchiveInfo(
                  type: JarType.forge,
                  executable: serverExecutable,
                ),
                projectPath: rootPath.path,
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
              expect(
                collects.join('\n'),
                contains(FORGE_JAVA_FAILURE),
              );

              // Not sure why need a 5 secs delay on this case
              await Future.delayed(const Duration(seconds: 5));
            },
            skip: !isJava17,
          );

          test(
            'return Safe when use java8 on forge without EULA',
            () async {
              await copyPath(
                p.join(
                  TestUtilities().rootResources,
                  p.join('server_repository', 'forge', '1.12.2'),
                ),
                p.join(rootPath.path),
              );
              await copyPath(
                p.join(
                  TestUtilities().rootResources,
                  p.join('server_repository', 'files', 'false_eula'),
                ),
                p.join(rootPath.path),
              );
              final cubeProperties = CubeProperties(java: java8);
              final Completer completer = Completer();
              final List<String> collects = [];
              bool isErrorCalled = false;

              repository
                  .startServer(
                jarArchiveInfo: const JarArchiveInfo(
                  type: JarType.forge,
                  executable: serverExecutable,
                ),
                projectPath: rootPath.path,
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
              expect(
                collects.join('\n'),
                allOf([
                  contains(FORGE_EULA_FAILURE),
                  contains('\nSafe Complete!'),
                ]),
              );
            },
            skip: !isJava8,
          );

          test('Success when use java8 on forge', () async {
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'forge', '1.12.2'),
              ),
              p.join(rootPath.path),
            );
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'files', 'true_eula'),
              ),
              p.join(rootPath.path),
            );
            final cubeProperties = CubeProperties(java: java8);
            final Completer completer = Completer();
            final List<String> collects = [];
            bool isErrorCalled = false;

            repository
                .startServer(
              jarArchiveInfo: const JarArchiveInfo(
                type: JarType.forge,
                executable: serverExecutable,
              ),
              projectPath: rootPath.path,
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
                contains(FORGE_SUCCESS_PART_B),
                contains(FORGE_SUCCESS_PART_A),
                endsWith('Safe Complete!'),
              ]),
            );
          });
        },
        skip: !isJava8,
      );

      group('vanilla 1.18', () {
        const serverExecutable = 'server.jar';
        test(
          'throws Exception when use java8',
          () async {
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'vanilla', '1.18'),
              ),
              p.join(rootPath.path),
            );
            final cubeProperties = CubeProperties(java: java8);
            final Completer completer = Completer();
            final List<String> collects = [];
            bool isErrorCalled = false;

            repository
                .startServer(
              jarArchiveInfo: const JarArchiveInfo(
                type: JarType.vanilla,
                executable: serverExecutable,
              ),
              projectPath: rootPath.path,
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
            expect(
              collects.join('\n'),
              contains(VANILLA_JAVA_FAILURE),
            );

            // Not sure why need a 5 secs delay on this case
            await Future.delayed(const Duration(seconds: 5));
          },
          skip: !isJava8,
        );

        test(
          'return Safe when use java17 on forge without EULA',
          () async {
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'vanilla', '1.18'),
              ),
              p.join(rootPath.path),
            );
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'files', 'false_eula'),
              ),
              p.join(rootPath.path),
            );
            final cubeProperties = CubeProperties(java: java17);
            final Completer completer = Completer();
            final List<String> collects = [];
            bool isErrorCalled = false;

            repository
                .startServer(
              jarArchiveInfo: const JarArchiveInfo(
                type: JarType.vanilla,
                executable: serverExecutable,
              ),
              projectPath: rootPath.path,
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
            expect(
              collects.join('\n'),
              allOf([
                contains(VANILLA_EULA_FAILURE),
                contains('\nSafe Complete!'),
              ]),
            );
          },
          skip: !isJava17,
        );

        test(
          'Success when use java17',
          () async {
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'vanilla', '1.18'),
              ),
              p.join(rootPath.path),
            );
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'files', 'true_eula'),
              ),
              p.join(rootPath.path),
            );
            final cubeProperties = CubeProperties(java: java17);
            final Completer completer = Completer();
            final List<String> collects = [];
            bool isErrorCalled = false;

            repository
                .startServer(
              jarArchiveInfo: const JarArchiveInfo(
                type: JarType.vanilla,
                executable: serverExecutable,
              ),
              projectPath: rootPath.path,
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
                contains(VANILLA_SUCCESS_PART_B),
                contains(VANILLA_SUCCESS_PART_A),
                endsWith('Safe Complete!'),
              ]),
            );
          },
          skip: !isJava17,
          timeout: const Timeout(Duration(seconds: 180)),
        );
      });

      group(
        'forge 1.18.2+',
        () {
          final serverExecutable = p.join(
            'libraries',
            'net',
            'minecraftforge',
            'forge',
            '1.18.2-40.1.30',
            (io.Platform.isWindows ? 'win_args.txt' : 'unix_args.txt'),
          );
          test(
            'throws Exception when use java8 on unsupported forge',
            () async {
              await copyPath(
                p.join(
                  TestUtilities().rootResources,
                  p.join('server_repository', 'forge', '1.18.2'),
                ),
                p.join(rootPath.path),
              );
              final cubeProperties = CubeProperties(java: java8);
              final Completer completer = Completer();
              final List<String> collects = [];
              bool isErrorCalled = false;

              repository
                  .startServer(
                jarArchiveInfo: JarArchiveInfo(
                  type: JarType.forge1182,
                  executable: serverExecutable,
                ),
                projectPath: rootPath.path,
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
              expect(
                collects.join('\n'),
                // contains(RegExp(r'@.*_args.txt')),
                anyOf(
                  contains('FormatException'), // Not english
                  contains(
                    'unix_args.txt',
                  ), // Error: Could not find or load main class @libraries.net.minecraftforge.forge.1.18.2-40.1.30.unix_args.txt\n
                  contains(
                    'win_args.txt',
                  ), // Error: Could not find or load main class @libraries.net.minecraftforge.forge.1.18.2-40.1.30.win_args.txt\n
                ),
              );

              // Not sure why need a 5 secs delay on this case
              await Future.delayed(const Duration(seconds: 5));
            },
            skip: !isJava8,
          );

          test(
            'return Safe when use java17 on forge without EULA',
            () async {
              await copyPath(
                p.join(
                  TestUtilities().rootResources,
                  p.join('server_repository', 'forge', '1.18.2'),
                ),
                p.join(rootPath.path),
              );
              await copyPath(
                p.join(
                  TestUtilities().rootResources,
                  p.join('server_repository', 'files', 'false_eula'),
                ),
                p.join(rootPath.path),
              );
              final cubeProperties = CubeProperties(java: java17);
              final Completer completer = Completer();
              final List<String> collects = [];
              bool isErrorCalled = false;

              repository
                  .startServer(
                jarArchiveInfo: JarArchiveInfo(
                  type: JarType.forge1182,
                  executable: serverExecutable,
                ),
                projectPath: rootPath.path,
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
              expect(
                collects.join('\n'),
                allOf([
                  contains(FORGE_EULA_FAILURE),
                  contains('\nSafe Complete!'),
                ]),
              );
            },
            skip: !isJava17,
          );

          test('Success when use java17 on forge', () async {
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'forge', '1.18.2'),
              ),
              p.join(rootPath.path),
            );
            await copyPath(
              p.join(
                TestUtilities().rootResources,
                p.join('server_repository', 'files', 'true_eula'),
              ),
              p.join(rootPath.path),
            );
            final cubeProperties = CubeProperties(java: java17);
            final Completer completer = Completer();
            final List<String> collects = [];
            bool isErrorCalled = false;

            repository
                .startServer(
              jarArchiveInfo: JarArchiveInfo(
                type: JarType.forge1182,
                executable: serverExecutable,
              ),
              projectPath: rootPath.path,
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
                contains('Unknown or incomplete command, see below for error'),
                contains(FORGE_SUCCESS_PART_B),
                contains('For help, type "help"'),
                endsWith('Safe Complete!'),
              ]),
            );
          });
        },
        skip: !isJava17,
      );
    });
  });
}

// vanilla 1.18
// ignore: constant_identifier_names
const VANILLA_JAVA_FAILURE = 'Error: A JNI error has occurred';
// ignore: constant_identifier_names
const VANILLA_EULA_FAILURE =
    'You need to agree to the EULA in order to run the server. Go to eula.txt for more info.';
// ignore: constant_identifier_names
const VANILLA_SUCCESS_PART_A = r'For help, type "help"';
// ignore: constant_identifier_names
const VANILLA_ECHO = 'Unknown or incomplete command, see below for error';
// ignore: constant_identifier_names
const VANILLA_SUCCESS_PART_B = 'All dimensions are saved';
// forge 1.12
// ignore: constant_identifier_names
const FORGE_JAVA_FAILURE = 'A problem occurred running the Server';
// ignore: constant_identifier_names
const FORGE_EULA_FAILURE =
    'You need to agree to the EULA in order to run the server. Go to eula.txt for more info.';
// ignore: constant_identifier_names
const FORGE_SUCCESS_PART_A = 'For help, type "help" or "?"';
// ignore: constant_identifier_names
const FORGE_ECHO = 'Unknown command. Try /help for a list of commands';
// ignore: constant_identifier_names
const FORGE_SUCCESS_PART_B = 'Saving worlds';
