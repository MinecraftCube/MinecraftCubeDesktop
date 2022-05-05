import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:server_configuration_repository/server_configuration_repository.dart';

class MockFile extends Mock implements File {}

class MockFileSystem extends Mock implements FileSystem {}

void main() {
  group('ServerConfigurationRepository', () {
    late FileSystem fileSystem;
    late ServerConfigurationRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      repository = ServerConfigurationRepository(
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(ServerConfigurationRepository(), isNotNull);
      });
    });

    group('getConfiguration', () {
      test('return null If cube.conf not existed', () async {
        final File file = MockFile();
        when(
          () => fileSystem.file(
            p.join('test', 'cube.conf'),
          ),
        ).thenAnswer((_) => file);
        when(() => file.exists()).thenAnswer((_) async => false);
        expect(
          await repository.getConfiguration(directory: 'test'),
          null,
        );
        final verified = verify(
          () => fileSystem.file(
            p.join('test', 'cube.conf'),
          ),
        );
        verified.called(1);
      });

      test('throws exception when not a valid json.', () async {
        final File file = MockFile();
        when(
          () => fileSystem.file(
            p.join('test', 'cube.conf'),
          ),
        ).thenAnswer((_) => file);
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.readAsString()).thenAnswer((_) async => '123');
        expect(
          repository.getConfiguration(directory: 'test'),
          throwsA(isA<TypeError>()),
        );
      });

      test('return correct ServerConfiguration.', () async {
        final File file = MockFile();
        when(
          () => fileSystem.file(
            p.join('test', 'cube.conf'),
          ),
        ).thenAnswer((_) => file);
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.readAsString()).thenAnswer((_) async => serverConfRaw);
        expect(
          await repository.getConfiguration(directory: 'test'),
          const ServerConfiguration(isAgreeDangerous: false),
        );
      });
    });

    group('saveConfiguration', () {
      test('save correct data', () async {
        File file = MockFile();
        when(() => fileSystem.file(captureAny())).thenAnswer((_) => file);
        when(() => file.create(recursive: true)).thenAnswer((_) async => file);
        when(() => file.writeAsString(captureAny()))
            .thenAnswer((_) async => file);
        await repository.saveConfiguration(
          directory: 'test',
          configuration: const ServerConfiguration(isAgreeDangerous: true),
        );
        final fileCaptured =
            verify(() => fileSystem.file(captureAny())).captured;
        final writeCaptured =
            verify(() => file.writeAsString(captureAny())).captured;

        expect(fileCaptured.last, p.join('test', 'cube.conf'));
        expect(
          writeCaptured.last,
          allOf([
            contains('isAgreeDangerous'),
            contains('true'),
          ]),
        );
      });
    });
  });
}

const serverConfRaw = '{"isAgreeDangerous": false}';
