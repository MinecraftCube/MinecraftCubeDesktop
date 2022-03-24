import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

class DuplicateCleanerRepository {
  DuplicateCleanerRepository({
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();
  final FileSystem _fileSystem;
  // ignore: constant_identifier_names, non_constant_identifier_names
  final JAVA_PORTABLE_FOLDER = 'java';

  Future<void> deleteCubeJava() async {
    // target bin/cube_java
    final currentDir = _fileSystem.directory(
      join(_fileSystem.currentDirectory.path, JAVA_PORTABLE_FOLDER),
    );
    if (!await currentDir.exists()) return;

    final files = <File>[];
    final reg = RegExp(r'bin[\/|\\|]+cube_java[^\/|\\]*$');
    await for (final entity in currentDir.list(recursive: true)) {
      if (entity is File) {
        final path = entity.path;
        if (reg.hasMatch(path)) files.add(entity);
      }
    }
    for (final file in files) {
      await file.delete();
    }
  }
}
