@Tags(['integration'])

import 'package:path/path.dart' as p;
import 'package:archive/archive.dart';
import 'package:cube_api/src/archive/archive.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utilities/test_utilities.dart';

void main() {
  // Hard to unit test archiver because can't mock Archive with IteratbleBase<E>
  group('Archiver', () {
    late FileSystem fileSystem;
    late ZipDecoder zipDecoder;
    late Archiver archiver;
    setUp(() {
      fileSystem = const LocalFileSystem();
      zipDecoder = ZipDecoder();
      archiver = Archiver(
        zipDecoder: zipDecoder,
        fileSystem: fileSystem,
      );
    });
    group('constructor', () {
      test(
        'instantiates internal fileSystem, zipDecoder when not injected',
        () {
          expect(Archiver(), isNotNull);
        },
      );
    });
    group('unzip', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'archive_it_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });
      test('correct unzip a valid zip file', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );

        final targetPath = p.join(rootPath.path, 'valid');
        await archiver.unzip(
          zipPath: p.join(rootPath.path, 'valid.zip'),
          toPath: targetPath,
        );
        final dirs = fileSystem.directory(targetPath).listSync();
        expect(dirs.length, 1);
      });

      // Seems that package:archive/archive.dart fix chinese name by giving a crash name.
      test('(fixed by archive)throws error when unziping a chinese zip file',
          () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );

        final targetPath = p.join(rootPath.path, 'invalid');
        await archiver.unzip(
          zipPath: p.join(rootPath.path, 'invalid.zip'),
          toPath: targetPath,
        );
        final dirs = fileSystem.directory(targetPath).listSync();
        expect(dirs.length, 1);
      });
    });

    group('validStructureByBytes', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'archive_it_test_1');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test('vanilla file match the predefined structure', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );
        File file = fileSystem.file(p.join(rootPath.path, 'vanilla.jar'));
        expect(
          archiver.validStructureByBytes(
            bytes: await file.readAsBytes(),
            structure: ['net', 'minecraft'],
          ),
          isTrue,
        );
      });
      test('forgeInstaller file match the predefined structure', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );
        File file =
            fileSystem.file(p.join(rootPath.path, 'forge_installer.jar'));
        expect(
          archiver.validStructureByBytes(
            bytes: await file.readAsBytes(),
            structure: [
              'net',
              'minecraftforge',
            ],
          ),
          isTrue,
        );
      });
      test('forge file match the predefined structure', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );
        File file = fileSystem.file(p.join(rootPath.path, 'forge.jar'));
        final bytes = await file.readAsBytes();
        expect(
          archiver.validStructureByBytes(
            bytes: bytes,
            structure: [
              'net',
              'minecraftforge',
            ],
          ),
          isTrue,
        );
        expect(
          archiver.validStructureByBytes(
            bytes: bytes,
            structure: ['log4j2.xml'],
          ),
          isTrue,
        );
      });
    });

    group('validStructure', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'archive_it_test_2');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test('vanilla file match the predefined structure', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );
        expect(
          await archiver.validStructure(
            zipPath: p.join(rootPath.path, 'vanilla.jar'),
            structure: ['net', 'minecraft'],
          ),
          isTrue,
        );
      });
      test('forgeInstaller file match the predefined structure', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );
        expect(
          await archiver.validStructure(
            zipPath: p.join(rootPath.path, 'forge_installer.jar'),
            structure: [
              'net',
              'minecraftforge',
            ],
          ),
          isTrue,
        );
      });
      test('forge file match the predefined structure', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_api', 'archive', 'zip'),
          rootPath.path,
        );
        expect(
          await archiver.validStructure(
            zipPath: p.join(rootPath.path, 'forge.jar'),
            structure: [
              'net',
              'minecraftforge',
            ],
          ),
          isTrue,
        );
        expect(
          await archiver.validStructure(
            zipPath: p.join(rootPath.path, 'forge.jar'),
            structure: ['log4j2.xml'],
          ),
          isTrue,
        );
      });
    });
  });
}
