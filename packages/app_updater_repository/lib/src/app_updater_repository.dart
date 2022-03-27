import 'package:dio/dio.dart';
import 'package:version/version.dart';

/// Compare basic version / Expose release note
///
/// From: https://github.com/MinecraftCube/MinecraftCubeDesktop/tree/version_info
class AppUpdaterRepository {
  AppUpdaterRepository({Dio? dio}) : _dio = dio ?? Dio();
  final Dio _dio;

  Future<bool> hasGreaterVersion({required String version}) async {
    final Version appVersion = Version.parse(version);
    final versionResponse = await _dio.get<String>(
      'https://raw.githubusercontent.com/MinecraftCube/MinecraftCubeDesktop/version_info/version',
    );
    final rawLatestVersion = versionResponse.data;
    if (rawLatestVersion == null) return false;

    final Version latestVersion = Version.parse(rawLatestVersion);
    return latestVersion > appVersion;
  }

  Future<String?> getLatestRelease({required String fullLocale}) async {
    final latestReleaseUrl =
        'https://raw.githubusercontent.com/MinecraftCube/MinecraftCubeDesktop/version_info/$fullLocale/LATEST_RELEASE.md';
    final latestNoteResponse = await _dio.get<String>(latestReleaseUrl);
    return latestNoteResponse.data;
  }

  // Another support, skip version...
}
