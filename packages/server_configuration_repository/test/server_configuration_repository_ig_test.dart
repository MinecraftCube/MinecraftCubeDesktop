@Tags(['integration'])
import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

import 'package:server_configuration_repository/server_configuration_repository.dart';

void main() {
  group('ServerConfigurationRepository', () {
    late FileSystem fileSystem;
    late ServerConfigurationRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      repository = ServerConfigurationRepository(
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(ServerConfigurationRepository(), isNotNull);
      });
    });

    final rootPath = TestUtilities()
        .getTestProjectDir(name: 'server_configuration_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(ServerConfigurationRepository(), isNotNull);
      });
    });

    group('getConfiguration', () {
      test('return null If cube.conf not existed', () async {
        expect(
          await repository.getConfiguration(directory: 'test'),
          null,
        );
      });

      test('throws exception when not a valid json.', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_configuration_repository',
          ),
          rootPath.path,
        );

        expect(
          repository.getConfiguration(directory: 'corrupted'),
          throwsException,
        );
      });

      test('return correct ServerConfiguration.', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'server_configuration_repository',
          ),
          rootPath.path,
        );

        expect(
          await repository.getConfiguration(directory: 'valid'),
          const ServerConfiguration(isAgreeDangerous: false),
        );
      });
    });

    group('saveConfiguration', () {
      test('save correct data', () async {
        await repository.saveConfiguration(
          directory: 'test',
          configuration: const ServerConfiguration(isAgreeDangerous: true),
        );
        File file = fileSystem.file(p.join('test', 'cube.conf'));
        expect(await file.exists(), isTrue);
        expect(
          await file.readAsString(),
          allOf([
            contains('true'),
            contains('isAgreeDangerous'),
          ]),
        );
      });
    });
  });
}
