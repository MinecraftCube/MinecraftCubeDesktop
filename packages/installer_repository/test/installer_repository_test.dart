// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

import 'package:cube_api/cube_api.dart';
import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockArchiver extends Mock implements Archiver {}

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('InstallerRepository', () {
    late Archiver archiver;
    late Dio dio;
    late FileSystem fileSystem;
    late InstallerRepository repository;

    setUp(() {
      archiver = MockArchiver();
      dio = MockDio();
      fileSystem = MockFileSystem();
      repository = InstallerRepository(
        archiver: archiver,
        dio: dio,
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates internal processManager when not injected', () {
        expect(InstallerRepository(), isNotNull);
      });
    });

    group('getProjectDir', () {
      test('get Directory correctly', () async {
        const projectName = 'PROJECT_NAME';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        expect(
          repository.getProjectDir(projectName),
          projectDir,
        );
      });
    });

    group('createProject', () {
      test('return path correctly', () async {
        const projectName = 'PROJECT_NAME';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.create(recursive: true))
            .thenAnswer((_) async => projectDir);
        when(() => projectDir.path).thenReturn(projectPath);

        expect(
          await repository.createProject(projectName: projectName),
          projectPath,
        );
        verify(() => projectDir.create(recursive: true)).called(1);
      });
    });

    group('installServer', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc.com';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => false);

        expect(
          repository.installServer(projectName: projectName, url: fakeUrl),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc.com';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenThrow(DioError(requestOptions: RequestOptions(path: 'TEST')));

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        repository.installServer(projectName: projectName, url: fakeUrl).listen(
              (event) {
                collects.add(event);
              },
              onDone: () => completer.complete(),
              onError: (e) {
                onErrorCalled = true;
                expect(e, isException);
              },
            );

        await completer.future;
        expect(onErrorCalled, isTrue);
        expect(collects, [SetupStatus.download]);
      });

      test('emits SetupStatus with correct order', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc.com';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenAnswer((_) async => MockResponse());

        await expectLater(
          repository.installServer(projectName: projectName, url: fakeUrl),
          emitsInOrder([SetupStatus.download, SetupStatus.complete]),
        );

        final captured =
            verify(() => dio.download(captureAny(), captureAny())).captured;
        expect(
          captured[0],
          fakeUrl,
        );
        expect(
          captured[1],
          equals(p.join(projectPath, 'server.jar')),
        );
      });
    });

    group('installMap', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => false);

        expect(
          repository.installMap(projectName: projectName, url: fakeUrl),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenThrow(DioError(requestOptions: RequestOptions(path: 'TEST')));

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        repository.installMap(projectName: projectName, url: fakeUrl).listen(
              (event) {
                collects.add(event);
              },
              onDone: () => completer.complete(),
              onError: (e) {
                onErrorCalled = true;
                expect(e, isException);
              },
            );

        await completer.future;
        expect(onErrorCalled, isTrue);
        expect(collects, [SetupStatus.download]);
      });

      test('throws Exception on unzip failure', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        Exception exception = Exception();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenAnswer((_) async => MockResponse());
        when(
          () => archiver.unzip(
            zipPath: captureAny(named: 'zipPath'),
            toPath: captureAny(named: 'toPath'),
          ),
        ).thenThrow(exception);

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        repository.installMap(projectName: projectName, url: fakeUrl).listen(
              (event) {
                collects.add(event);
              },
              onDone: () => completer.complete(),
              onError: (e) {
                onErrorCalled = true;
                expect(e, isException);
                expect(e, equals(exception));
              },
            );

        await completer.future;
        expect(onErrorCalled, isTrue);
        expect(collects, [SetupStatus.download, SetupStatus.extract]);

        final captured =
            verify(() => dio.download(captureAny(), captureAny())).captured;
        expect(
          captured,
          [fakeUrl, p.join(projectPath, 'tempMap', 'map.zip')],
        );
        final archiverCaptured = verify(
          () => archiver.unzip(
            zipPath: captureAny(named: 'zipPath'),
            toPath: captureAny(named: 'toPath'),
          ),
        ).captured;
        expect(
          archiverCaptured,
          [p.join(projectPath, 'tempMap', 'map.zip'), projectPath],
        );
      });

      test('emits SetupStatus on correct order', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenAnswer((_) async => MockResponse());
        when(
          () => archiver.unzip(
            zipPath: captureAny(named: 'zipPath'),
            toPath: captureAny(named: 'toPath'),
          ),
        ).thenAnswer((_) async {});

        expect(
          repository.installMap(projectName: projectName, url: fakeUrl),
          emitsInOrder([
            SetupStatus.download,
            SetupStatus.extract,
            SetupStatus.complete,
          ]),
        );
      });
    });

    group('installMod', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        const modName = 'cube_node';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => false);

        expect(
          repository.installMod(
            projectName: projectName,
            url: fakeUrl,
            modName: modName,
          ),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        const modName = 'cube_node';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenThrow(DioError(requestOptions: RequestOptions(path: 'TEST')));

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        repository
            .installMod(
              projectName: projectName,
              url: fakeUrl,
              modName: modName,
            )
            .listen(
              (event) {
                collects.add(event);
              },
              onDone: () => completer.complete(),
              onError: (e) {
                onErrorCalled = true;
                expect(e, isException);
              },
            );

        await completer.future;
        expect(onErrorCalled, isTrue);
        expect(collects, [SetupStatus.download]);
        final captured =
            verify(() => dio.download(captureAny(), captureAny())).captured;
        expect(
          captured,
          [fakeUrl, p.join(projectPath, 'mods', modName)],
        );
      });
      test('emits SetupStatus on correct order', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        const modName = 'cube_node';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenAnswer((_) async => MockResponse());

        await expectLater(
          repository.installMod(
            projectName: projectName,
            url: fakeUrl,
            modName: modName,
          ),
          emitsInOrder([
            SetupStatus.download,
            SetupStatus.complete,
          ]),
        );
        final captured =
            verify(() => dio.download(captureAny(), captureAny())).captured;
        expect(
          captured,
          [fakeUrl, p.join(projectPath, 'mods', modName)],
        );
      });
    });

    group('installModpack', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => false);

        expect(
          repository.installModpack(
            projectName: projectName,
            url: fakeUrl,
          ),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenThrow(DioError(requestOptions: RequestOptions(path: 'TEST')));

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        repository
            .installModpack(
              projectName: projectName,
              url: fakeUrl,
            )
            .listen(
              (event) {
                collects.add(event);
              },
              onDone: () => completer.complete(),
              onError: (e) {
                onErrorCalled = true;
                expect(e, isException);
              },
            );

        await completer.future;
        expect(onErrorCalled, isTrue);
        expect(collects, [SetupStatus.download]);
        final captured =
            verify(() => dio.download(captureAny(), captureAny())).captured;
        expect(
          captured,
          [fakeUrl, p.join(projectPath, 'tempMods', 'mods.zip')],
        );
      });

      test('throws Exception on unzip failure', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        Exception exception = Exception();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenAnswer((_) async => MockResponse());
        when(
          () => archiver.unzip(
            zipPath: captureAny(named: 'zipPath'),
            toPath: captureAny(named: 'toPath'),
          ),
        ).thenThrow(exception);

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        repository
            .installModpack(projectName: projectName, url: fakeUrl)
            .listen(
              (event) {
                collects.add(event);
              },
              onDone: () => completer.complete(),
              onError: (e) {
                onErrorCalled = true;
                expect(e, isException);
                expect(e, equals(exception));
              },
            );

        await completer.future;
        expect(onErrorCalled, isTrue);
        expect(collects, [SetupStatus.download, SetupStatus.extract]);
        final captured = verify(
          () => archiver.unzip(
            zipPath: captureAny(named: 'zipPath'),
            toPath: captureAny(named: 'toPath'),
          ),
        ).captured;
        expect(
          captured,
          [
            p.join(projectPath, 'tempMods', 'mods.zip'),
            p.join(projectPath, 'mods'),
          ],
        );
      });
      test('emits SetupStatus on correct order', () async {
        const projectName = 'PROJECT_NAME';
        const fakeUrl = 'https://abc/com.zip';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        MockDirectory projectDir = MockDirectory();
        when(
          () => fileSystem.directory(
            projectPath,
          ),
        ).thenReturn(projectDir);
        when(() => projectDir.exists()).thenAnswer((_) async => true);
        when(
          () => projectDir.path,
        ).thenReturn(projectPath);
        when(() => dio.download(captureAny(), captureAny()))
            .thenAnswer((_) async => MockResponse());
        when(
          () => archiver.unzip(
            zipPath: captureAny(named: 'zipPath'),
            toPath: captureAny(named: 'toPath'),
          ),
        ).thenAnswer((_) async {});

        await expectLater(
          repository.installModpack(
            projectName: projectName,
            url: fakeUrl,
          ),
          emitsInOrder([
            SetupStatus.download,
            SetupStatus.extract,
            SetupStatus.complete,
          ]),
        );
      });
    });

    group('copyInstaller', () {
      test('called none on copy when installer not existed', () async {
        const projectName = 'TEST_A';
        const installerPath = 'resources/a/b.dmc';
        final file = MockFile();
        when(() => fileSystem.file(installerPath)).thenReturn(file);
        when(() => file.basename).thenReturn('b.dmc');
        when(() => file.exists()).thenAnswer((_) async => false);
        when(() => file.copy(captureAny())).thenAnswer((_) async => file);
        await repository.copyInstaller(
          installerPath: 'resources/a/b.dmc',
          projectName: projectName,
        );
        verifyNever(() => file.copy(captureAny()));
      });
      test('called copy', () async {
        const projectName = 'TEST_A';
        const installerPath = 'resources/a/b.dmc';
        final file = MockFile();
        final directory = MockDirectory();
        when(() => fileSystem.file(installerPath)).thenReturn(file);
        when(() => fileSystem.directory(captureAny())).thenReturn(directory);
        when(() => file.basename).thenReturn('b.dmc');
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.copy(captureAny())).thenAnswer((_) async => file);
        when(() => directory.create(recursive: true))
            .thenAnswer((_) async => directory);
        await repository.copyInstaller(
          installerPath: 'resources/a/b.dmc',
          projectName: projectName,
        );
        final capturedDirPath =
            verify(() => fileSystem.directory(captureAny())).captured;
        expect(capturedDirPath.last, p.join('servers', projectName));
        final captured = verify(() => file.copy(captureAny())).captured;
        expect(captured.last, p.join('servers', projectName, 'b.dmc'));
      });
    });
  });
}
