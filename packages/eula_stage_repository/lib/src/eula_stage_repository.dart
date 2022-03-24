import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class EulaStageRepository {
  EulaStageRepository({
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();
  final FileSystem _fileSystem;

  Future<bool> checkEulaAt({required String folder}) async {
    Directory dir = _fileSystem.directory(folder);
    if (!await dir.exists()) return false;
    File file = _fileSystem.file(join(folder, 'eula.txt'));
    if (!await file.exists()) return false;
    final content = await file.readAsString();
    RegExp validEulaReg = RegExp(r'^eula=true\ *$', multiLine: true);
    return validEulaReg.hasMatch(content);
  }

  Future<void> writeEulaAt({required String folder}) async {
    Directory dir = _fileSystem.directory(folder);
    if (!await dir.exists()) await dir.create(recursive: true);
    File file = _fileSystem.file(join(folder, 'eula.txt'));
    await file.create();
    await file.writeAsString(_generateEulaTemplate());
  }
}

String _generateEulaTemplate() {
  final currentCST = DateTime.now().toUtc().subtract(const Duration(hours: 6));
  return '''#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#${DateFormat(r"EEE MMM d HH:mm:ss 'CST' yyyy").format(currentCST)}
eula=true''';
}
