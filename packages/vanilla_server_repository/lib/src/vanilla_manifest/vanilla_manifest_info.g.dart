// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vanilla_manifest_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VanillaManifestInfo _$VanillaManifestInfoFromJson(Map<String, dynamic> json) =>
    VanillaManifestInfo(
      versions: (json['versions'] as List<dynamic>)
          .map((e) =>
              VanillaManifestVersionInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VanillaManifestInfoToJson(
        VanillaManifestInfo instance) =>
    <String, dynamic>{
      'versions': instance.versions,
    };
