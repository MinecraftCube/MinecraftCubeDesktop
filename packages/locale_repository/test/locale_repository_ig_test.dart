@Tags(['integration'])

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('LocaleRepository', () {
    late PropertyManager propertyManager;
    late FileSystem fileSystem;
    late LocaleRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      propertyManager = PropertyManager(fileSystem: fileSystem);
      repository = LocaleRepository(
        propertyManager: propertyManager,
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(const LocaleRepository(), isNotNull);
      });
    });

    final rootPath =
        TestUtilities().getTestProjectDir(name: 'locale_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });

    group('write', () {
      test(
        'call writeAsString on the file',
        () async {
          await repository.write(lang: 'ab', country: 'cd');
          expect(
            await fileSystem.file('lang.properties').exists(),
            isTrue,
          );
          expect(
            await fileSystem.file('lang.properties').readAsString(),
            allOf([
              contains('ab'),
              contains('cd'),
            ]),
          );
        },
      );
    });
    group('read', () {
      test(
        'return null without file or empty file',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'locale_repository', 'empty'),
            rootPath.path,
          );

          expect(
            await repository.read(),
            isNull,
          );
        },
      );
      test(
        'return null with wrong data',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'locale_repository', 'wrong'),
            rootPath.path,
          );
          expect(
            await repository.read(),
            isNull,
          );
        },
      );
      test(
        'return null when missing lang',
        () async {
          await copyPath(
            p.join(
              TestUtilities().rootResources,
              'locale_repository',
              'missingLang',
            ),
            rootPath.path,
          );

          expect(
            await repository.read(),
            isNull,
          );
        },
      );

      test(
        'return Locale when missing country',
        () async {
          await copyPath(
            p.join(
              TestUtilities().rootResources,
              'locale_repository',
              'missingCountry',
            ),
            rootPath.path,
          );

          expect(
            await repository.read(),
            isNotNull,
          );
        },
      );

      test(
        'return Locale when full data',
        () async {
          await copyPath(
            p.join(
              TestUtilities().rootResources,
              'locale_repository',
              'full',
            ),
            rootPath.path,
          );

          expect(
            await repository.read(),
            isNotNull,
          );
        },
      );
    });
  });
}
