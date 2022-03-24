void main() {}
// @Tags(['integration'])
// import 'package:cube_api/cube_api.dart';
// import 'package:file/file.dart';
// import 'package:file/local.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:path/path.dart' as p;
// import 'package:test_utilities/test_utilities.dart';

// void main() {
//   late CubeProperties cubeProperties;
//   late PropertyManager propertyManager;
//   late FileSystem fileSystem;
//   group('CubeProperties', () {
//     setUp(() {
//       fileSystem = const LocalFileSystem();
//       propertyManager = PropertyManager(fileSystem: fileSystem);
//       cubeProperties = CubeProperties(propertyManager: propertyManager);
//     });
//     group('constructor', () {
//       test('instantiates default java value', () {
//         expect(
//           const CubeProperties(),
//           const CubeProperties(xms: '256m', xmx: '4g', java: 'java'),
//         );
//       });
//     });

//     final rootPath =
//         TestUtilities().getTestProjectDir(name: 'cube_properties_test');

//     setUp(() async {
//       await rootPath.create(recursive: true);
//       fileSystem.currentDirectory = rootPath;
//     });

//     tearDown(() async {
//       fileSystem.currentDirectory = '/';
//       if (await rootPath.exists()) await rootPath.delete(recursive: true);
//     });

//     group('fromFile (CubeProperties.fromFile)', () {
//       test('return default CubeProperties when no file or empty file',
//           () async {
//         await copyPath(
//           p.join(TestUtilities().rootResources, 'cube_api', 'data', 'cube'),
//           rootPath.path,
//         );
//         expect(
//           await const CubeProperties().fromFile(
//             path: 'none.properties',
//           ),
//           const CubeProperties(),
//         );
//       });

//       test('return correct CubeProperties with mocked full data', () async {
//         await copyPath(
//           p.join(TestUtilities().rootResources, 'cube_api', 'data', 'cube'),
//           rootPath.path,
//         );
//         expect(
//           await const CubeProperties().fromFile(
//             path: 'cube.properties',
//           ),
//           const CubeProperties(
//             java: 'bin/java',
//             xms: '128m',
//             xmx: '16g',
//           ),
//         );
//       });
//     });

//     group('writeToFile', () {
//       test('write default data', () async {
//         File file = fileSystem.file('file.properties');
//         await cubeProperties.writeToFile(file);
//         expect(
//           await file.readAsString(),
//           allOf([
//             matches(RegExp('xmx=4g', caseSensitive: false)),
//             matches(RegExp('xms=256m', caseSensitive: false)),
//             matches(RegExp('java=java', caseSensitive: false))
//           ]),
//         );
//       });

//       test('write specified data', () async {
//         File file = fileSystem.file('file.properties');
//         cubeProperties = const CubeProperties(
//           xms: '8g',
//           xmx: '2g',
//           java: 'java/bin/java.exe',
//         );
//         await cubeProperties.writeToFile(file);
//         expect(
//           await file.readAsString(),
//           allOf([
//             matches(RegExp('xmx=2g', caseSensitive: false)),
//             matches(RegExp('xms=8g', caseSensitive: false)),
//             matches(RegExp('java=java/bin/java.exe', caseSensitive: false))
//           ]),
//         );
//       });
//     });
//   });
// }
