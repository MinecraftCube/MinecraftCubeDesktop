import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:server_properties_repository/server_properties_repository.dart';

class MockFile extends Mock implements File {}

class MockFileSystem extends Mock implements FileSystem {}

class MockPropertyManager extends Mock implements PropertyManager {}

void main() {
  group('ServerPropertiesRepository', () {
    late FileSystem fileSystem;
    late PropertyManager propertyManager;
    late ServerPropertiesRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      propertyManager = MockPropertyManager();
      repository = ServerPropertiesRepository(
        fileSystem: fileSystem,
        propertyManager: propertyManager,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(ServerPropertiesRepository(), isNotNull);
      });
    });

    group('getProperties', () {
      test('call loadPropety', () async {
        when(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        expect(
          repository.getProperties(directory: 'test'),
          emitsDone,
        );
        final verified = verify(
          () => propertyManager.loadProperty(
            filePath: captureAny(named: 'filePath'),
          ),
        );
        verified.called(1);
        expect(verified.captured.last, p.join('test', 'server.properties'));
      });
    });

    group('saveProperties', () {
      test('save correct data', () async {
        File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenAnswer((_) => file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        await repository.saveProperties(
          directory: 'test',
          properties: [
            const Property(name: 'testA', value: 'valueA'),
            const Property(name: 'testB', value: 'valueB'),
            const Property(name: 'testC', value: 'valueC'),
          ],
        );
        final fileCaptured =
            verify(() => fileSystem.file(captureAny())).captured;
        final writeCaptured =
            verify(() => file.writeAsString(captureAny())).captured;

        expect(fileCaptured.last, p.join('test', 'server.properties'));
        expect(
          writeCaptured.last,
          allOf([
            startsWith('# Minecraft'),
            contains('testA'),
            contains('testB'),
            contains('testC'),
            contains('valueA'),
            contains('valueB'),
            contains('valueC'),
          ]),
        );
      });
    });
  });
}
