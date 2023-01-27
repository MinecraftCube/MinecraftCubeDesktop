// ignore_for_file: unnecessary_string_escapes

import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_management_repository/server_management_repository.dart';

class MockFile extends Mock implements File {}

class MockDirectory extends Mock implements Directory {}

class MockFileSystem extends Mock implements FileSystem {}

void main() {
  group('ServerManagementRepository', () {
    late FileSystem fileSystem;
    late ServerManagementRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      repository = ServerManagementRepository(
        fileSystem: fileSystem,
        // jarAnalyzerRepository: jarAnalyzerRepository,
      );
    });

    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(ServerManagementRepository(), isNotNull);
      });
    });

    group('createServersDir', () {
      test('call create', () async {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.create(recursive: true)).thenAnswer(
          (_) async => directory,
        );
        when(() => directory.absolute).thenReturn(
          directory,
        );
        when(() => directory.path).thenReturn(
          '/absolute/servers',
        );
        expect(
          await repository.createServersDir(),
          '/absolute/servers',
        );
        final captured =
            verify(() => fileSystem.directory(captureAny())).captured;
        expect(captured.last, 'servers');
        verify(() => directory.create(recursive: true)).called(1);
      });
    });

    group('createInstallersDir', () {
      test('call create', () async {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.create(recursive: true)).thenAnswer(
          (_) async => directory,
        );
        when(() => directory.absolute).thenReturn(
          directory,
        );
        when(() => directory.path).thenReturn(
          '/absolute/installers',
        );
        expect(
          await repository.createInstallersDir(),
          '/absolute/installers',
        );
        final captured =
            verify(() => fileSystem.directory(captureAny())).captured;
        expect(captured.last, 'installers');
        verify(() => directory.create(recursive: true)).called(1);
      });

      test('call create with subfolder', () async {
        const subfolder = '123';
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.create(recursive: true)).thenAnswer(
          (_) async => directory,
        );
        when(() => directory.absolute).thenReturn(
          directory,
        );
        when(() => directory.childDirectory(subfolder)).thenReturn(
          directory,
        );
        when(() => directory.path).thenReturn(
          '/absolute/installers/$subfolder',
        );
        expect(
          await repository.createInstallersDir(subfolder: subfolder),
          '/absolute/installers/$subfolder',
        );
        final captured =
            verify(() => fileSystem.directory(captureAny())).captured;
        expect(captured.last, 'installers');
        verify(() => directory.childDirectory(subfolder)).called(1);
        verify(() => directory.create(recursive: true)).called(1);
      });
    });

    group('getInstallers', () {
      test('emit nothing when no installers folder', () async {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => false);
        expect(repository.getInstallers(), emitsDone);
      });
      test('emit nothing when no file', () async {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([]));
        expect(repository.getInstallers(), emitsDone);
      });

      test('emit nothing when file corrupted', () async {
        Directory directory = MockDirectory();
        File file = MockFile();
        final installerRaw = jsonEncode(
          const Installer('a', 'b', JarType.vanilla, 'd').toJson(),
        );
        final corruptedInstallerRaw = installerRaw.replaceFirst('{', '');
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([file]));
        when(() => file.readAsString()).thenAnswer(
          (_) async => corruptedInstallerRaw,
        );
        expect(repository.getInstallers(), emitsDone);
      });

      test('emit [installerFile] with correct installer', () async {
        Directory directory = MockDirectory();
        File file = MockFile();
        final installerRaw = jsonEncode(
          const Installer('a', 'b', JarType.vanilla, 'd').toJson(),
        );
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list(recursive: true))
            .thenAnswer((_) => Stream.fromIterable([file]));
        when(() => file.readAsString()).thenAnswer(
          (_) async => installerRaw,
        );
        when(() => file.path).thenReturn('installers/file.dmc');
        expect(
          repository.getInstallers(),
          emitsInOrder([
            const InstallerFile(
              installer: Installer('a', 'b', JarType.vanilla, 'd'),
              path: 'installers/file.dmc',
            )
          ]),
        );
      });
    });

    group('getServers', () {
      test('emit nothing when no servers folder', () async {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => false);
        expect(repository.getServers(), emitsDone);
      });
      test('emit nothing when no sub-directory', () async {
        Directory directory = MockDirectory();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list()).thenAnswer((_) => Stream.fromIterable([]));
        expect(repository.getServers(), emitsDone);
      });

      test('emit nothing when server not found', () async {
        Directory directory = MockDirectory();
        Directory corruptedContainDir = MockDirectory();
        File corruptedFileA = MockFile();
        File corruptedFileB = MockFile();
        File corruptedFileC = MockFile();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list())
            .thenAnswer((_) => Stream.fromIterable([corruptedContainDir]));
        when(() => corruptedContainDir.path).thenReturn('testSub');
        when(() => corruptedContainDir.list()).thenAnswer(
          (_) => Stream.fromIterable([
            corruptedFileA,
            corruptedFileB,
            corruptedFileC,
          ]),
        );
        when(() => corruptedFileA.path).thenReturn('another.jar.');
        when(() => corruptedFileB.path).thenReturn('jar.come.b');
        when(() => corruptedFileC.path).thenReturn('aaa.badjar');
        expect(repository.getServers(), emitsDone);
      });

      test('emit [projectPath] with correct servers', () async {
        Directory directory = MockDirectory();
        Directory containDirA = MockDirectory();
        Directory containDirB = MockDirectory();
        Directory containDirC = MockDirectory();
        File fileA = MockFile();
        File fileB = MockFile();
        File fileC = MockFile();
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list()).thenAnswer(
          (_) => Stream.fromIterable([containDirA, containDirB, containDirC]),
        );
        when(() => containDirA.path).thenReturn('testSub');
        when(() => containDirB.path).thenReturn('GOOD');
        when(() => containDirC.path).thenReturn('Linux');
        when(() => containDirA.list()).thenAnswer(
          (_) => Stream.fromIterable([
            fileA,
          ]),
        );
        when(() => containDirB.list()).thenAnswer(
          (_) => Stream.fromIterable([
            fileA,
          ]),
        );
        when(() => containDirC.list()).thenAnswer(
          (_) => Stream.fromIterable([
            fileA,
          ]),
        );
        when(() => fileA.path).thenReturn('server.jar');
        when(() => fileB.path).thenReturn('bbbb\\server.jar');
        when(() => fileC.path).thenReturn('cccc/server.jar');
        expect(
          repository.getServers(),
          emitsInOrder(
            ['testSub', 'GOOD', 'Linux'],
          ),
        );
      });
    });
  });
}
