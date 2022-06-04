@Tags(['integration'])
import 'dart:async';

import 'package:cube_api/cube_api.dart';
import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

// ignore: constant_identifier_names
const PORT = 60001;
// ignore: non_constant_identifier_names
final RESOURCE_PATH =
    p.join(TestUtilities().rootResources, 'installer_repository');
void main() {
  late TestResourceServer server;
  setUpAll(() async {
    server = TestResourceServer(PORT, RESOURCE_PATH);
    await server.init();
  });

  tearDownAll(() async {
    await server.dispose();
  });
  group('InstallerRepository', () {
    late Archiver archiver;
    late Dio dio;
    late FileSystem fileSystem;
    late InstallerRepository repository;

    setUp(() {
      dio = Dio();
      fileSystem = const LocalFileSystem();
      archiver = Archiver(fileSystem: fileSystem);
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

    final rootPath =
        TestUtilities().getTestProjectDir(name: 'installer_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });

    group('getProjectDir', () {
      test('get Directory correctly', () async {
        const projectName = 'PROJECT_NAME';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        expect(
          repository.getProjectDir(projectName).path,
          projectPath,
          // p.join(rootPath.path, projectPath),
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
        expect(
          await repository.createProject(projectName: projectName),
          projectPath,
        );
        expect(await fileSystem.directory(projectPath).exists(), isTrue);
      });
    });

    group('installServer', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'invalid-path-vanilla.jar';
        final url = server.getUrl(filename);
        expect(
          repository.installServer(projectName: projectName, url: url),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'invalid-path-vanilla.jar';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];

        await repository.createProject(projectName: projectName);
        repository.installServer(projectName: projectName, url: url).listen(
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
        expect(
          await fileSystem.file(p.join(projectPath, filename)).exists(),
          isFalse,
        );
      });

      test('emits SetupStatus with correct order', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'vanilla.jar';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );

        await repository.createProject(projectName: projectName);
        await expectLater(
          repository.installServer(projectName: projectName, url: url),
          emitsInOrder([SetupStatus.download, SetupStatus.complete]),
        );
        expect(
          await fileSystem.file(p.join(projectPath, 'server.jar')).exists(),
          isTrue,
        );
      });
    });

    group('installMap', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'map.zip';
        final url = server.getUrl(filename);
        expect(
          repository.installMap(projectName: projectName, url: url),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'no_map.zip';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );
        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        await repository.createProject(projectName: projectName);
        repository
            .installMap(projectName: projectName, url: '${url}corrupted_url')
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
        expect(
          await fileSystem
              .file(p.join(projectPath, 'tempMap', 'map.zip'))
              .exists(),
          isFalse,
        );
      });

      test('throws Exception on unzip failure', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'corrupted_zip.zip';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );
        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        await repository.createProject(projectName: projectName);
        repository.installMap(projectName: projectName, url: url).listen(
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
        expect(collects, [SetupStatus.download, SetupStatus.extract]);
        expect(
          await fileSystem
              .file(p.join(projectPath, 'tempMap', 'map.zip'))
              .exists(),
          isTrue,
        );
        expect(
          await fileSystem.directory(p.join(projectPath, 'world')).exists(),
          isFalse,
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'server.properties'))
              .exists(),
          isFalse,
        );
      });

      test('emits SetupStatus on correct order', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'map.zip';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );
        await repository.createProject(projectName: projectName);
        await expectLater(
          repository.installMap(projectName: projectName, url: url),
          emitsInOrder([
            SetupStatus.download,
            SetupStatus.extract,
            SetupStatus.complete,
          ]),
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'tempMap', 'map.zip'))
              .exists(),
          isTrue,
        );
        expect(
          await fileSystem.directory(p.join(projectPath, 'world')).exists(),
          isTrue,
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'server.properties'))
              .exists(),
          isTrue,
        );
      });
    });

    group('installMod', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'mod.jar';
        final url = server.getUrl(filename);
        const modName = 'cube_node';

        expect(
          repository.installMod(
            projectName: projectName,
            url: url,
            modName: modName,
          ),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'invalid-mod.jar';
        final url = server.getUrl(filename);
        const modName = 'cube_node.jar';
        final projectPath = p.join(
          'servers',
          projectName,
        );

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        await repository.createProject(projectName: projectName);
        repository
            .installMod(
              projectName: projectName,
              url: url,
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
        expect(
          await fileSystem.file(p.join(projectPath, 'mods', modName)).exists(),
          isFalse,
        );
      });
      test('emits SetupStatus on correct order', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'mod.jar';
        final url = server.getUrl(filename);
        const modName = 'cube_node.jar';
        final projectPath = p.join(
          'servers',
          projectName,
        );
        await repository.createProject(projectName: projectName);
        await expectLater(
          repository.installMod(
            projectName: projectName,
            url: url,
            modName: modName,
          ),
          emitsInOrder([
            SetupStatus.download,
            SetupStatus.complete,
          ]),
        );
        expect(
          await fileSystem.file(p.join(projectPath, 'mods', modName)).exists(),
          isTrue,
        );
      });
    });

    group('installModpack', () {
      test('throws MissingProjectFolderException for unexpected missing folder',
          () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'mods.zip';
        final url = server.getUrl(filename);

        expect(
          repository.installModpack(
            projectName: projectName,
            url: url,
          ),
          emitsError(isA<MissingProjectFolderException>()),
        );
      });

      test('throws Exception on downloading failure', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'invalid-mods.zip';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        await repository.createProject(projectName: projectName);
        repository
            .installModpack(
              projectName: projectName,
              url: url,
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
        expect(
          await fileSystem
              .file(p.join(projectPath, 'tempMods', 'mods.zip'))
              .exists(),
          isFalse,
        );
      });

      test('throws Exception on unzip failure', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'corrupted_zip.zip';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );

        Completer completer = Completer();
        bool onErrorCalled = false;
        final List<SetupStatus> collects = [];
        await repository.createProject(projectName: projectName);
        repository.installModpack(projectName: projectName, url: url).listen(
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
        expect(collects, [SetupStatus.download, SetupStatus.extract]);
        expect(
          await fileSystem
              .file(p.join(projectPath, 'tempMods', 'mods.zip'))
              .exists(),
          isTrue,
        );
        expect(
          await fileSystem.directory(p.join(projectPath, 'mods')).exists(),
          isFalse,
        );
      });
      test('emits SetupStatus on correct order', () async {
        const projectName = 'PROJECT_NAME';
        const filename = 'mods.zip';
        final url = server.getUrl(filename);
        final projectPath = p.join(
          'servers',
          projectName,
        );
        await repository.createProject(projectName: projectName);
        await expectLater(
          repository.installModpack(
            projectName: projectName,
            url: url,
          ),
          emitsInOrder([
            SetupStatus.download,
            SetupStatus.extract,
            SetupStatus.complete,
          ]),
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'tempMods', 'mods.zip'))
              .exists(),
          isTrue,
        );
        expect(
          await fileSystem.directory(p.join(projectPath, 'mods')).exists(),
          isTrue,
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'mods', 'mod_a.jar'))
              .exists(),
          isTrue,
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'mods', 'mod_b.jar'))
              .exists(),
          isTrue,
        );
        expect(
          await fileSystem
              .file(p.join(projectPath, 'mods', 'mod_c.jar'))
              .exists(),
          isTrue,
        );
      });
    });

    group('copyInstaller', () {
      test('called none on copy when installer not existed', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'installer_repository',
          ),
          p.join(rootPath.path),
        );
        const projectName = 'TEST_A';

        await repository.copyInstaller(
          installerPath: p.join('forge.dmc'),
          projectName: projectName,
        );
        expect(
          await fileSystem
              .file(p.join('servers', 'TEST_A', 'forge.dmc'))
              .exists(),
          isFalse,
        );
      });
      test('called copy', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'installer_repository',
          ),
          p.join(rootPath.path),
        );
        const projectName = 'TEST_A';

        await repository.copyInstaller(
          installerPath: p.join('vanilla.dmc'),
          projectName: projectName,
        );
        expect(
          await fileSystem
              .file(p.join('servers', 'TEST_A', 'vanilla.dmc'))
              .exists(),
          isTrue,
        );
      });
    });
  });
}
