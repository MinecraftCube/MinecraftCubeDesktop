import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

/// An Archiver utility on zip file
class Archiver {
  final FileSystem _fileSystem;
  final ZipDecoder _zipDecoder;
  Archiver({
    FileSystem? fileSystem,
    ZipDecoder? zipDecoder,
  })  : _fileSystem = fileSystem ?? const LocalFileSystem(),
        _zipDecoder = zipDecoder ?? ZipDecoder();

  /// Unzip a zip file on specified path.
  Future<void> unzip({
    required String zipPath,
    required String toPath,
  }) async {
    // Decode the Zip file
    final bytes = _fileSystem.file(zipPath).readAsBytesSync();
    final Archive archive = _zipDecoder.decodeBytes(bytes);
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      final location = join(toPath, filename);
      if (file.isFile) {
        final data = file.content as List<int>;
        File newFile = _fileSystem.file(location);
        await newFile.create(recursive: true);
        await newFile.writeAsBytes(data);
      } else {
        await _fileSystem.directory(location).create(recursive: true);
      }
    }
  }

  /// Valid a zip file with specified structure
  Future<bool> validStructure({
    required String zipPath,
    required List<String> structure,
  }) async {
    final bytes = await _fileSystem.file(zipPath).readAsBytes();
    return validStructureByBytes(bytes: bytes, structure: structure);
  }

  /// Valid a zip file with bytes with specified structure
  bool validStructureByBytes({
    required Uint8List bytes,
    required List<String> structure,
  }) {
    final Archive archive = ZipDecoder().decodeBytes(bytes);

    final RegExp validator =
        RegExp(structure.join('/')); // source replace all \\ to /

    for (final file in archive) {
      final filename = file.name;
      // if (file.isFile && filename == structure.join('/')) {
      //   return true;
      // } else if (!file.isFile && filename == structure.join('/') + '/') {
      //   return true;
      // }
      if (validator.hasMatch(filename)) return true;
    }
    return false;
  }
}
