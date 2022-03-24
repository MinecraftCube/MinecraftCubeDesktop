import 'dart:typed_data';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockArchiver extends Mock implements Archiver {}

void main() {
  group('JarAnalyzerRepository', () {
    late FileSystem fileSystem;
    late Archiver archiver;
    late JarAnalyzerRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      archiver = MockArchiver();
      repository = JarAnalyzerRepository(
        fileSystem: fileSystem,
        archiver: archiver,
      );
    });

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(JarAnalyzerRepository(), isNotNull);
      });
    });

    group('analyzeDirectory', () {
      test(
        'return null when there is nothing in dir',
        () async {
          final emptyDir = MockDirectory();

          when(() => emptyDir.list())
              .thenAnswer((_) => Stream.fromIterable([])); // No file, Nothing
          when(() => fileSystem.directory('empty')).thenReturn(emptyDir);

          expect(
            await repository.analyzeDirectory(directory: 'empty'),
            isNull,
          );
        },
      );
      test(
        'return vanilla on vanilla dir',
        () async {
          final vanillaDir = MockDirectory();
          final vanillaFile = MockFile();
          final vanillaPath = p.join('vanilla.jar');
          final vanillaByte = Uint8List(1);

          when(() => vanillaFile.basename).thenReturn('vanilla.jar');
          when(() => vanillaFile.path).thenReturn(vanillaPath);
          when(() => vanillaFile.readAsBytes())
              .thenAnswer((_) async => vanillaByte);
          when(
            () => archiver.validStructureByBytes(
              bytes: vanillaByte,
              structure: ['net', 'minecraft'],
            ),
          ).thenReturn(true);
          when(
            () => archiver.validStructureByBytes(
              bytes: vanillaByte,
              structure: [
                'net',
                'minecraftforge',
              ],
            ),
          ).thenReturn(false);
          when(
            () => archiver.validStructureByBytes(
              bytes: vanillaByte,
              structure: ['log4j2.xml'],
            ),
          ).thenReturn(false);

          when(() => vanillaDir.list()).thenAnswer(
            (_) => Stream.fromIterable(
              [
                vanillaFile,
              ],
            ),
          ); // No file, Nothing
          when(() => fileSystem.directory('vanilla')).thenReturn(vanillaDir);

          expect(
            await repository.analyzeDirectory(directory: 'vanilla'),
            JarArchiveInfo(type: JarType.vanilla, executable: vanillaPath),
          );
        },
      );

      test(
        'return forgeInstaller on uninstall_forge dir',
        () async {
          final forgeInstallerDir = MockDirectory();
          final forgeInstallerFile = MockFile();
          final forgeInstallerPath = p.join('forge_installer.jar');
          final forgeInstallerByte = Uint8List(2);

          when(() => forgeInstallerFile.basename)
              .thenReturn('forge_installer.jar');
          when(() => forgeInstallerFile.path).thenReturn(forgeInstallerPath);
          when(() => forgeInstallerFile.readAsBytes())
              .thenAnswer((_) async => forgeInstallerByte);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeInstallerByte,
              structure: ['net', 'minecraft'],
            ),
          ).thenReturn(false);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeInstallerByte,
              structure: [
                'net',
                'minecraftforge',
              ],
            ),
          ).thenReturn(true);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeInstallerByte,
              structure: ['log4j2.xml'],
            ),
          ).thenReturn(false);

          when(() => forgeInstallerDir.list()).thenAnswer(
            (_) => Stream.fromIterable(
              [
                forgeInstallerFile,
              ],
            ),
          ); // No file, Nothing
          when(() => fileSystem.directory('uninstall_forge'))
              .thenReturn(forgeInstallerDir);

          expect(
            await repository.analyzeDirectory(directory: 'uninstall_forge'),
            JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: forgeInstallerPath,
            ),
          );
        },
      );

      test(
        'return forge on forge dir',
        () async {
          final forgeInstallerDir = MockDirectory();
          final forgeInstallerFile = MockFile();
          final forgeInstallerPath = p.join('forge_installer.jar');
          final forgeInstallerByte = Uint8List(2);
          final forgeFile = MockFile();
          final forgePath = p.join('forge.jar');
          final forgeByte = Uint8List(3);

          when(() => forgeInstallerFile.basename)
              .thenReturn('forge_installer.jar');
          when(() => forgeInstallerFile.path).thenReturn(forgeInstallerPath);
          when(() => forgeInstallerFile.readAsBytes())
              .thenAnswer((_) async => forgeInstallerByte);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeInstallerByte,
              structure: ['net', 'minecraft'],
            ),
          ).thenReturn(false);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeInstallerByte,
              structure: [
                'net',
                'minecraftforge',
              ],
            ),
          ).thenReturn(true);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeInstallerByte,
              structure: ['log4j2.xml'],
            ),
          ).thenReturn(false);

          when(() => forgeFile.basename).thenReturn('forge_installer.jar');
          when(() => forgeFile.path).thenReturn(forgePath);
          when(() => forgeFile.readAsBytes())
              .thenAnswer((_) async => forgeByte);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeByte,
              structure: ['net', 'minecraft'],
            ),
          ).thenReturn(false);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeByte,
              structure: [
                'net',
                'minecraftforge',
              ],
            ),
          ).thenReturn(true);
          when(
            () => archiver.validStructureByBytes(
              bytes: forgeByte,
              structure: ['log4j2.xml'],
            ),
          ).thenReturn(true);

          when(() => forgeInstallerDir.list()).thenAnswer(
            (_) => Stream.fromIterable(
              [forgeInstallerFile, forgeFile],
            ),
          ); // No file, Nothing
          when(() => fileSystem.directory('forge'))
              .thenReturn(forgeInstallerDir);

          expect(
            await repository.analyzeDirectory(directory: 'forge'),
            JarArchiveInfo(type: JarType.forge, executable: forgePath),
          );
        },
      );

      test(
        'return dangerous on dangerous dir',
        () async {
          final dangerousDir = MockDirectory();
          final dangerousFile = MockFile();
          final dangerousPath = p.join('dangerous.jar');
          final dangerousByte = Uint8List(1);

          when(() => dangerousFile.basename).thenReturn('dangerous.jar');
          when(() => dangerousFile.path).thenReturn(dangerousPath);
          when(() => dangerousFile.readAsBytes())
              .thenAnswer((_) async => dangerousByte);
          when(
            () => archiver.validStructureByBytes(
              bytes: dangerousByte,
              structure: ['net', 'minecraft'],
            ),
          ).thenReturn(false);
          when(
            () => archiver.validStructureByBytes(
              bytes: dangerousByte,
              structure: [
                'net',
                'minecraftforge',
              ],
            ),
          ).thenReturn(false);
          when(
            () => archiver.validStructureByBytes(
              bytes: dangerousByte,
              structure: ['log4j2.xml'],
            ),
          ).thenReturn(false);

          when(() => dangerousDir.list()).thenAnswer(
            (_) => Stream.fromIterable(
              [
                dangerousFile,
              ],
            ),
          ); // No file, Nothing
          when(() => fileSystem.directory('dangerous'))
              .thenReturn(dangerousDir);

          expect(
            await repository.analyzeDirectory(directory: 'dangerous'),
            JarArchiveInfo(type: JarType.unknown, executable: dangerousPath),
          );
        },
      );
    });
  });
}
