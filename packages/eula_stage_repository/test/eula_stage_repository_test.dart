import 'package:eula_stage_repository/eula_stage_repository.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

const trueRaw = '''
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Wed Dec 01 15:35:54 CST 2021
eula=true
''';
const falseRaw = '''
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Wed Dec 01 15:35:54 CST 2021
eula=false
''';

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

// ignore: non_constant_identifier_names
final EulaReg = RegExp(r'^eula=true\ *$', multiLine: true);

void main() {
  group('EulaStageRepository', () {
    late FileSystem fileSystem;
    late EulaStageRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      repository = EulaStageRepository(
        fileSystem: fileSystem,
      );
    });

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(EulaStageRepository(), isNotNull);
      });
    });

    group('checkEulaAt', () {
      const notDirPath = 'not_a_dir';
      const emptyDirPath = 'emptyDir';
      const eulaDirPath = 'eula';
      test(
        'return false when there is no directory',
        () async {
          final unexistedDir = MockDirectory();

          when(() => unexistedDir.exists()).thenAnswer((_) async => false);
          when(() => fileSystem.directory(notDirPath)).thenReturn(unexistedDir);

          expect(await repository.checkEulaAt(folder: notDirPath), false);

          verify(() => fileSystem.directory(notDirPath)).called(1);
          verify(() => unexistedDir.exists()).called(1);
        },
      );
      test(
        'return false when there is a directory, but no eula file',
        () async {
          final emptyDir = MockDirectory();
          final noFile = MockFile();

          when(() => emptyDir.exists()).thenAnswer((_) async => true);
          when(() => fileSystem.directory(emptyDirPath)).thenReturn(emptyDir);
          when(() => noFile.exists()).thenAnswer((_) async => false);
          when(() => fileSystem.file(p.join(emptyDirPath, 'eula.txt')))
              .thenReturn(noFile);

          expect(await repository.checkEulaAt(folder: emptyDirPath), false);

          verify(() => fileSystem.directory(emptyDirPath)).called(1);
          verify(() => fileSystem.file(p.join(emptyDirPath, 'eula.txt')))
              .called(1);
          verify(() => noFile.exists()).called(1);
        },
      );
      test(
        'return false when eula file is false',
        () async {
          final eulaFalseFile = MockFile();
          final eulaDir = MockDirectory();
          when(() => eulaDir.exists()).thenAnswer((_) async => true);
          when(() => fileSystem.directory(eulaDirPath)).thenReturn(eulaDir);
          when(() => eulaFalseFile.exists()).thenAnswer((_) async => true);
          when(() => eulaFalseFile.readAsString())
              .thenAnswer((_) async => falseRaw);
          when(() => fileSystem.file(p.join(eulaDirPath, 'eula.txt')))
              .thenReturn(eulaFalseFile);

          expect(await repository.checkEulaAt(folder: eulaDirPath), false);

          verify(() => eulaDir.exists()).called(1);
          verify(() => fileSystem.directory(eulaDirPath)).called(1);
          verify(() => fileSystem.file(p.join(eulaDirPath, 'eula.txt')))
              .called(1);
          verify(() => eulaFalseFile.exists()).called(1);
          verify(() => eulaFalseFile.readAsString()).called(1);
        },
      );
      test(
        'return true when eula file is true',
        () async {
          final eulaTrueFile = MockFile();
          final eulaDir = MockDirectory();
          when(() => eulaDir.exists()).thenAnswer((_) async => true);
          when(() => fileSystem.directory(eulaDirPath)).thenReturn(eulaDir);
          when(() => eulaTrueFile.exists()).thenAnswer((_) async => true);
          when(() => eulaTrueFile.readAsString())
              .thenAnswer((_) async => trueRaw);
          when(() => fileSystem.file(p.join(eulaDirPath, 'eula.txt')))
              .thenReturn(eulaTrueFile);

          expect(await repository.checkEulaAt(folder: eulaDirPath), true);

          verify(() => eulaDir.exists()).called(1);
          verify(() => fileSystem.directory(eulaDirPath)).called(1);
          verify(() => fileSystem.file(p.join(eulaDirPath, 'eula.txt')))
              .called(1);
          verify(() => eulaTrueFile.exists()).called(1);
          verify(() => eulaTrueFile.readAsString()).called(1);
        },
      );
    });

    group('writeEulaAt', () {
      test('create directory when non-existent and eula.txt on that directory',
          () async {
        const rootPath = 'eulaDirPath';
        final Directory root = MockDirectory();
        final File eula = MockFile();
        when(() => root.exists()).thenAnswer((_) async => false);
        when(() => root.create(recursive: any(named: 'recursive')))
            .thenAnswer((_) async => root);
        when(() => fileSystem.directory(rootPath)).thenReturn(root);
        when(() => fileSystem.file(p.join(rootPath, 'eula.txt')))
            .thenReturn(eula);
        when(() => eula.create()).thenAnswer((_) async => eula);
        when(() => eula.writeAsString(captureAny()))
            .thenAnswer((_) async => eula);

        await repository.writeEulaAt(folder: rootPath);
        expect(
          verify(() => eula.writeAsString(captureAny())).captured.single,
          matches(EulaReg),
        );
      });

      test('write eula.txt on the specified/existed directory', () async {
        const rootPath = 'eulaDirPath';
        final Directory root = MockDirectory();
        final File eula = MockFile();
        when(() => root.exists()).thenAnswer((_) async => true);
        when(() => fileSystem.directory(rootPath)).thenReturn(root);
        when(() => fileSystem.file(p.join(rootPath, 'eula.txt')))
            .thenReturn(eula);
        when(() => eula.create()).thenAnswer((_) async => eula);
        when(() => eula.writeAsString(captureAny()))
            .thenAnswer((_) async => eula);

        await repository.writeEulaAt(folder: rootPath);
        expect(
          verify(() => eula.writeAsString(captureAny())).captured.single,
          matches(EulaReg),
        );
      });

      // no need to test this since file.create() left untouch on existed file.
      // test('overwrite eula.txt on existed folder', () async {
      //   const rootPath = 'eulaDirPath';
      //   final Directory root = MockDirectory();
      //   final File eula = MockFile();
      //   when(() => root.exists()).thenAnswer((_) async => true);
      //   when(() => fileSystem.directory(rootPath)).thenReturn(root);
      //   when(() => fileSystem.file(p.join(rootPath, 'eula.txt')))
      //       .thenReturn(eula);
      //   when(() => eula.create()).thenAnswer((_) async => eula);
      //   when(() => eula.writeAsString(captureAny()))
      //       .thenAnswer((_) async => eula);

      //   await repository.writeEulaAt(folder: rootPath);
      //   expect(
      //     verify(() => eula.writeAsString(captureAny())).captured.single,
      //     matches(EulaReg),
      //   );
      // });

      // ignore: todo
      // TODO: test for permission denied
    });
  });
}
