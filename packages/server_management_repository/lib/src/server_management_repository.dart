import 'dart:async';
import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;
import 'package:server_management_repository/src/installer_file.dart';

class ServerCloseUnexpectedException implements Exception {}

class ServerManagementRepository {
  ServerManagementRepository({
    // JarAnalyzerRepository? jarAnalyzerRepository,
    FileSystem? fileSystem,
  }) : _fileSystem = fileSystem ?? const LocalFileSystem();
  // _jarAnalyzerRepository = jarAnalyzerRepository ??
  //     JarAnalyzerRepository(fileSystem: fileSystem);
  final FileSystem _fileSystem;
  // final JarAnalyzerRepository _jarAnalyzerRepository;
  Directory get _serversDir => _fileSystem.directory(p.join('servers'));
  Directory get _installersDir => _fileSystem.directory(p.join('installers'));

  Future<String> createServersDir() async {
    final serverDir = _serversDir;
    await serverDir.create(recursive: true);
    return serverDir.absolute.path;
  }

  Stream<String> getServers() async* {
    final serverDir = _serversDir;
    if (!await serverDir.exists()) return;
    await for (final projectDir in serverDir.list()) {
      if (projectDir is Directory) {
        // Bad performance,
        // If an extension is .jar then at least unknown, so just check the extension.
        // final info = await _jarAnalyzerRepository.analyzeDirectory(
        //   directory: projectDir.path,
        // );
        // if(info == null) yield projectDir.absolute.path;
        // if (info != null) yield projectDir.path;
        bool containedJar = false;
        await for (final file in projectDir.list()) {
          if (file is File) {
            if (file.path.endsWith('.jar')) {
              containedJar = true;
            }
          }
        }
        if (containedJar) {
          yield projectDir.path;
        }
      }
    }
  }

  Future<String> createInstallersDir({String? subfolder}) async {
    Directory installerDir = _installersDir;

    if (subfolder != null && subfolder.isNotEmpty) {
      installerDir = installerDir.childDirectory(subfolder);
    }

    await installerDir.create(recursive: true);

    return installerDir.absolute.path;
  }

  Stream<InstallerFile> getInstallers() async* {
    final installerDir = _installersDir;
    if (!await installerDir.exists()) return;
    await for (final installerFile in installerDir.list(recursive: true)) {
      if (installerFile is File) {
        try {
          final raw = await installerFile.readAsString();
          Installer installer = Installer.fromJson(jsonDecode(raw));
          // yield InstallerFile(installer: installer, path: installerFile.absolute.path);
          yield InstallerFile(installer: installer, path: installerFile.path);
        } catch (_) {
          // ignore parse failure
        }
      }
    }
  }
}
