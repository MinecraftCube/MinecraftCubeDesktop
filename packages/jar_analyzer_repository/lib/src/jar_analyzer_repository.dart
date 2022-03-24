import 'dart:typed_data';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

class JarAnalyzerRepository {
  JarAnalyzerRepository({
    FileSystem? fileSystem,
    Archiver? archiver,
  })  : _fileSystem = fileSystem ?? const LocalFileSystem(),
        _archiver = archiver ?? Archiver();
  final FileSystem _fileSystem;
  final Archiver _archiver;

  /// Get [JarArchiveInfo] from a zip(jar) file.
  ///
  /// Support [JarType.vanilla], [JarType.forge], [JarType.forgeInstaller]. Otherwise [JarType.unknown].
  Future<JarArchiveInfo?> analyzeDirectory({
    required String directory,
    // bool? debugable,
  }) async {
    Directory dir = _fileSystem.directory(directory);
    File? vanilla;
    File? forge;
    File? forgeInstaller;
    File? dangerous;
    await for (FileSystemEntity entity in dir.list()) {
      if (entity is File && entity.basename.endsWith('.jar')) {
        final bytes = await entity.readAsBytes();
        JarType type = _classifyJarFile(bytes);
        if (type == JarType.vanilla) {
          vanilla = entity;
        } else if (type == JarType.forge) {
          forge = entity;
        } else if (type == JarType.forgeInstaller) {
          forgeInstaller = entity;
        } else {
          dangerous = entity;
        }
      }
    }
    // Forge is the highest order to return.
    if (forge != null) {
      return JarArchiveInfo(
        type: JarType.forge,
        executable: forge.path,
      );
    } else if (forgeInstaller != null) {
      return JarArchiveInfo(
        type: JarType.forgeInstaller,
        executable: forgeInstaller.path,
      );
    } else if (vanilla != null) {
      return JarArchiveInfo(
        type: JarType.vanilla,
        executable: vanilla.path,
      );
    } else if (dangerous != null) {
      return JarArchiveInfo(
        type: JarType.unknown,
        executable: dangerous.path,
      );
    }
    return null;
  }

  /// Get [JarType] from a zip(jar) file with bytes.
  ///
  /// Support [JarType.vanilla], [JarType.forge], [JarType.forgeInstaller]. Otherwise [JarType.unknown].
  JarType _classifyJarFile(Uint8List bytes) {
    const vanillaRule = [
      ['net', 'minecraft']
    ];
    const forgeInstallerRule = [
      [
        'net',
        'minecraftforge',
      ]
    ];
    const forgeRule = [
      ...forgeInstallerRule,
      ['log4j2.xml']
    ];

    validator(List<List<String>> allRules) {
      bool result = true;
      if (allRules.isEmpty) return false;
      for (List<String> rules in allRules) {
        result &=
            _archiver.validStructureByBytes(bytes: bytes, structure: rules);
      }
      return result;
    }

    try {
      if (validator(forgeRule)) return JarType.forge; // net/minecraftforge
      if (validator(forgeInstallerRule)) {
        return JarType.forgeInstaller; // log4j2.xml
      }
      if (validator(vanillaRule)) return JarType.vanilla; // net/minecraft
    } catch (err) {
      return JarType.unknown;
    }
    return JarType.unknown;
  }
}
