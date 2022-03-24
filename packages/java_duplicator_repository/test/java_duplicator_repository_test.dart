import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_duplicator_repository/java_duplicator_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockFileSystemEntity extends Mock implements FileSystemEntity {}

// ignore: non_constant_identifier_names
final OtherCubeJavaReg = RegExp(r'cube_java_\d+');
// ignore: non_constant_identifier_names
final WindowsCubeJavaReg = RegExp(r'cube_java_\d+.exe');
void main() {
  group('JavaDuplicatorRepository', () {
    late FileSystem fileSystem;
    late JavaDuplicatorRepository repository;

    setUp(
      () {
        fileSystem = MockFileSystem();
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
          // might wanna throw error...?
          final javaExecutable = p.join('bin', 'java');
          final javaFile = MockFile();
          when(() => fileSystem.file(javaExecutable)).thenReturn(javaFile);
          when(() => javaFile.exists()).thenAnswer((_) async => false);
          expect(
            await repository.cloneCubeJava(javaExecutablePath: javaExecutable),
            equals(javaExecutable),
          );
        },
      );

      test(
        'return clone cube_java_timestamp when file existed',
        () async {
          final javaExecutable = p.join('java8', 'bin', 'java');
          final javaFile = MockFile();
          final cubeFile = MockFile();
          when(() => fileSystem.file(javaExecutable)).thenReturn(javaFile);
          when(() => javaFile.exists()).thenAnswer((_) async => true);
          when(() => javaFile.copy(captureAny()))
              .thenAnswer((_) async => cubeFile);
          when(() => javaFile.basename).thenReturn('java');
          when(() => javaFile.dirname).thenReturn(p.join('java8', 'bin'));
          final fakeCopied = p.join('java8', 'bin', 'cube_java');
          when(() => cubeFile.absolute).thenReturn(cubeFile);
          when(() => cubeFile.path).thenReturn(fakeCopied);
          expect(
            await repository.cloneCubeJava(javaExecutablePath: javaExecutable),
            equals(fakeCopied),
          );
          final captured = verify(() => javaFile.copy(captureAny())).captured;
          expect(
            captured.last,
            allOf([
              startsWith(p.join('java8', 'bin')),
              matches(OtherCubeJavaReg),
            ]),
          );
        },
      );

      test(
        'return clone cube_java_timestamp.exe when file existed',
        () async {
          final javaExecutable = p.join('java16', 'bin', 'java.exe');
          final javaFile = MockFile();
          final cubeFile = MockFile();
          when(() => fileSystem.file(javaExecutable)).thenReturn(javaFile);
          when(() => javaFile.exists()).thenAnswer((_) async => true);
          when(() => javaFile.copy(captureAny()))
              .thenAnswer((_) async => cubeFile);
          when(() => javaFile.basename).thenReturn('java.exe');
          when(() => javaFile.dirname).thenReturn(p.join('java16', 'bin'));
          final fakeCopied = p.join('java16', 'bin', 'cube_java.exe');
          when(() => cubeFile.absolute).thenReturn(cubeFile);
          when(() => cubeFile.path).thenReturn(fakeCopied);
          expect(
            await repository.cloneCubeJava(javaExecutablePath: javaExecutable),
            equals(fakeCopied),
          );
          final captured = verify(() => javaFile.copy(captureAny())).captured;
          expect(
            captured.last,
            allOf([
              startsWith(p.join('java16', 'bin')),
              matches(WindowsCubeJavaReg),
            ]),
          );
        },
      );
    });
  });
}
