import 'package:dio/dio.dart';
import 'package:system_repository/vanilla_server_repository.dart';

class VanillaServerRepository {
  VanillaServerRepository({
    Dio? dio,
  }) : dio = dio ?? Dio();

  static const _manifestUrl =
      'https://launchermeta.mojang.com/mc/game/version_manifest_v2.json';

  final Dio dio;

  Future<List<VanillaManifestVersionInfo>> getServers() async {
    final response = await dio.get(_manifestUrl);

    final vanillaManifestInfo = VanillaManifestInfo.fromJson(response.data);

    return vanillaManifestInfo.versions;
  }

  Future<VanillaServerDownloadsServerInfo> getServerByVersionInfo({
    required String url,
  }) async {
    final response = await dio.get(url);

    final vanillaServerInfo = VanillaServerInfo.fromJson(response.data);

    return vanillaServerInfo.downloads.server;
  }
}
