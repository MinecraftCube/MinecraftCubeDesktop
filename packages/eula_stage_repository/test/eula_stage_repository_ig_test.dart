@Tags(['integration'])

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

import 'eula_stage_repository_test.dart';

void main() {
  group('EulaStageRepository', () {
    late FileSystem fileSystem;
    late EulaStageRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      repository = EulaStageRepository(
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(EulaStageRepository(), isNotNull);
      });
    });

    group('checkEulaAt', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'eula_stage_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test(
        'return false when there is no directory',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'eula_stage_repository'),
            p.join(rootPath.path),
          );
          expect(
            await repository.checkEulaAt(
              folder: p.join(rootPath.path, 'case_empty', 'no_dir'),
            ),
            false,
          );
        },
      );
      test(
        'return false when there is a directory, but no eula file',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'eula_stage_repository'),
            p.join(rootPath.path),
          );
          expect(
            await repository.checkEulaAt(
              folder: p.join(rootPath.path, 'case_empty'),
            ),
            false,
          );
        },
      );
      test(
        'return false when eula file is false',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'eula_stage_repository'),
            p.join(rootPath.path),
          );
          expect(
            await repository.checkEulaAt(
              folder: p.join(rootPath.path, 'case_false'),
            ),
            false,
          );
        },
      );
      test(
        'return true when eula file is true',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'eula_stage_repository'),
            p.join(rootPath.path),
          );
          expect(
            await repository.checkEulaAt(
              folder: p.join(rootPath.path, 'case_true'),
            ),
            true,
          );
        },
      );
    });

    group('writeEulaAt', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'eula_stage_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test('create directory when non-existent and eula.txt on that directory',
          () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'eula_stage_repository'),
          p.join(rootPath.path),
        );
        await repository.writeEulaAt(
          folder: p.join(rootPath.path, 'case_empty', 'new_project'),
        );
        final file = fileSystem.file(
          p.join(rootPath.path, 'case_empty', 'new_project', 'eula.txt'),
        );
        expect(await file.exists(), true);
        expect(await file.readAsString(), matches(EulaReg));
      });

      test('write eula.txt(false) on the specified/existed directory',
          () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'eula_stage_repository'),
          p.join(rootPath.path),
        );
        await repository.writeEulaAt(
          folder: p.join(rootPath.path, 'case_false'),
        );
        final file =
            fileSystem.file(p.join(rootPath.path, 'case_false', 'eula.txt'));
        expect(await file.exists(), true);
        expect(await file.readAsString(), matches(EulaReg));
      });

      test('write eula.txt(true) on the specified/existed directory', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'eula_stage_repository'),
          p.join(rootPath.path),
        );
        await repository.writeEulaAt(
          folder: p.join(rootPath.path, 'case_true'),
        );
        final file =
            fileSystem.file(p.join(rootPath.path, 'case_true', 'eula.txt'));
        expect(await file.exists(), true);
        expect(await file.readAsString(), matches(EulaReg));
      });
    });
  });
}
