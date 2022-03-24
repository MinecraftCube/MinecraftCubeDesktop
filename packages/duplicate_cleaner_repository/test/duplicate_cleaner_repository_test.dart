import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart';

import 'package:duplicate_cleaner_repository/duplicate_cleaner_repository.dart';

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockFileSystemEntity extends Mock implements FileSystemEntity {}

// issue: https://github.com/felangel/mocktail/issues/109
void main() {
  group('DuplicateCleanerRepository', () {
    late FileSystem fileSystem;
    late DuplicateCleanerRepository repository;

    setUp(
      () {
        fileSystem = MockFileSystem();
        repository = DuplicateCleanerRepository(
          fileSystem: fileSystem,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(DuplicateCleanerRepository(), isNotNull);
      });
    });

    group('deleteCubeJava', () {
      const rootPath = 'rootPath';
      late List<File> mockFiles;
      setUp(() {
        File validPathMockFileA = MockFile();
        when(() => validPathMockFileA.path)
            .thenReturn(join('bin', 'cube_java'));
        when(validPathMockFileA.delete)
            .thenAnswer((_) async => MockFileSystemEntity());

        File validPathMockFileB = MockFile();
        when(() => validPathMockFileB.path).thenReturn(
          join('files', 'sadljkhaslsa9dqy_AS', 'bin', 'cube_java'),
        );
        when(validPathMockFileB.delete)
            .thenAnswer((_) async => MockFileSystemEntity());

        File validPathMockFileC = MockFile();
        when(() => validPathMockFileC.path)
            .thenReturn(join('bin', 'cube_java_8178271'));
        when(validPathMockFileC.delete)
            .thenAnswer((_) async => MockFileSystemEntity());

        File validPathMockFileD = MockFile();
        when(() => validPathMockFileD.path)
            .thenReturn(join('bin', 'cube_java_8178271.exe'));
        when(validPathMockFileD.delete)
            .thenAnswer((_) async => MockFileSystemEntity());

        File invalidPathMockFileE = MockFile();
        when(() => invalidPathMockFileE.path)
            .thenReturn(join('bin', 'cube_java', 'afaker'));
        when(invalidPathMockFileE.delete)
            .thenAnswer((_) async => MockFileSystemEntity());

        mockFiles = [
          validPathMockFileA,
          validPathMockFileB,
          validPathMockFileC,
          validPathMockFileD,
          invalidPathMockFileE
        ];
      });

      test(
        'call nothing when there is no directory',
        () async {
          Directory rootDir = MockDirectory();
          Directory javaDir = MockDirectory();
          when(() => rootDir.path).thenReturn(rootPath);
          when(() => javaDir.exists()).thenAnswer((_) async => false);
          when(() => javaDir.list()).thenAnswer((_) async* {});
          when(() => fileSystem.currentDirectory).thenReturn(rootDir);
          when(
            () => fileSystem.directory(
              join(rootPath, repository.JAVA_PORTABLE_FOLDER),
            ),
          ).thenReturn(javaDir);

          await repository.deleteCubeJava();
          verifyNever(() => javaDir.list(recursive: true));
        },
      );

      test(
        'call delete on correct files',
        () async {
          Directory rootDir = MockDirectory();
          Directory javaDir = MockDirectory();
          when(() => rootDir.path).thenReturn(rootPath);
          when(() => javaDir.exists()).thenAnswer((_) async => true);
          when(() => javaDir.list(recursive: true)).thenAnswer((_) async* {
            yield* Stream.fromIterable(mockFiles);
          });
          when(() => fileSystem.currentDirectory).thenReturn(rootDir);
          when(
            () => fileSystem.directory(
              join(rootPath, repository.JAVA_PORTABLE_FOLDER),
            ),
          ).thenReturn(javaDir);

          await repository.deleteCubeJava();

          verify(
            () => fileSystem.directory(
              join(rootDir.path, repository.JAVA_PORTABLE_FOLDER),
            ),
          );
          verify(() => mockFiles[0].delete()).called(1);
          verify(() => mockFiles[1].delete()).called(1);
          verify(() => mockFiles[2].delete()).called(1);
          verify(() => mockFiles[3].delete()).called(1);
          verifyNever(() => mockFiles[4].delete());
        },
      );
    });
  });
}
