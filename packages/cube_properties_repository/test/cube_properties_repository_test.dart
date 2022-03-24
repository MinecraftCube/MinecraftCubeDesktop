import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockFile extends Mock implements File {}

class MockFileSystem extends Mock implements FileSystem {}

class MockPropertyManager extends Mock implements PropertyManager {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockFile());
  });
  group('CubePropertiesRepository', () {
    late FileSystem fileSystem;
    late PropertyManager propertyManager;
    late CubePropertiesRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      propertyManager = MockPropertyManager();
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

    group('getProperties', () {
      test('call loadProperty', () async {
        when(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        await expectLater(
          repository.getProperties(directory: 'test'),
          emitsInOrder([]),
        );
        final verified = verify(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        );
        verified.called(1);
        expect(verified.captured.last, p.join('test', 'cube.properties'));
      });

      test('return 2 results', () async {
        when(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        ).thenAnswer(
          (_) => Stream.fromIterable(const [
            Property(name: 'a', value: 'a'),
            Property(name: 'b', value: 'b'),
          ]),
        );
        await expectLater(
          repository.getProperties(directory: 'test'),
          emitsInOrder(const [
            Property(name: 'a', value: 'a'),
            Property(name: 'b', value: 'b'),
          ]),
        );
      });
    });

    group('getCubeProperties', () {
      test('return default CubeProperties and call loadProperty when not found',
          () async {
        when(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        expect(
          await repository.getCubeProperties(directory: 'test'),
          const CubeProperties(),
        );
        final verified = verify(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        );
        verified.called(1);
        expect(verified.captured.last, p.join('test', 'cube.properties'));
      });

      test('return custom CubeProperties', () async {
        when(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        ).thenAnswer(
          (_) => Stream.fromIterable(const [
            Property(name: 'java', value: 'jav78'),
            Property(name: 'xmx', value: '16g'),
          ]),
        );
        expectLater(
          await repository.getCubeProperties(directory: 'test'),
          const CubeProperties(java: 'jav78', xmx: '16g'),
        );
      });
    });

    group('saveProperties', () {
      test('call writeAsString', () async {
        File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenReturn(file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        await repository.saveProperties(
          directory: 'test',
          properties: [],
        );
        final fileCaptured =
            verify(() => fileSystem.file(captureAny())).captured;
        final fileWriteVerify = verify(() => file.writeAsString(captureAny()));
        fileWriteVerify.called(1);

        expect(
          fileWriteVerify.captured.last,
          allOf([
            contains('Minecraft cube properties (Managed by MinecraftCube'),
          ]),
        );
        expect(fileCaptured.last, p.join('test', 'cube.properties'));
      });

      test('call writeAsString, and write correctly', () async {
        File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenReturn(file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        await repository.saveProperties(
          directory: 'test',
          properties: const [
            Property(name: 'java', value: 'jv8'),
            Property(name: 'xmx', value: '16g'),
            Property(name: 'xms', value: '2g')
          ],
        );
        final fileCaptured =
            verify(() => fileSystem.file(captureAny())).captured;
        final fileWriteVerify = verify(() => file.writeAsString(captureAny()));
        fileWriteVerify.called(1);

        expect(
          fileWriteVerify.captured.last,
          allOf([
            contains('Minecraft cube properties (Managed by MinecraftCube'),
            contains('java=jv8'),
            contains('xmx=16g'),
            contains('xms=2g'),
          ]),
        );
        expect(fileCaptured.last, p.join('test', 'cube.properties'));
      });
    });
  });
}
