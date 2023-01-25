// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vanilla_manifest_version_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VanillaManifestVersionInfo _$VanillaManifestVersionInfoFromJson(
        Map<String, dynamic> json) =>
    VanillaManifestVersionInfo(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      time: DateTime.parse(json['time'] as String),
      releaseTime: DateTime.parse(json['releaseTime'] as String),
    );

Map<String, dynamic> _$VanillaManifestVersionInfoToJson(
        VanillaManifestVersionInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'url': instance.url,
      'time': instance.time.toIso8601String(),
      'releaseTime': instance.releaseTime.toIso8601String(),
    };
