import 'package:archive/archive.dart';
import 'package:cube_api/cube_api.dart';
import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;

// NOTE: support content-disposition someday
// ex. content-disposition: attachment; filename="mahoshojo.zip"; filename*=UTF-8''mahoshojo.zip

enum SetupStatus { download, createFolder, extract, complete, unknown }

class MissingProjectFolderException implements Exception {}

class InstallerRepository {
  final FileSystem _fileSystem;
  final Archiver _archiver;
  final Dio _dio;

  InstallerRepository({
    FileSystem? fileSystem,
    Archiver? archiver,
    Dio? dio,
  })  : _fileSystem = fileSystem ?? const LocalFileSystem(),
        _archiver = archiver ??
            Archiver(
              fileSystem: fileSystem ?? const LocalFileSystem(),
              zipDecoder: ZipDecoder(),
            ),
        _dio = dio ?? Dio();

  Directory getProjectDir(String projectName) {
    return _fileSystem.directory(
      p.join(
        'servers',
        projectName,
      ),
    );
  }

  Future<String> createProject({required String projectName}) async {
    Directory projectDir = getProjectDir(projectName);
    await projectDir.create(recursive: true);
    return projectDir.path;
  }

  Stream<SetupStatus> installServer({
    required String url,
    required String projectName,
  }) async* {
    await _checkProjectFolder(projectName: projectName);
    yield SetupStatus.download;
    Directory projectDir = getProjectDir(projectName);
    await _dio.download(url, p.join(projectDir.path, 'server.jar'));
    yield SetupStatus.complete;
  }

  /// Download map with [url] and extract to [projectName] server directory.
  ///
  /// [url] should be a direct download link.
  /// [projectName] is the folder name
  /// map.zip should contain **world** folder, and can also contain server.properties for convenience
  ///
  Stream<SetupStatus> installMap({
    required String url,
    required String projectName,
  }) async* {
    await _checkProjectFolder(projectName: projectName);
    yield SetupStatus.download;
    Directory projectDir = getProjectDir(projectName);
    final originalFilePath = p.join(projectDir.path, 'tempMap', 'map.zip');
    await _dio.download(url, originalFilePath);
    yield SetupStatus.extract;
    await _archiver.unzip(
      zipPath: originalFilePath,
      toPath: projectDir.path,
    );
    yield SetupStatus.complete;
  }

  Stream<SetupStatus> installMod({
    required String url,
    required String modName,
    required String projectName,
  }) async* {
    await _checkProjectFolder(projectName: projectName);
    Directory projectDir = getProjectDir(projectName);
    final originalFilePath = p.join(projectDir.path, 'mods', modName);
    // yield* _createModsFolder(projectDir);
    yield SetupStatus.download;
    await _dio.download(url, originalFilePath);
    yield SetupStatus.complete;
  }

  Stream<SetupStatus> installModpack({
    required String url,
    required String projectName,
  }) async* {
    await _checkProjectFolder(projectName: projectName);
    Directory projectDir = getProjectDir(projectName);
    final originalFilePath = p.join(projectDir.path, 'tempMods', 'mods.zip');
    // yield* _createModsFolder(projectDir);
    yield SetupStatus.download;
    await _dio.download(url, originalFilePath);
    yield SetupStatus.extract;
    await _archiver.unzip(
      zipPath: originalFilePath,
      toPath: p.join(projectDir.path, 'mods'),
    );
    yield SetupStatus.complete;
  }

  Future<void> copyInstaller({
    required String installerPath,
    required String projectName,
  }) async {
    File file = _fileSystem.file(installerPath);
    if (!await file.exists()) return;
    await _fileSystem
        .directory(p.join('servers', projectName))
        .create(recursive: true);
    await file.copy(
      p.join('servers', projectName, file.basename),
    );
  }

  // dio.download will create the folder by default
  // Stream<SetupStatus> _createModsFolder(Directory projectDir) async* {
  //   final modsDirPath = p.join(projectDir.path, 'mods');
  //   Directory modDir = _fileSystem.directory(modsDirPath);
  //   if (await modDir.exists()) return;
  //   yield SetupStatus.createFolder;
  //   await modDir.create();
  // }

  Future<void> _checkProjectFolder({required String projectName}) async {
    Directory dir = getProjectDir(projectName);
    if (!await dir.exists()) throw MissingProjectFolderException();
    return;
  }
}
