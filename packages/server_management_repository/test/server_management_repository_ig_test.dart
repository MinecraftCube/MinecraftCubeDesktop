@Tags(['integration'])

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:server_management_repository/server_management_repository.dart';
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('ServerManagementRepository', () {
    // late JarAnalyzerRepository jarAnalyzerRepository;
    late FileSystem fileSystem;
    late ServerManagementRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      // jarAnalyzerRepository = JarAnalyzerRepository(fileSystem: fileSystem);
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

    final rootPath = TestUtilities()
        .getTestProjectDir(name: 'server_management_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });

    group('createServersDir', () {
      test('create servers directory at rootPath', () async {
        expect(
          await fileSystem.directory(p.join(rootPath.path, 'servers')).exists(),
          isFalse,
        );
        expect(
          await repository.createServersDir(),
          p.join(rootPath.path, 'servers'),
        );

        expect(
          await fileSystem.directory(p.join(rootPath.path, 'servers')).exists(),
          isTrue,
        );
      });
    });

    group('createInstallersDir', () {
      test('create installers directory at rootPath', () async {
        expect(
          await fileSystem
              .directory(p.join(rootPath.path, 'installers'))
              .exists(),
          isFalse,
        );
        expect(
          await repository.createInstallersDir(),
          p.join(rootPath.path, 'installers'),
        );

        expect(
          await fileSystem
              .directory(p.join(rootPath.path, 'installers'))
              .exists(),
          isTrue,
        );
      });
    });

    group('getInstallers', () {
      test('emit nothing when no installers folder', () async {
        expect(repository.getInstallers(), emitsDone);
      });
      test('emit nothing when no file', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_management_repository',
            'installers',
            'empty',
          ),
          p.join(rootPath.path, 'installers'),
        );
        expect(repository.getInstallers(), emitsDone);
      });

      test('emit nothing when file corrupted', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_management_repository',
            'installers',
            'corrupted',
          ),
          p.join(rootPath.path, 'installers'),
        );
        expect(repository.getInstallers(), emitsDone);
      });

      test('emit [installerFile] with correct installer', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_management_repository',
            'installers',
            'correct',
          ),
          p.join(rootPath.path, 'installers'),
        );
        expect(
          repository.getInstallers(),
          emitsInOrder([
            InstallerFile(
              installer: const Installer(
                'official_vanilla_1.17',
                '',
                JarType.vanilla,
                'http://localhost:PORT/vanilla_1.17.jar',
                mapZipPath: '',
              ),
              // path: p.join(rootPath.path, 'installers', 'vanilla.dmc'),
              path: p.join('installers', 'vanilla.dmc'),
            )
          ]),
        );
      });
    });
    group('getServers', () {
      test('emit nothing when no servers folder', () async {
        expect(repository.getServers(), emitsDone);
      });
      test('emit nothing when no sub-directory', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_management_repository',
            'servers',
            'empty',
          ),
          p.join(rootPath.path, 'servers'),
        );
        expect(repository.getServers(), emitsDone);
      });

      test('emit nothing when server not found', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_management_repository',
            'servers',
            'noJarInSub',
          ),
          p.join(rootPath.path, 'servers'),
        );
        expect(repository.getServers(), emitsDone);
      });

      test('emit [projectPath] with correct servers', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_management_repository',
            'servers',
            'sub',
          ),
          p.join(rootPath.path, 'servers'),
        );
        expect(
          repository.getServers(),
          emitsInOrder([p.join('servers', 'sub')]),
        );
      });
    });
  });
}
