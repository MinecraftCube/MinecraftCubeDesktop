@Tags(['integration'])

import 'dart:io';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('JarAnalyzerRepository', () {
    late FileSystem fileSystem;
    late Archiver archiver;
    late JarAnalyzerRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      archiver = Archiver();
      repository = JarAnalyzerRepository(
        fileSystem: fileSystem,
        archiver: archiver,
      );
    });

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(JarAnalyzerRepository(), isNotNull);
      });
    });

    group('analyzeDirectory', () {
      final rootPath = TestUtilities()
          .getTestProjectDir(name: 'jar_analyzer_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });
      // Add empty dir test
      // test(
      //   'return null when there is no dir',
      //   () async {
      //     expect(
      //       await repository.analyzeDirectory(directory: 'empty'),
      //       isNull,
      //     );
      //   },
      // );
      test(
        'return null when there is nothing in dir',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
            p.join(rootPath.path),
          );

          final targetPath = p.join(rootPath.path, 'empty');
          expect(
            await repository.analyzeDirectory(directory: targetPath),
            isNull,
          );
        },
      );
      test(
        'return vanilla on vanilla dir',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
            p.join(rootPath.path),
          );
          final targetPath = p.join(rootPath.path, 'vanilla');
          expect(
            await repository.analyzeDirectory(directory: targetPath),
            JarArchiveInfo(
              type: JarType.vanilla,
              executable: p.join(targetPath, 'vanilla.jar'),
            ),
          );
        },
      );

      test(
        'return forgeInstaller on uninstall_forge dir',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
            p.join(rootPath.path),
          );
          final targetPath = p.join(rootPath.path, 'uninstall_forge');
          expect(
            await repository.analyzeDirectory(
              directory: targetPath,
              // debugable: true,
            ),
            JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: p.join(targetPath, 'forge_installer.jar'),
            ),
          );
        },
      );

      test(
        'return forge on forge dir',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
            p.join(rootPath.path),
          );
          final targetPath = p.join(rootPath.path, 'forge');
          expect(
            await repository.analyzeDirectory(
              directory: targetPath,
              // debugable: true,
            ),
            JarArchiveInfo(
              type: JarType.forge,
              executable: p.join(targetPath, 'forge.jar'),
            ),
          );
        },
      );

      test(
        'return dangerous on dangerous dir',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
            p.join(rootPath.path),
          );
          final targetPath = p.join(rootPath.path, 'dangerous');
          expect(
            await repository.analyzeDirectory(directory: targetPath),
            JarArchiveInfo(
              type: JarType.unknown,
              executable: p.join(targetPath, 'empty.jar'),
            ),
          );
        },
      );

      group('return forge1182 on forge dir (after 1.18.2)', () {
        test(
          '[windows]',
          () async {
            await copyPath(
              p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
              p.join(rootPath.path),
            );
            final targetPath = p.join(rootPath.path, 'forge_after_1182');
            expect(
              await repository.analyzeDirectory(directory: targetPath),
              JarArchiveInfo(
                type: JarType.forge1182,
                executable: p.join(
                  targetPath,
                  'libraries',
                  'net',
                  'minecraftforge',
                  'forge',
                  '1.18.2-40.1.30',
                  'win_args.txt',
                ),
              ),
            );
          },
          skip: !Platform.isWindows,
        );
        test(
          '[others]',
          () async {
            await copyPath(
              p.join(TestUtilities().rootResources, 'jar_analyzer_repository'),
              p.join(rootPath.path),
            );
            final targetPath = p.join(rootPath.path, 'forge_after_1182');
            expect(
              await repository.analyzeDirectory(directory: targetPath),
              JarArchiveInfo(
                type: JarType.forge1182,
                executable: p.join(
                  targetPath,
                  'libraries',
                  'net',
                  'minecraftforge',
                  'forge',
                  '1.18.2-40.1.30',
                  'unix_args.txt',
                ),
              ),
            );
          },
          skip: Platform.isWindows,
        );
      });
    });
  });
}
