@Tags(['integration'])

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('InstallerCreatorRepository', () {
    late FileSystem fileSystem;
    late InstallerCreatorRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      repository = InstallerCreatorRepository(
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates internal fileSystem when not injected', () {
        expect(const InstallerCreatorRepository(), isNotNull);
      });
    });

    group('create', () {
      final rootPath = TestUtilities()
          .getTestProjectDir(name: 'installer_creator_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      const name = 'TEST_NAME_A';
      const description = 'TEST_DESC_A';
      const server = 'https://server';
      const type = JarType.vanilla;
      const map = 'https://map';
      const settings = [
        ModelSetting(
          name: 'nameA',
          program: 'programA.jar',
          path: 'https://modelA',
        ),
        ModelSetting(
          name: 'nameB',
          program: 'programB.jar',
          path: 'https://modelB',
        ),
        ModelSetting(
          name: 'nameC',
          program: 'programC.jar',
          path: 'https://modelC',
        ),
      ];
      const pack = ModelPack(path: 'https://pack', description: 'packDesc');
      test('return normally', () async {
        final result = await repository.create(
          name: name,
          description: description,
          server: server,
          type: type,
          map: map,
          settings: settings,
          pack: pack,
        );
        expect(
          result.value,
          const Installer(
            name,
            description,
            type,
            server,
            mapZipPath: map,
            modelSettings: settings,
            modelPack: pack,
          ),
        );

        final file = fileSystem.file(p.join('installers', '$name.dmc'));
        expect(result.key, file.absolute.path);
        expect(await file.exists(), isTrue);
        final data = await file.readAsString();
        expect(
          data,
          allOf([
            contains(name),
            contains(description),
            contains(server),
            contains(describeEnum(type)),
            contains(map),
            ...settings.map((s) => contains(s.name)),
            ...settings.map((s) => contains(s.path)),
            ...settings.map((s) => contains(s.program)),
            contains(pack.path),
            contains(pack.description),
          ]),
        );
      });

      test('return normally with subfolder', () async {
        const subfolder = '123';
        final result = await repository.create(
          name: name,
          description: description,
          server: server,
          type: type,
          map: map,
          settings: settings,
          pack: pack,
          subfolder: subfolder,
        );
        expect(
          result.value,
          const Installer(
            name,
            description,
            type,
            server,
            mapZipPath: map,
            modelSettings: settings,
            modelPack: pack,
          ),
        );

        final file =
            fileSystem.file(p.join('installers', subfolder, '$name.dmc'));
        expect(result.key, file.absolute.path);
        expect(await file.exists(), isTrue);
        final data = await file.readAsString();
        expect(
          data,
          allOf([
            contains(name),
            contains(description),
            contains(server),
            contains(describeEnum(type)),
            contains(map),
            ...settings.map((s) => contains(s.name)),
            ...settings.map((s) => contains(s.path)),
            ...settings.map((s) => contains(s.program)),
            contains(pack.path),
            contains(pack.description),
          ]),
        );
      });
    });
  });
}
