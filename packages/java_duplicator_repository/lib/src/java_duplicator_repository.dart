import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;

class JavaDuplicatorRepository {
  JavaDuplicatorRepository({
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();
  final FileSystem _fileSystem;

  Future<String> cloneCubeJava({required String javaExecutablePath}) async {
    // target bin/cube_java
    if (javaExecutablePath == 'java') return javaExecutablePath;
    final file = _fileSystem.file(
      javaExecutablePath,
    );
    if (!await file.exists()) return javaExecutablePath;

    final isContainExe = file.basename.contains('.exe');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final copiedFile = await file.copy(
      p.join(file.dirname, 'cube_java_$timestamp${isContainExe ? '.exe' : ''}'),
    );
    // This MUST be absolute path. If this is relative path someday, reconsturct the test and relative pipeline...
    return copiedFile.absolute.path;
  }
}
