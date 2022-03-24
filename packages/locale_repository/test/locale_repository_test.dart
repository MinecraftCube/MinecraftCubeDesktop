import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFile extends Mock implements File {}

class MockPropertyManager extends Mock implements PropertyManager {}

class MockFileSystem extends Mock implements FileSystem {}

void main() {
  group('LocaleRepository', () {
    late PropertyManager propertyManager;
    late FileSystem fileSystem;
    late LocaleRepository repository;

    setUp(() {
      propertyManager = MockPropertyManager();
      fileSystem = MockFileSystem();
      repository = LocaleRepository(
        propertyManager: propertyManager,
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(const LocaleRepository(), isNotNull);
      });
    });

    group('write', () {
      test(
        'call writeAsString on the file',
        () async {
          File mockFile = MockFile();
          when(
            () => fileSystem.file(
              captureAny(),
            ),
          ).thenReturn(mockFile);
          when(
            () => mockFile.create(),
          ).thenAnswer((_) async => mockFile);
          when(
            () => mockFile.writeAsString(captureAny()),
          ).thenAnswer((_) async => mockFile);

          await repository.write(lang: 'ab', country: 'cd');

          final fileCaptured = verify(
            () => fileSystem.file(
              captureAny(),
            ),
          ).captured;
          final fileDataCaptured = verify(
            () => mockFile.writeAsString(captureAny()),
          ).captured;
          expect(
            fileCaptured.last,
            'lang.properties',
          );
          expect(
            fileDataCaptured.last,
            allOf([
              contains('ab'),
              contains('cd'),
            ]),
          );
        },
      );
    });
    group('read', () {
      test(
        'return null without file or empty file',
        () async {
          when(
            () => propertyManager.loadProperty(
              filePath: captureAny(named: 'filePath'),
            ),
          ).thenAnswer((_) => Stream.fromIterable([]));

          expect(
            await repository.read(),
            isNull,
          );

          final captured = verify(
            () => propertyManager.loadProperty(
              filePath: captureAny(named: 'filePath'),
            ),
          ).captured;
          expect(
            captured.last,
            'lang.properties',
          );
        },
      );
      test(
        'return null with wrong data',
        () async {
          when(
            () => propertyManager.loadProperty(
              filePath: captureAny(named: 'filePath'),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              const Property(name: 'language', value: 'nono'),
              const Property(name: 'countrrrr', value: 'nono'),
            ]),
          );

          expect(
            await repository.read(),
            isNull,
          );
        },
      );
      test(
        'return null when missing lang',
        () async {
          when(
            () => propertyManager.loadProperty(
              filePath: captureAny(named: 'filePath'),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              const Property(name: 'country', value: 'TW'),
            ]),
          );

          expect(
            await repository.read(),
            isNull,
          );
        },
      );

      test(
        'return Locale when missing country',
        () async {
          when(
            () => propertyManager.loadProperty(
              filePath: captureAny(named: 'filePath'),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              const Property(name: 'country', value: 'TW'),
            ]),
          );

          expect(
            await repository.read(),
            isNull,
          );
        },
      );

      test(
        'return Locale when full data',
        () async {
          when(
            () => propertyManager.loadProperty(
              filePath: captureAny(named: 'filePath'),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              const Property(name: 'country', value: 'zh'),
              const Property(name: 'country', value: 'TW'),
            ]),
          );

          expect(
            await repository.read(),
            isNull,
          );
        },
      );
    });
  });
}
