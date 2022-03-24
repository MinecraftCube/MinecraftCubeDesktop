@Tags(['integration'])

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

import 'java_duplicator_repository_test.dart';

void main() {
  group('JavaDuplicatorRepository', () {
    late FileSystem fileSystem;
    late JavaDuplicatorRepository repository;

    setUp(
      () {
        fileSystem = const LocalFileSystem();
        repository = JavaDuplicatorRepository(
          fileSystem: fileSystem,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(JavaDuplicatorRepository(), isNotNull);
      });
    });

    final rootPath = TestUtilities()
        .getTestProjectDir(name: 'java_duplicator_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });

    group('cloneCubeJava', () {
      test(
        'return java when input java',
        () async {
          expect(
            await repository.cloneCubeJava(javaExecutablePath: 'java'),
            equals('java'),
          );
        },
      );

      test(
        'return original parameter when file not found',
        () async {
          final filePath = p.join(rootPath.path, 'java8', 'hi');
          expect(
            await repository.cloneCubeJava(javaExecutablePath: filePath),
            equals(filePath),
          );
        },
      );

      test(
        'return clone cube_java_timestamp when file existed',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'java_duplicator_repository'),
            p.join(rootPath.path),
          );
          final filePath = p.join(rootPath.path, 'java8', 'bin', 'java');
          expect(
            await repository.cloneCubeJava(javaExecutablePath: filePath),
            allOf([
              contains(p.join('java8', 'bin')),
              matches(OtherCubeJavaReg),
            ]),
          );
        },
      );

      test(
        'return clone cube_java_timestamp.exe when file existed',
        () async {
          await copyPath(
            p.join(TestUtilities().rootResources, 'java_duplicator_repository'),
            p.join(rootPath.path),
          );
          final filePath = p.join(rootPath.path, 'java16', 'bin', 'java.exe');
          expect(
            await repository.cloneCubeJava(javaExecutablePath: filePath),
            allOf([
              contains(p.join('java16', 'bin')),
              matches(WindowsCubeJavaReg),
            ]),
          );
        },
      );
    });
  });
}
