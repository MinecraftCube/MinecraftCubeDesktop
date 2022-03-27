@Tags(['integration'])
@Timeout(Duration(minutes: 3))
import 'dart:async';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:path/path.dart' as p;
import 'package:process/process.dart';
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('ForgeInstallerRepository', () {
    late FileSystem fileSystem;
    late ProcessManager processManager;
    late ForgeInstallerRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      processManager = const LocalProcessManager();
      repository = ForgeInstallerRepository(
        processManager: processManager,
      );
    });

    group('constructor', () {
      test('instantiates internal processManager when not injected', () {
        expect(ForgeInstallerRepository(), isNotNull);
      });
    });

    group('installForge', () {
      test('return nothing when jarArchiveInfo is type of JarType.forge',
          () async {
        Completer completer = Completer();
        final List<String> collector = [];
        repository
            .installForge(
          javaExecutablePath: 'anything',
          jarArchiveInfo: const JarArchiveInfo(
            type: JarType.forge,
            executable: 'anyhing',
          ),
        )
            .listen(
          (event) {
            collector.add(event);
          },
          onDone: () {
            expect(collector, hasLength(0));
            completer.complete();
          },
        );
        await completer.future;
      });
      test('return nothing when jarArchiveInfo is type of JarType.vanilla',
          () async {
        Completer completer = Completer();
        final List<String> collector = [];
        repository
            .installForge(
          javaExecutablePath: 'anything',
          jarArchiveInfo: const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'anyhing',
          ),
        )
            .listen(
          (event) {
            collector.add(event);
          },
          onDone: () {
            expect(collector, hasLength(0));
            completer.complete();
          },
        );
        await completer.future;
      });
      test('return nothing when jarArchiveInfo is type of JarType.unknown',
          () async {
        Completer completer = Completer();
        final List<String> collector = [];
        repository
            .installForge(
          javaExecutablePath: 'anything',
          jarArchiveInfo: const JarArchiveInfo(
            type: JarType.unknown,
            executable: 'anyhing',
          ),
        )
            .listen(
          (event) {
            collector.add(event);
          },
          onDone: () {
            expect(collector, hasLength(0));
            completer.complete();
          },
        );
        await completer.future;
      });
      group('JarType.forgeInstaller', () {
        final rootPath = TestUtilities()
            .getTestProjectDir(name: 'forge_installer_repository_test');

        setUp(() async {
          await rootPath.create(recursive: true);
          fileSystem.currentDirectory = rootPath;
        });

        tearDown(() async {
          fileSystem.currentDirectory = '/';
          if (await rootPath.exists()) await deleteDirectory(rootPath.path);
        });
        test('call process.start with correct arguments', () async {
          await copyPath(
            p.join(
              TestUtilities().rootResources,
              'forge_installer_repository',
              'forge_1.15.2',
            ),
            p.join(rootPath.path),
          );

          Completer completer = Completer();
          final List<String> collector = [];
          const javaExecutable = 'java';
          final executable =
              p.join(rootPath.path, 'forge_installer_1.15.2.jar');

          repository
              .installForge(
            javaExecutablePath: javaExecutable,
            jarArchiveInfo: JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: executable,
            ),
          )
              .listen(
            (event) {
              collector.add(event);
            },
            onDone: () {
              expect(
                collector.join(''),
                contains('The server installed successfully'),
              );
              Future.delayed(const Duration(seconds: 3), () {
                completer.complete();
              });
            },
          );
          await completer.future;
        });

        test('throw ForgeInstallationException when exitCode not 0', () async {
          Completer completer = Completer();
          final List<String> collector = [];

          await copyPath(
            p.join(
              TestUtilities().rootResources,
              'forge_installer_repository',
              'forge_1.15.2',
            ),
            p.join(rootPath.path),
          );

          const javaExecutable = 'java';
          final executable =
              p.join(rootPath.path, 'forge_installer_1.15.2_no_such_jar.jar');

          repository
              .installForge(
            javaExecutablePath: javaExecutable,
            jarArchiveInfo: JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: executable,
            ),
          )
              .listen(
            (event) {
              collector.add(event);
            },
            onDone: () {
              final fullText = collector.join('\n');
              expect(
                fullText,
                isNot(contains('The server installed successfully')),
              );
              completer.complete();
            },
            onError: (e) {
              expect(e, isA<ForgeInstallationException>());
            },
          );
          await completer.future;
        });
      });
    });
  });
}
