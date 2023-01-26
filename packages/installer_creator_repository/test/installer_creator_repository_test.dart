// ignore_for_file: unnecessary_string_escapes

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

void main() {
  group('InstallerCreatorRepository', () {
    late FileSystem fileSystem;
    late InstallerCreatorRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
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
      test('Throws exception when create file failure', () async {
        final file = MockFile();
        when(() => fileSystem.file(p.join('installers', '$name.dmc')))
            .thenReturn(file);
        when(() => file.create(recursive: true)).thenThrow(Exception());
        await expectLater(
          repository.create(
            name: name,
            description: description,
            server: server,
            type: type,
            map: map,
            settings: settings,
            pack: pack,
          ),
          throwsException,
        );
        verify(() => fileSystem.file(p.join('installers', '$name.dmc')))
            .called(1);
        verify(() => file.create(recursive: true)).called(1);
      });

      test('Throws exception when writeAsString file failure', () async {
        final file = MockFile();
        when(() => fileSystem.file(p.join('installers', '$name.dmc')))
            .thenReturn(file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsString(captureAny())).thenThrow(Exception());
        await expectLater(
          repository.create(
            name: name,
            description: description,
            server: server,
            type: type,
            map: map,
            settings: settings,
            pack: pack,
          ),
          throwsException,
        );
        final captured =
            verify(() => file.writeAsString(captureAny())).captured;
        expect(
          captured.last,
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

      test('return normally', () async {
        final file = MockFile();
        when(() => fileSystem.file(p.join('installers', '$name.dmc')))
            .thenReturn(file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        await expectLater(
          repository.create(
            name: name,
            description: description,
            server: server,
            type: type,
            map: map,
            settings: settings,
            pack: pack,
          ),
          completes,
        );
      });

      test('return normally in subfolder', () async {
        const subfolder = '123';
        final file = MockFile();
        when(
          () => fileSystem.file(
            p.join('installers', subfolder, '$name.dmc'),
          ),
        ).thenReturn(file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        await expectLater(
          repository.create(
            name: name,
            description: description,
            server: server,
            type: type,
            map: map,
            settings: settings,
            pack: pack,
            subfolder: subfolder,
          ),
          completes,
        );

        verify(
          () => fileSystem.file(p.join('installers', subfolder, '$name.dmc')),
        ).called(1);
      });
    });
  });
}
