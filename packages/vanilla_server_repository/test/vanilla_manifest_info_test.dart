import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

void main() {
  group('VanillaManifestInfo', () {
    test('fromJson', () {
      final result =
          VanillaManifestInfo.fromJson(jsonDecode(givenVanillaManifestInfo));

      final expectedVersion = [
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
      expect(result, VanillaManifestInfo(versions: expectedVersion));
    });
  });
}

const givenVanillaManifestInfo = r'''
{
  "latest": {
    "release": "1.19.3",
    "snapshot": "23w04a"
  },
  "versions": [
    {
      "id": "23w04a",
      "type": "snapshot",
      "url": "https://piston-meta.mojang.com/v1/packages/6805751cb57fcb5a2f6fc24740d22b073e1536be/23w04a.json",
      "time": "2023-01-24T15:28:36+00:00",
      "releaseTime": "2023-01-24T15:19:06+00:00",
      "sha1": "6805751cb57fcb5a2f6fc24740d22b073e1536be",
      "complianceLevel": 1
    },
    {
      "id": "23w03a",
      "type": "snapshot",
      "url": "https://piston-meta.mojang.com/v1/packages/b249a6b019b786da691980ae0489f881abf21718/23w03a.json",
      "time": "2023-01-24T14:49:13+00:00",
      "releaseTime": "2023-01-18T13:10:31+00:00",
      "sha1": "b249a6b019b786da691980ae0489f881abf21718",
      "complianceLevel": 0
    },
    {
      "id": "1.19.3",
      "type": "release",
      "url": "https://piston-meta.mojang.com/v1/packages/ff7960c2739033d6439f660ed11999322e6e6e99/1.19.3.json",
      "time": "2023-01-24T14:49:13+00:00",
      "releaseTime": "2022-12-07T08:17:18+00:00",
      "sha1": "ff7960c2739033d6439f660ed11999322e6e6e99",
      "complianceLevel": 1
    }
  ]
}
''';
