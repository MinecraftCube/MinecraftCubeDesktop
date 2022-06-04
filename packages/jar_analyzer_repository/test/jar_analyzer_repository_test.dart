import 'dart:typed_data';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jar_analyzer_repository/jar_analyzer_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockArchiver extends Mock implements Archiver {}

class MockPlatform extends Mock implements Platform {}

void main() {
  group('JarAnalyzerRepository', () {
    late FileSystem fileSystem;
    late Archiver archiver;
    late Platform platform;
    late JarAnalyzerRepository repository;

    setUp(() {
      fileSystem = MockFileSystem();
      archiver = MockArchiver();
      platform = MockPlatform();
      repository = JarAnalyzerRepository(
        fileSystem: fileSystem,
        archiver: archiver,
        platform: platform,
      );
    });

    group('constructor', () {
      test('instantiates internal filesystem when not injected', () {
        expect(JarAnalyzerRepository(), isNotNull);
      });
    });

    group('analyzeDirectory', () {
      late Directory emptyDir;
      // use Windows by default
      setUp(() {
        when(() => platform.isWindows).thenReturn(true);
        emptyDir = MockDirectory();
        when(() => emptyDir.list(recursive: any(named: 'recursive')))
            .thenAnswer((_) => Stream.fromIterable([])); // No file, Nothing
        when(() => emptyDir.exists()).thenAnswer((_) async => false);
      });

      test(
        'return null when there is nothing in dir',
        () async {
          when(() => fileSystem.directory('empty')).thenReturn(emptyDir);
          when(() => emptyDir.childDirectory(any())).thenReturn(emptyDir);

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
          when(() => vanillaDir.childDirectory(any())).thenReturn(emptyDir);

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
          when(() => forgeInstallerDir.childDirectory(any()))
              .thenReturn(emptyDir);

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
        'return forge on forge dir (before 1.18.2)',
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
          when(() => forgeInstallerDir.childDirectory(any()))
              .thenReturn(emptyDir);

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
          when(() => dangerousDir.childDirectory(any())).thenReturn(emptyDir);

          expect(
            await repository.analyzeDirectory(directory: 'dangerous'),
            JarArchiveInfo(type: JarType.unknown, executable: dangerousPath),
          );
        },
      );
    });

    group('special case on forge1182', () {
      final forgeInstallerDir = MockDirectory();
      setUp(() {
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
        when(() => forgeFile.readAsBytes()).thenAnswer((_) async => forgeByte);
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
        ).thenReturn(false);
        when(
          () => archiver.validStructureByBytes(
            bytes: forgeByte,
            structure: ['log4j2.xml'],
          ),
        ).thenReturn(false);

        when(() => forgeInstallerDir.list()).thenAnswer(
          (_) => Stream.fromIterable(
            [forgeInstallerFile, forgeFile],
          ),
        );
        when(() => fileSystem.directory('forge_after_1182'))
            .thenReturn(forgeInstallerDir);
      });
      group('[windows]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(true);
        });
        test('return forge1182 on forge dir (after 1.18.2)', () async {
          final targetDir = MockDirectory();
          final targetFile = MockFile();
          when(() => forgeInstallerDir.childDirectory(captureAny()))
              .thenReturn(targetDir);
          when(() => targetFile.basename).thenReturn('win_args.txt');
          when(() => targetFile.path).thenReturn(p.join('123', 'win_args.txt'));
          when(() => targetDir.list(recursive: true))
              .thenAnswer((_) => Stream.fromIterable([targetFile]));
          when(() => targetDir.exists()).thenAnswer((_) async => true);
          expect(
            await repository.analyzeDirectory(directory: 'forge_after_1182'),
            JarArchiveInfo(
              type: JarType.forge1182,
              executable: p.join('123', 'win_args.txt'),
            ),
          );
          expect(
              verify(() => forgeInstallerDir.childDirectory(captureAny()))
                  .captured,
              [
                p.join('libraries', 'net', 'minecraftforge', 'forge'),
              ]);
        });
      });
      group(['others'], () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(false);
        });
        test('return forge1182 on forge dir (after 1.18.2)', () async {
          final targetDir = MockDirectory();
          final targetFile = MockFile();
          when(() => forgeInstallerDir.childDirectory(captureAny()))
              .thenReturn(targetDir);
          when(() => targetFile.basename).thenReturn('unix_args.txt');
          when(() => targetFile.path)
              .thenReturn(p.join('123', 'unix_args.txt'));
          when(() => targetDir.list(recursive: true))
              .thenAnswer((_) => Stream.fromIterable([targetFile]));
          when(() => targetDir.exists()).thenAnswer((_) async => true);

          expect(
            await repository.analyzeDirectory(directory: 'forge_after_1182'),
            JarArchiveInfo(
              type: JarType.forge1182,
              executable: p.join('123', 'unix_args.txt'),
            ),
          );
          expect(
              verify(() => forgeInstallerDir.childDirectory(captureAny()))
                  .captured,
              [
                p.join('libraries', 'net', 'minecraftforge', 'forge'),
              ]);
        });
      });
    });
  });
}
