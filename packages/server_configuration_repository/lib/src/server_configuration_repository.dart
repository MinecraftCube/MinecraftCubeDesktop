import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;

class ServerConfigurationRepository {
  ServerConfigurationRepository({
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();
  final FileSystem _fileSystem;

  Future<ServerConfiguration?> getConfiguration({
    required String directory,
  }) async {
    final file = _fileSystem.file(
      p.join(directory, 'cube.conf'),
    );
    if (!await file.exists()) return null;
    return ServerConfiguration.fromJson(
      jsonDecode(await file.readAsString()),
    );
  }

  Future<void> saveConfiguration({
    required String directory,
    required ServerConfiguration configuration,
  }) async {
    final file = _fileSystem.file(
      p.join(directory, 'cube.conf'),
    );
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(configuration.toJson()));
  }
}
