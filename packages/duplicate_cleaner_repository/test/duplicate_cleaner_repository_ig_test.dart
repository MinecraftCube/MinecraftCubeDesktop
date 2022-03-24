@Tags(['integration'])

import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' hide equals;

import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('DuplicateCleanerRepository', () {
    late DuplicateCleanerRepository repository;
    late FileSystem fileSystem;

    setUp(
      () {
        fileSystem = const LocalFileSystem();
        repository = DuplicateCleanerRepository(fileSystem: fileSystem);
      },
    );

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(DuplicateCleanerRepository(), isNotNull);
      });
    });

    group('deleteCubeJava', () {
      final rootPath = TestUtilities()
          .getTestProjectDir(name: 'duplicate_cleaner_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test(
        'delete nothing when there is no directory',
        () async {
          await copyPath(
            join(TestUtilities().rootResources, 'duplicate_cleaner_repository'),
            join(rootPath.path, 'java'),
          );
          final dir =
              await io.Directory(join(rootPath.path, 'nothing_there')).create();
          fileSystem.currentDirectory = dir;
          await repository.deleteCubeJava();
          expect(
            io.Directory(join(rootPath.path, 'java', 'bin')).listSync().length,
            equals(3),
          );
        },
      );

      test(
        'delete files',
        () async {
          await copyPath(
            join(TestUtilities().rootResources, 'duplicate_cleaner_repository'),
            join(rootPath.path, 'java'),
          );
          expect(
            io.Directory(
              join(rootPath.path, 'java', 'bin'),
            ).listSync().length,
            equals(3),
          );
          await repository.deleteCubeJava();
          expect(
            io.Directory(join(rootPath.path, 'java', 'bin')).listSync().length,
            equals(0),
          );
        },
      );

      test(
        'delete files even with deeper directory',
        () async {
          await copyPath(
            join(TestUtilities().rootResources, 'duplicate_cleaner_repository'),
            join(rootPath.path, 'java', 'moredeeper', 'andeeeper'),
          );
          expect(
            io.Directory(
              join(rootPath.path, 'java', 'moredeeper', 'andeeeper', 'bin'),
            ).listSync().length,
            equals(3),
          );
          await repository.deleteCubeJava();
          expect(
            io.Directory(
              join(rootPath.path, 'java', 'moredeeper', 'andeeeper', 'bin'),
            ).listSync().length,
            equals(0),
          );
        },
      );
    });
  });
}
