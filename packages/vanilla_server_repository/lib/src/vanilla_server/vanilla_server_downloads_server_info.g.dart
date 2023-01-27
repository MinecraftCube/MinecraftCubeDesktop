// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vanilla_server_downloads_server_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VanillaServerDownloadsServerInfo _$VanillaServerDownloadsServerInfoFromJson(
        Map<String, dynamic> json) =>
    VanillaServerDownloadsServerInfo(
      sha1: json['sha1'] as String,
      size: json['size'] as int,
      url: json['url'] as String,
    );

Map<String, dynamic> _$VanillaServerDownloadsServerInfoToJson(
        VanillaServerDownloadsServerInfo instance) =>
    <String, dynamic>{
      'sha1': instance.sha1,
      'size': instance.size,
      'url': instance.url,
    };
