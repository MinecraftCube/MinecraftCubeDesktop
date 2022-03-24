import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CubeProperties cubeProperties;
  group('CubeProperties', () {
    setUp(() {
      cubeProperties = const CubeProperties();
    });
    group('constructor', () {
      test('instantiates default java value', () {
        expect(
          const CubeProperties(),
          const CubeProperties(xms: '256m', xmx: '4g', java: 'java'),
        );
      });
    });

    group('fromProperty (CubeProperties.fromProperty)', () {
      test('return default CubeProperties when no file or empty file',
          () async {
        expect(
          const CubeProperties().fromProperty(
            properties: [],
          ),
          const CubeProperties(),
        );
      });

      test('return correct CubeProperties with mocked part data', () async {
        expect(
          cubeProperties.fromProperty(
            properties: [
              const Property(name: 'Xmx', value: '16g'),
            ],
          ),
          const CubeProperties(xmx: '16g'),
        );
      });

      test('return correct CubeProperties with mocked full data', () async {
        expect(
          cubeProperties.fromProperty(
            properties: const [
              Property(name: 'xmx', value: '16g'),
              Property(name: 'xms', value: '2m'),
              Property(name: 'java', value: '87java'),
            ],
          ),
          const CubeProperties(xmx: '16g', xms: '2m', java: '87java'),
        );
      });
    });

    group('toStgring', () {
      test('match default string', () {
        expect(
          cubeProperties.toString(),
          allOf([
            matches(RegExp('xmx=4g', caseSensitive: false)),
            matches(RegExp('xms=256m', caseSensitive: false)),
            matches(RegExp('java=java', caseSensitive: false))
          ]),
        );
      });

      test('match specified string', () {
        expect(
          const CubeProperties(java: '87java', xms: '16g', xmx: '32g')
              .toString(),
          allOf([
            matches(RegExp('xmx=32g', caseSensitive: false)),
            matches(RegExp('xms=16g', caseSensitive: false)),
            matches(RegExp('java=87java', caseSensitive: false))
          ]),
        );
      });
    });
    // group('writeToFile', () {
    //   test('write default data', () async {
    //     File file = MockFile();
    //     when(() => file.create(recursive: true)).thenAnswer((_) async => file);
    //     when(() => file.writeAsString(captureAny()))
    //         .thenAnswer((_) async => file);
    //     await cubeProperties.writeToFile(file);
    //     final captured =
    //         verify(() => file.writeAsString(captureAny())).captured;
    //     expect(
    //       captured.last,
    //       allOf([
    //         matches(RegExp('xmx=4g', caseSensitive: false)),
    //         matches(RegExp('xms=256m', caseSensitive: false)),
    //         matches(RegExp('java=java', caseSensitive: false))
    //       ]),
    //     );
    //   });

    //   test('write specified data', () async {
    //     File file = MockFile();
    //     when(() => file.create(recursive: true)).thenAnswer((_) async => file);
    //     when(() => file.writeAsString(captureAny()))
    //         .thenAnswer((_) async => file);
    //     cubeProperties = const CubeProperties(
    //       xms: '8g',
    //       xmx: '2g',
    //       java: 'java/bin/java.exe',
    //     );
    //     await cubeProperties.writeToFile(file);
    //     final captured =
    //         verify(() => file.writeAsString(captureAny())).captured;
    //     expect(
    //       captured.last,
    //       allOf([
    //         matches(RegExp('xmx=2g', caseSensitive: false)),
    //         matches(RegExp('xms=8g', caseSensitive: false)),
    //         matches(RegExp('java=java/bin/java.exe', caseSensitive: false))
    //       ]),
    //     );
    //   });
    // });
  });
}
