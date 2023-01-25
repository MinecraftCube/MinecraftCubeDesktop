import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:system_repository/vanilla_server_repository.dart';

import 'vanilla_manifest_info_test.dart' show givenVanillaManifestInfo;
import 'vanilla_server_info_test.dart' show givenVanillaServerInfo;

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  final givenVanillaManifestInfoMap = jsonDecode(givenVanillaManifestInfo);
  final givenVanillaServerInfoMap = jsonDecode(givenVanillaServerInfo);
  group('VanillaServerRepository', () {
    // late Platform platform;
    // late ProcessManager processManager;
    late Dio mockDio;
    late VanillaServerRepository repository;

    setUp(
      () {
        mockDio = MockDio();
        repository = VanillaServerRepository(dio: mockDio);
      },
    );

    group('constructor', () {
      test('instantiates successfully when not injected', () {
        expect(VanillaServerRepository(), isNotNull);
      });
    });

    group('getServers', () {
      test(
          'Given successfully response from mock api '
          'When calling getServers '
          'Then should return a list of [VanillaManifestVersionInfo]',
          () async {
        final response = MockResponse();
        when(() => mockDio.get(any())).thenAnswer((_) async => response);
        when(() => response.data).thenReturn(givenVanillaManifestInfoMap);

        final results = await repository.getServers();

        final expectedVersions = [
          VanillaManifestVersionInfo(
            id: '23w04a',
            type: 'snapshot',
            url:
                'https://piston-meta.mojang.com/v1/packages/6805751cb57fcb5a2f6fc24740d22b073e1536be/23w04a.json',
            time: DateTime.utc(2023, 1, 24, 15, 28, 36),
            releaseTime: DateTime.utc(2023, 1, 24, 15, 19, 6),
          ),
          VanillaManifestVersionInfo(
            id: '23w03a',
            type: 'snapshot',
            url:
                'https://piston-meta.mojang.com/v1/packages/b249a6b019b786da691980ae0489f881abf21718/23w03a.json',
            time: DateTime.utc(2023, 1, 24, 14, 49, 13),
            releaseTime: DateTime.utc(2023, 1, 18, 13, 10, 31),
          ),
          VanillaManifestVersionInfo(
            id: '1.19.3',
            type: 'release',
            url:
                'https://piston-meta.mojang.com/v1/packages/ff7960c2739033d6439f660ed11999322e6e6e99/1.19.3.json',
            time: DateTime.utc(2023, 1, 24, 14, 49, 13),
            releaseTime: DateTime.utc(2022, 12, 7, 8, 17, 18),
          ),
        ];
        expect(results, expectedVersions);
      });
    });

    group('getServerByVersionInfo', () {
      test(
          'Given successfully response from mock api '
          'When calling [getServerByVersionInfo] with correct url'
          'Then should return [VanillaServerDownloadsServerInfo]', () async {
        const url =
            'https://piston-meta.mojang.com/v1/packages/6805751cb57fcb5a2f6fc24740d22b073e1536be/23w04a.json';
        final response = MockResponse();
        when(() => mockDio.get(url)).thenAnswer((_) async => response);
        when(() => response.data).thenReturn(givenVanillaServerInfoMap);

        final result = await repository.getServerByVersionInfo(url: url);

        const expected = VanillaServerDownloadsServerInfo(
          sha1: '2f31a8584ec1e70abd2d8b22d976feb52a6a3e31',
          size: 47275073,
          url:
              'https://piston-data.mojang.com/v1/objects/2f31a8584ec1e70abd2d8b22d976feb52a6a3e31/server.jar',
        );
        expect(result, expected);
      });
    });
  });
}
