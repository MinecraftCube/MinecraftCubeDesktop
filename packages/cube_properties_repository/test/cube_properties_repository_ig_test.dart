@Tags(['integration'])

import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('CubePropertiesRepository', () {
    late FileSystem fileSystem;
    late PropertyManager propertyManager;
    late CubePropertiesRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      propertyManager = const PropertyManager();
      repository = CubePropertiesRepository(
        fileSystem: fileSystem,
        propertyManager: propertyManager,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(CubePropertiesRepository(), isNotNull);
      });
    });

    final rootPath = TestUtilities()
        .getTestProjectDir(name: 'cube_properties_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });
    group('getProperties', () {
      test(
          'return default CubeProperties when there is no cube.properties file',
          () async {
        expect(
          repository.getProperties(directory: 'empty'),
          emitsDone,
        );
      });
      test('return correct cube.properties', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_properties_repository'),
          rootPath.path,
        );
        expect(
          repository.getProperties(directory: 'project'),
          emitsInOrder(const [
            Property(name: 'Xmx', value: '16g'),
            Property(name: 'Xms', value: '128m'),
            Property(name: 'Java', value: 'bin/java'),
          ]),
          // const CubeProperties(xmx: '16g', java: 'bin/java', xms: '128m'),
        );
      });
    });

    group('getCubeProperties', () {
      test(
          'return default CubeProperties when there is no cube.properties file',
          () async {
        expect(
          await repository.getCubeProperties(directory: 'empty'),
          const CubeProperties(),
        );
      });
      test('return correct cube.properties', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'cube_properties_repository'),
          rootPath.path,
        );
        expect(
          await repository.getCubeProperties(directory: 'project'),
          const CubeProperties(
            xms: '128m',
            java: 'bin/java',
            xmx: '16g',
          ),
          // const CubeProperties(xmx: '16g', java: 'bin/java', xms: '128m'),
        );
      });
    });
    group('saveProperties', () {
      test('call cubeProperties.fromfIle', () async {
        await fileSystem.directory('test').create();
        await repository.saveProperties(
          directory: 'test',
          properties: const [
            Property(name: 'Java', value: '123test/java'),
            Property(name: 'Xmx', value: '16g'),
            Property(name: 'Xms', value: '8g'),
          ],
        );
        File file = fileSystem.file(p.join('test', 'cube.properties'));
        expect(await file.exists(), isTrue);
        expect(
          await file.readAsString(),
          allOf([
            startsWith('# Minecraft'),
            contains('Java=123test/java'),
            contains('Xmx=16g'),
            contains('Xms=8g'),
          ]),
        );
      });
    });
  });
}
