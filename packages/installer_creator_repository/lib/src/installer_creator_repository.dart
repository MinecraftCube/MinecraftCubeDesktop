import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;

// NOTE: support content-disposition someday
// ex. content-disposition: attachment; filename="mahoshojo.zip"; filename*=UTF-8''mahoshojo.zip

enum SetupStatus { download, createFolder, extract, complete, unknown }

class MissingProjectFolderException implements Exception {}

class InstallerCreatorRepository {
  final FileSystem _fileSystem;

  const InstallerCreatorRepository({
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();

  Future<MapEntry<String, Installer>> create({
    required String name,
    required String description,
    required String server,
    required JarType type,
    required String map,
    required List<ModelSetting> settings,
    required ModelPack? pack,
    String? subfolder,
  }) async {
    String path = p.join('installers', '$name.dmc');
    if (subfolder != null && subfolder.isNotEmpty) {
      path = p.join('installers', subfolder, '$name.dmc');
    }
    final file = _fileSystem.file(path);
    await file.create(recursive: true);
    final installer = Installer(
      name,
      description,
      type,
      server,
      mapZipPath: map,
      modelPack: pack,
      modelSettings: settings,
    );
    final raw = jsonEncode(installer.toJson());
    await file.writeAsString(raw);

    return MapEntry(file.absolute.path, installer);
  }
}
